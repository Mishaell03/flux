import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.appTitle,
                style: AppText.bold_30.copyWith(
                  color: context.colors.text,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: context.colors.border,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {},
            color: context.colors.text,
            icon: Icon(
              Icons.notifications_none_rounded,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
