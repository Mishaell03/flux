import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

enum AppNoticeType { success, error }

class AppNotice {
  const AppNotice._();

  static OverlayEntry? _currentNotice;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    required AppNoticeType type,
    String? title,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final t = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final colors = context.colors;
    final isError = type == AppNoticeType.error;

    _remove();

    final entry = OverlayEntry(
      builder: (_) {
        return _NoticeWidget(
          message: message,
          type: type,
          title: title ?? (isError ? t.error : t.success),
          width: width,
          topPadding: bottomPadding,
          accentColor: isError ? colors.error : colors.primary,
          backgroundColor: isError
              ? colors.error.withValues(alpha: 0.12)
              : colors.primary.withValues(alpha: 0.12),
          borderColor: (isError ? colors.error : colors.primary)
              .withValues(alpha: 0.6),
          textColor: colors.text.withValues(alpha: 0.9),
          shadowColor: colors.border.withValues(alpha: 0.18),
          transparentColor: colors.transparent,
          onClose: _remove,
        );
      },
    );

    _currentNotice = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(seconds: 7), _remove);
  }

  static void success(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppNoticeType.success,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppNoticeType.error,
    );
  }

  static void _remove() {
    _timer?.cancel();
    _timer = null;

    _currentNotice?.remove();
    _currentNotice = null;
  }
}

class _NoticeWidget extends StatelessWidget {
  final String message;
  final AppNoticeType type;
  final VoidCallback onClose;
  final String title;
  final double width;
  final double topPadding;
  final Color accentColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color shadowColor;
  final Color transparentColor;

  const _NoticeWidget({
    required this.message,
    required this.type,
    required this.onClose,
    required this.title,
    required this.width,
    required this.topPadding,
    required this.accentColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.shadowColor,
    required this.transparentColor,
  });

  bool get isError => type == AppNoticeType.error;

  @override
  Widget build(BuildContext context) {
    final isMore600 = width >= 600;
    final IconData icon = isError
        ? Icons.error_outline_outlined
        : Icons.check_circle_outline_outlined;

    return Positioned(
      left: 16,
      right: 16,
      top: 16 + topPadding,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMore600 ? 520 : double.infinity,
          ),
          child: Material(
            color: transparentColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: accentColor,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppText.medium_18a.copyWith(
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: AppText.medium_14a.copyWith(
                                color: textColor,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: onClose,
                        mouseCursor: SystemMouseCursors.click,
                        icon: Icon(
                          Icons.close,
                          color: textColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
