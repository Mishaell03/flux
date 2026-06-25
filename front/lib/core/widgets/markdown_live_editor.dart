import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/markdown/app_markdown_settings.dart';
import 'package:front/core/components/markdown/markdown_task_line_data.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/router/link_handler.dart';
import 'package:front/core/widgets/markdown_task_line.dart';

class MarkdownLiveEditor extends StatefulWidget {
  final String initialText;
  final ValueChanged<String> onChanged;
  final List<String> noteSuggestions;
  final EdgeInsets padding;

  const MarkdownLiveEditor({
    super.key,
    required this.initialText,
    required this.onChanged,
    this.noteSuggestions = const [],
    this.padding = const EdgeInsets.all(20),
  });

  @override
  State<MarkdownLiveEditor> createState() => _MarkdownLiveEditorState();
}

class _MarkdownLiveEditorState extends State<MarkdownLiveEditor> {
  late List<String> _lines;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int? _activeLineIndex;

  @override
  void initState() {
    super.initState();

    _lines = _splitText(widget.initialText);
    _createEditingObjects();
  }

  @override
  void didUpdateWidget(covariant MarkdownLiveEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentText = _lines.join('\n');

    if (oldWidget.initialText != widget.initialText &&
        widget.initialText != currentText) {
      _disposeEditingObjects();

      _lines = _splitText(widget.initialText);
      _activeLineIndex = null;

      _createEditingObjects();
    }
  }

  @override
  void dispose() {
    _disposeEditingObjects();
    super.dispose();
  }

  List<String> _splitText(String text) {
    if (text.isEmpty) return [''];

    final lines = text.split('\n');

    if (lines.isEmpty) return [''];

    return lines;
  }

  void _createEditingObjects() {
    _controllers = _lines
        .map(
          (line) => TextEditingController(text: line),
        )
        .toList();

    _focusNodes = List.generate(
      _lines.length,
      (_) => FocusNode(),
    );
  }

