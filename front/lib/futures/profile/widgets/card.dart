import 'package:flutter/cupertino.dart';
import 'package:front/core/components/app_theme.dart';

class ProfileCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ProfileCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
