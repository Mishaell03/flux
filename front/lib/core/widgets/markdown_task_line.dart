import 'package:flutter/material.dart';

import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/markdown/app_markdown_settings.dart';
import 'package:front/core/components/markdown/markdown_task_line_data.dart';

class MarkdownTaskLine extends StatelessWidget {
  final MarkdownTaskLineData task;
  final VoidCallback onToggle;
  final VoidCallback onTapText;

  const MarkdownTaskLine({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTapText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: task.checked ? colors.primary : colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: task.checked ? colors.primary : colors.border,
                      width: 1.6,
                    ),
                  ),
                  child: task.checked
                      ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: colors.bg,
                  )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapText,
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: AppMarkdownSettings.preview(
                  context: context,
                  data: task.text.trim().isEmpty ? ' ' : task.text,
                  checked: task.checked,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