  void _disposeEditingObjects() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }

  void _rebuildEditingObjects() {
    _disposeEditingObjects();
    _createEditingObjects();
  }

  void _notifyChanged() {
    widget.onChanged(_lines.join('\n'));
  }

  void _activateLine(
    int index, {
    bool cursorAtEnd = false,
  }) {
    if (_lines.isEmpty) {
      setState(() {
        _lines = [''];
        _rebuildEditingObjects();
      });
    }

    if (index < 0 || index >= _lines.length) return;

    setState(() {
      _activeLineIndex = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (index < 0 || index >= _focusNodes.length) return;

      final controller = _controllers[index];

      final offset = cursorAtEnd ? controller.text.length : 0;

      _focusNodes[index].requestFocus();

      controller.selection = TextSelection.collapsed(
        offset: offset,
      );
    });
  }

  void _activateLastLine() {
    if (_lines.isEmpty) {
      setState(() {
        _lines = [''];
        _rebuildEditingObjects();
      });

      _notifyChanged();
    }

    _activateLine(
      _lines.length - 1,
      cursorAtEnd: true,
    );
  }

  void _handleLineChanged(int index, String value) {
    if (index < 0 || index >= _lines.length) return;

    if (value.contains('\n')) {
      final parts = value.split('\n');

      setState(() {
        _lines[index] = parts.first;
        _lines.insertAll(
          index + 1,
          parts.skip(1),
        );

        _activeLineIndex = index + parts.length - 1;

        _rebuildEditingObjects();
      });

      _notifyChanged();

      _activateLine(
        _activeLineIndex!,
        cursorAtEnd: true,
      );

      return;
    }

    setState(() {
      _lines[index] = value;
    });

    _notifyChanged();
  }

  List<String> _suggestionsForLine(int index) {
    if (index < 0 || index >= _controllers.length) return [];

    final controller = _controllers[index];
    final selection = controller.selection;

    if (!selection.isValid || !selection.isCollapsed) return [];

    final cursorOffset = selection.baseOffset.clamp(0, controller.text.length);
    final beforeCursor = controller.text.substring(0, cursorOffset);
    final linkStart = beforeCursor.lastIndexOf('[[');

    if (linkStart < 0) return [];

    final afterLinkStart = beforeCursor.substring(linkStart + 2);

    if (afterLinkStart.contains(']]') || afterLinkStart.contains('\n')) {
      return [];
    }

    final query = afterLinkStart.trim().toLowerCase();

    return widget.noteSuggestions
        .where((title) {
          final normalizedTitle = title.trim();

          if (normalizedTitle.isEmpty) return false;
          if (query.isEmpty) return true;

          return normalizedTitle.toLowerCase().contains(query);
        })
        .take(6)
        .toList();
  }

  void _insertSuggestion(int index, String title) {
    if (index < 0 || index >= _controllers.length) return;

    final controller = _controllers[index];
    final selection = controller.selection;

    if (!selection.isValid || !selection.isCollapsed) return;

    final cursorOffset = selection.baseOffset.clamp(0, controller.text.length);
    final beforeCursor = controller.text.substring(0, cursorOffset);
    final linkStart = beforeCursor.lastIndexOf('[[');

    if (linkStart < 0) return;

    final replacement = '[[$title]]';
    final nextText =
        controller.text.replaceRange(linkStart, cursorOffset, replacement);
    final nextCursorOffset = linkStart + replacement.length;

    setState(() {
      _lines[index] = nextText;
      controller.text = nextText;
      controller.selection = TextSelection.collapsed(
        offset: nextCursorOffset,
      );
    });

    _notifyChanged();
  }

  void _toggleTaskLine(int index) {
    final task = MarkdownTaskLineData.tryParse(_lines[index]);

    if (task == null) return;

    final newLine = task.toMarkdown(
      checked: !task.checked,
    );

    setState(() {
      _lines[index] = newLine;
      _controllers[index].text = newLine;

      _controllers[index].selection = TextSelection.collapsed(
        offset: newLine.length,
      );
    });

    _notifyChanged();
  }

  void _removeLine(
    int index, {
    required int nextIndex,
    bool cursorAtEnd = true,
  }) {
    if (_lines.length <= 1) {
      setState(() {
        _lines[0] = '';
        _controllers[0].text = '';
        _controllers[0].selection = const TextSelection.collapsed(offset: 0);
        _activeLineIndex = 0;
      });

      _notifyChanged();

      _activateLine(
        0,
        cursorAtEnd: false,
      );

      return;
    }

    setState(() {
      _lines.removeAt(index);

      final safeIndex = nextIndex.clamp(0, _lines.length - 1);

      _activeLineIndex = safeIndex;

      _rebuildEditingObjects();
    });

    _notifyChanged();

    _activateLine(
      _activeLineIndex!,
      cursorAtEnd: cursorAtEnd,
    );
  }

  void _mergeWithPreviousLine(int index) {
    if (index <= 0 || index >= _lines.length) return;

    final previousIndex = index - 1;
    final previousText = _lines[previousIndex];
    final currentText = _lines[index];
    final cursorOffset = previousText.length;

    setState(() {
      _lines[previousIndex] = previousText + currentText;
      _lines.removeAt(index);

      _activeLineIndex = previousIndex;

      _rebuildEditingObjects();
    });

    _notifyChanged();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final controller = _controllers[previousIndex];

      _focusNodes[previousIndex].requestFocus();
      controller.selection = TextSelection.collapsed(
        offset: cursorOffset,
      );
    });
  }

  void _mergeWithNextLine(int index) {
    if (index < 0 || index >= _lines.length - 1) return;

    final currentText = _lines[index];
    final nextText = _lines[index + 1];
    final cursorOffset = currentText.length;

    setState(() {
      _lines[index] = currentText + nextText;
      _lines.removeAt(index + 1);

      _activeLineIndex = index;

      _rebuildEditingObjects();
    });

    _notifyChanged();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final controller = _controllers[index];

      _focusNodes[index].requestFocus();
      controller.selection = TextSelection.collapsed(
        offset: cursorOffset,
      );
    });
  }

  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (index < 0 || index >= _controllers.length) {
      return KeyEventResult.ignored;
    }

    final controller = _controllers[index];
    final selection = controller.selection;

    if (!selection.isValid) {
      return KeyEventResult.ignored;
    }

    final cursorOffset = selection.baseOffset;
    final textLength = controller.text.length;
    final isCollapsed = selection.isCollapsed;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (isCollapsed && cursorOffset <= 0 && index > 0) {
        _activateLine(
          index - 1,
          cursorAtEnd: true,
        );

        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (isCollapsed &&
          cursorOffset >= textLength &&
          index < _lines.length - 1) {
        _activateLine(
          index + 1,
          cursorAtEnd: false,
        );

        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (index > 0 && cursorOffset <= 0) {
        _activateLine(
          index - 1,
          cursorAtEnd: true,
        );

        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (index < _lines.length - 1 && cursorOffset >= textLength) {
        _activateLine(
          index + 1,
          cursorAtEnd: false,
        );

        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (!isCollapsed) {
        return KeyEventResult.ignored;
      }

      if (textLength == 0) {
        final nextIndex = index > 0 ? index - 1 : 0;

        _removeLine(
          index,
          nextIndex: nextIndex,
          cursorAtEnd: true,
        );

        return KeyEventResult.handled;
      }

      if (cursorOffset <= 0 && index > 0) {
        _mergeWithPreviousLine(index);

        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.delete) {
      if (!isCollapsed) {
        return KeyEventResult.ignored;
      }

      if (textLength == 0) {
        final nextIndex = index < _lines.length - 1 ? index : index - 1;

        _removeLine(
          index,
          nextIndex: nextIndex,
          cursorAtEnd: false,
        );

        return KeyEventResult.handled;
      }

      if (cursorOffset >= textLength && index < _lines.length - 1) {
        _mergeWithNextLine(index);

        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _activateLastLine,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minHeight,
              ),
              child: Padding(
                padding: widget.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    _lines.length,
                    _buildLine,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLine(int index) {
    final isActive = _activeLineIndex == index;
    final line = _lines[index];

    if (isActive) {
      final suggestions = _suggestionsForLine(index);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EditableMarkdownLine(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _handleLineChanged(index, value),
            onKeyEvent: (event) => _handleKeyEvent(index, event),
          ),
          if (suggestions.isNotEmpty)
            _NoteSuggestionsList(
              suggestions: suggestions,
              onSelected: (title) => _insertSuggestion(index, title),
            ),
        ],
      );
    }

    final task = MarkdownTaskLineData.tryParse(line);

    if (task != null) {
      return MarkdownTaskLine(
        task: task,
        onToggle: () => _toggleTaskLine(index),
        onTapText: () => _activateLine(
          index,
          cursorAtEnd: true,
        ),
      );
    }

    return _MarkdownPreviewLine(
      data: line,
      onTap: () => _activateLine(
        index,
        cursorAtEnd: true,
      ),
    );
  }
}

class _NoteSuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const _NoteSuggestionsList({
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.border.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final title in suggestions)
            InkWell(
              onTap: () => onSelected(title),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 18,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: AppText.medium_14a.copyWith(
                          color: context.colors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EditableMarkdownLine extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent event) onKeyEvent;

  const _EditableMarkdownLine({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Focus(
      onKeyEvent: (_, event) => onKeyEvent(event),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: colors.primary,
        style: AppText.medium_16a.copyWith(
          color: colors.text,
          height: 1.45,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 3,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: '',
          hintStyle: AppText.medium_16a.copyWith(
            color: colors.gray,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _MarkdownPreviewLine extends StatelessWidget {
  final String data;
  final VoidCallback onTap;

  const _MarkdownPreviewLine({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedData = data.trim().isEmpty ? ' ' : data;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 28,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          vertical: 3,
        ),
        child: AppMarkdownSettings.preview(
          context: context,
          data: normalizedData,
          onTapLink: (text, href, title) {
            if (href == null) return;

            LinkHandler.open(context, href);
          },
        ),
      ),
    );
  }
}
