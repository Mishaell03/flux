import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:markdown/markdown.dart' as md;

class AppMarkdownSettings {
  const AppMarkdownSettings._();

  static md.ExtensionSet get extensionSet => md.ExtensionSet.gitHubFlavored;

  static List<md.InlineSyntax> get inlineSyntaxes => [
    WikiLinkSyntax(),
    HashtagSyntax(),
  ];

  // TODO: добавить кастомные билдеры
  // 'code': AppCodeElementBuilder(),
  // 'a': AppLinkElementBuilder(),
  static Map<String, MarkdownElementBuilder> get builders => {};

  static MarkdownStyleSheet styleSheet(
      BuildContext context, {
        bool checked = false,
      }) {
    final colors = context.colors;

    TextStyle done(TextStyle style) {
      if (!checked) return style;

      return style.copyWith(
        color: colors.gray,
        decoration: TextDecoration.lineThrough,
        decorationColor: colors.gray,
        decorationThickness: 1.4,
      );
    }

    final bodyStyle = done(
      AppText.medium_16a.copyWith(
        color: colors.text,
        height: 1.45,
      ),
    );

    final smallStyle = done(
      AppText.medium_14a.copyWith(
        color: colors.gray,
        height: 1.4,
      ),
    );

    final codeBackground = colors.primary.withValues(alpha: 0.3);

    return MarkdownStyleSheet(
      p: bodyStyle,

      h1: done(
        AppText.bold_30.copyWith(
          color: colors.text,
          height: 1.2,
        ),
      ),
      h2: done(
        AppText.bold_24.copyWith(
          color: colors.text,
          height: 1.25,
        ),
      ),
      h3: done(
        AppText.bold_19.copyWith(
          color: colors.text,
          height: 1.3,
        ),
      ),
      h4: done(
        AppText.medium_18a.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
      h5: done(
        AppText.medium_16a.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
      h6: done(
        AppText.medium_14a.copyWith(
          color: colors.gray,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),

      strong: bodyStyle.copyWith(
        fontWeight: FontWeight.w700,
      ),
      em: bodyStyle.copyWith(
        fontStyle: FontStyle.italic,
      ),
      del: bodyStyle.copyWith(
        color: colors.gray,
        decoration: TextDecoration.lineThrough,
        decorationColor: colors.gray,
      ),

      a: bodyStyle.copyWith(
        color: checked ? colors.gray : colors.primary,
        fontWeight: FontWeight.w600,
        decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: colors.gray,
      ),

      code: AppText.medium_15a.copyWith(
        color: checked ? colors.gray : colors.primary,
        height: 1.35,
        backgroundColor: codeBackground,
        decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: colors.gray,
      ),

      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),

      blockquote: bodyStyle.copyWith(
        color: colors.gray,
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      blockquoteDecoration: BoxDecoration(
        color: codeBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: colors.primary,
            width: 4,
          ),
        ),
      ),

      listBullet: bodyStyle,

      tableHead: done(
        AppText.medium_14a.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w700,
        ),
      ),
      tableBody: smallStyle,
      tableBorder: TableBorder.all(
        color: colors.border,
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),

      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.border,
            width: 1,
          ),
        ),
      ),

      checkbox: bodyStyle,
    );
  }

  static Widget preview({
    required BuildContext context,
    required String data,
    bool checked = false,
    void Function(String? text, String? href, String title)? onTapLink,
  }) {
    final normalizedData = data.trim().isEmpty ? ' ' : data;

    return MarkdownBody(
      data: normalizedData,
      selectable: false,
      styleSheet: styleSheet(
        context,
        checked: checked,
      ),
      extensionSet: extensionSet,
      inlineSyntaxes: inlineSyntaxes,
      builders: builders,
      onTapLink: onTapLink,
    );
  }
}

// ссылки:

// [[note-id]]
// [[note-id|Название]]
class WikiLinkSyntax extends md.InlineSyntax {
  WikiLinkSyntax() : super(r'\[\[([^\]]+)\]\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final raw = match[1]!;
    String? label;
    String target;

    if (raw.contains('|')) {
      final parts = raw.split('|');
      label = parts[0].trim();
      target = parts[1].trim();
    } else {
      label = raw.trim();
      target = raw.trim();
    }

    final element = md.Element.text('a', label);

    element.attributes['href'] = target;

    parser.addNode(element);
    return true;
  }
}

// #note-hashtag
class HashtagSyntax extends md.InlineSyntax {
  HashtagSyntax() : super(r'(?<![\w/])#([a-zA-Z0-9_]+)');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match[1];

    if (tag == null || tag.isEmpty) return false;

    final element = md.Element.text('a', '#$tag');

    // схема для внутренних тегов
    element.attributes['href'] = 'flux-tag://$tag';

    parser.addNode(element);
    return true;
  }
}