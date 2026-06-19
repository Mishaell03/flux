import 'package:flutter/material.dart';
import 'package:front/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Center(
        child: Text(t.appTitle),
      ),
    );
  }
}