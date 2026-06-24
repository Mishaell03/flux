import 'package:flutter/material.dart';

class AppVerticalScroll extends StatelessWidget {
  final Widget child;
  final double paddingH;
  final double paddingV;
  final ScrollController? controller;
  final bool scrollbar;
  final bool overscroll;
  final bool isCenter;

  const AppVerticalScroll({
    super.key,
    required this.child,
    this.paddingH = 24,
    this.paddingV = 24,
    this.controller,
    this.scrollbar = true,
    this.overscroll = true,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: scrollbar,
        overscroll: overscroll,
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.symmetric(
                  horizontal: paddingH, vertical: paddingV),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constrains.maxHeight - 48,
                ),
                child: isCenter
                    ? Center(
                        child: child,
                      )
                    : child,
              ),
            );
          },
        ),
      ),
    );
  }
}
