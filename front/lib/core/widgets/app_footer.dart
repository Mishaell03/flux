import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppFooter({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _FooterItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _FooterItemData(
      icon: Icons.note_alt_outlined,
      activeIcon: Icons.note_alt_rounded,
      label: 'Notes',
    ),
    _FooterItemData(
      icon: Icons.hub_outlined,
      activeIcon: Icons.hub_rounded,
      label: 'Graph',
    ),
    _FooterItemData(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: context.colors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final isActive = currentIndex == index;

                  return Expanded(
                    child: _FooterItem(
                      icon: isActive ? item.activeIcon : item.icon,
                      label: item.label,
                      isActive: isActive,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _FooterItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FooterItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.colors.primary : context.colors.gray;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? context.colors.primary.withValues(alpha: 0.10)
              : context.colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 23,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppText.medium_12a.copyWith(
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}