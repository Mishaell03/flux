import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/notes/services/note_voice_record_service.dart';

class NoteVoiceRecordSheet extends StatefulWidget {
  final String noteId;

  const NoteVoiceRecordSheet({
    super.key,
    required this.noteId,
  });

  @override
  State<NoteVoiceRecordSheet> createState() => _NoteVoiceRecordSheetState();
}

class _NoteVoiceRecordSheetState extends State<NoteVoiceRecordSheet> {
  final NoteVoiceRecordService _service = NoteVoiceRecordService();

  Timer? _timer;
  Duration _duration = Duration.zero;
  DateTime? _startedAt;
  bool _starting = true;
  bool _stopping = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _start();
    });
  }

  Future<void> _start() async {
    try {
      await _service.start();

      if (!mounted) return;

      _startedAt = DateTime.now();

      _timer = Timer.periodic(
        const Duration(milliseconds: 300),
        (_) {
          final startedAt = _startedAt;

          if (startedAt == null || !mounted) return;

          setState(() {
            _duration = DateTime.now().difference(startedAt);
          });
        },
      );

      setState(() {
        _starting = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _starting = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _stop() async {
    if (_stopping) return;

    setState(() {
      _stopping = true;
    });

    final result = await _service.stop(
      noteId: widget.noteId,
    );

    if (!mounted) return;

    Navigator.pop<NoteAttachmentCreateResult?>(context, result);
  }

  Future<void> _cancel() async {
    await _service.cancel();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
          child: Column(
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
              const SizedBox(height: 22),
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic_rounded,
                  color: colors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _starting ? 'Подготовка записи...' : 'Идёт запись',
                style: AppText.medium_18a.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDuration(_duration),
                style: AppText.medium_24a.copyWith(
                  color: colors.text,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppText.medium_14a.copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _stopping ? null : _cancel,
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _starting || _error != null || _stopping
                          ? null
                          : _stop,
                      icon: _stopping
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.stop_rounded),
                      label: Text(_stopping ? 'Сохраняю...' : 'Готово'),
                    ),
                  ),
                ],
              ),
            ],
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
