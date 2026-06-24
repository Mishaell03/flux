class MarkdownTaskLineData {
  final String indent;
  final String bullet;
  final bool checked;
  final String text;

  const MarkdownTaskLineData({
    required this.indent,
    required this.bullet,
    required this.checked,
    required this.text,
  });

  static final RegExp _taskRegExp = RegExp(
    r'^(\s*)([-*+])\s+\[([ xX])\]\s?(.*)$',
  );

  static MarkdownTaskLineData? tryParse(String line) {
    final match = _taskRegExp.firstMatch(line);

    if (match == null) return null;

    final indent = match.group(1) ?? '';
    final bullet = match.group(2) ?? '-';
    final marker = match.group(3) ?? ' ';
    final text = match.group(4) ?? '';

    return MarkdownTaskLineData(
      indent: indent,
      bullet: bullet,
      checked: marker.toLowerCase() == 'x',
      text: text,
    );
  }

  String toMarkdown({
    required bool checked,
  }) {
    final marker = checked ? 'x' : ' ';

    if (text.trim().isEmpty) {
      return '$indent$bullet [$marker]';
    }

    return '$indent$bullet [$marker] $text';
  }
}