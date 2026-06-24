import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/widgets/app_footer.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onFooterTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,

      body: navigationShell,

      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 85,
          width: double.infinity,
          child: AppFooter(
            currentIndex: navigationShell.currentIndex,
            onTap: _onFooterTap,
          ),
        ),
      ),
    );
  }
}