import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

class HomeSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const HomeSearch({
    required this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 22,
            color: context.colors.gray,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: context.colors.primary,
              style: AppText.medium_14a.copyWith(
                color: context.colors.text,
              ),
              decoration: InputDecoration(
                hintText: t.homeSearch,
                hintStyle: AppText.medium_14a.copyWith(
                  color: context.colors.gray,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Icon(
              Icons.tune_rounded,
              size: 20,
              color: context.colors.gray,
            ),
          ),
        ],
      ),
    );
  }
}