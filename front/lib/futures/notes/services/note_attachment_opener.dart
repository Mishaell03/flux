import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front/core/attachments/storage/attachment_storage.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/markdown/app_markdown_settings.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';

class NoteAttachmentOpener {
  final AppDatabase db;
  final AttachmentStorage storage;

  NoteAttachmentOpener({
    AppDatabase? db,
    AttachmentStorage? storage,
  })  : db = db ?? DatabaseProvider.instance,
        storage = storage ?? createAttachmentStorage();

  Future<void> open(
    BuildContext context,
    MarkdownAttachmentData attachment,
  ) async {
    final row = await (db.select(db.noteAttachmentsTable)
          ..where((table) => table.id.equals(attachment.hash)))
        .getSingleOrNull();

    if (row == null) {
      _showMessage(context, 'Файл не найден');
      return;
    }

    final localPath = row.localPath;

    if (localPath == null || localPath.isEmpty) {
      _showMessage(context, 'Файл ещё не загружен локально');
      return;
    }

    if (!context.mounted) return;

    if (attachment.isImage) {
      try {
        final bytes = await storage.readBytes(localPath);

        if (!context.mounted) return;

        _openImage(
          context: context,
          bytes: bytes,
        );
      } catch (_) {
        if (!context.mounted) return;
        _showMessage(context, 'Не удалось открыть изображение');
      }

      return;
    }

    if (attachment.isAudio) {
      _openAudio(
        context: context,
        localPath: localPath,
        title: row.fileName ?? 'Голосовое сообщение',
        mimeType: row.mimeType ?? 'audio/wav',
      );
    }
  }

  void _openImage({
    required BuildContext context,
    required Uint8List bytes,
  }) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  color: Colors.black,
                  child: InteractiveViewer(
                    minScale: 0.7,
                    maxScale: 5,
                    child: Center(
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: colors.bg.withValues(alpha: 0.88),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.text,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAudio({
    required BuildContext context,
    required String localPath,
    required String title,
    required String mimeType,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AttachmentAudioSheet(
          localPath: localPath,
          title: title,
          mimeType: mimeType,
          storage: storage,
        );
      },
    );
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class _AttachmentAudioSheet extends StatefulWidget {
  final String localPath;
  final String title;
  final String mimeType;
  final AttachmentStorage storage;

  const _AttachmentAudioSheet({
    required this.localPath,
    required this.title,
    required this.mimeType,
    required this.storage,
  });

  @override
  State<_AttachmentAudioSheet> createState() => _AttachmentAudioSheetState();
}

class _AttachmentAudioSheetState extends State<_AttachmentAudioSheet> {
  late final AudioPlayer _player;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _load();
  }

  Future<void> _load() async {
    try {
      if (_isRealFilePath(widget.localPath)) {
        await _player.setFilePath(widget.localPath);
      } else {
        final bytes = await widget.storage.readBytes(widget.localPath);

        await _player.setAudioSource(
          _BytesAudioSource(
            bytes: bytes,
            mimeType: widget.mimeType,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Не удалось загрузить аудио';
      });
    }
  }

  bool _isRealFilePath(String value) {
    if (value.startsWith('web://')) return false;
    if (value.startsWith('http://')) return false;
    if (value.startsWith('https://')) return false;
    if (value.startsWith('blob:')) return false;

    return value.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(PlayerState? state) async {
    if (_loading || _error != null) return;

    final isCompleted = state?.processingState == ProcessingState.completed;

    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (isCompleted) {
      await _player.seek(Duration.zero);
    }

    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.border,
                width: 1,
              ),
            ),
            child: StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final playing = state?.playing == true;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.gray.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Material(
                          color: colors.primary.withValues(alpha: 0.12),
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 32,
                                  ),
                            color: colors.primary,
                            onPressed: _loading
                                ? null
                                : () => _togglePlay(state),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.medium_16a.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: AppText.medium_14a.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, positionSnapshot) {
                        final position = positionSnapshot.data ?? Duration.zero;
                        final duration = _player.duration ?? Duration.zero;

                        final value = duration.inMilliseconds <= 0
                            ? 0.0
                            : (position.inMilliseconds /
                                    duration.inMilliseconds)
                                .clamp(0.0, 1.0);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LinearProgressIndicator(
                              value: value,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: AppText.medium_14a.copyWith(
                                    color: colors.gray,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: AppText.medium_14a.copyWith(
                                    color: colors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(t.close),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

class _BytesAudioSource extends StreamAudioSource {
  final Uint8List bytes;
  final String mimeType;

  _BytesAudioSource({
    required this.bytes,
    required this.mimeType,
  });

  @override
  Future<StreamAudioResponse> request([
    int? start,
    int? end,
  ]) async {
    final from = (start ?? 0).clamp(0, bytes.length).toInt();
    final to = (end ?? bytes.length).clamp(from, bytes.length).toInt();

    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: to - from,
      offset: from,
      stream: Stream.value(bytes.sublist(from, to)),
      contentType: mimeType,
    );
  }
}