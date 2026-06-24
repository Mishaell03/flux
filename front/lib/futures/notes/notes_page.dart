import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.bg,
        body: Center(child: Text( 'Разработка')));
  }
}