import 'package:flutter/material.dart';

import 'package:front/core/components/app_theme.dart';
import 'package:front/core/widgets/markdown_live_editor.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({
    super.key,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  String _content = '''
# Моя заметка

Обычный **markdown** текст.

- [ ] Не выполненная задача
- [x] Выполненная задача

> Цитата

`inline code`
''';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: MarkdownLiveEditor(
          initialText: _content,
          onChanged: (value) {
            _content = value;
          },
        ),
      ),
    );
  }
}