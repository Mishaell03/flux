import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:markdown/markdown.dart' as md;

class AppMarkdownSettings {
  const AppMarkdownSettings._();

  static md.ExtensionSet get extensionSet => md.ExtensionSet.gitHubFlavored;

  static List<md.InlineSyntax> get inlineSyntaxes => [
        AttachmentSyntax(),
        WikiLinkSyntax(),
        HashtagSyntax(),
      ];

  static Map<String, MarkdownElementBuilder> buildersFor({
    required BuildContext context,
    void Function(MarkdownAttachmentData attachment)? onTapAttachment,
  }) {
    return {
      'attachment': AttachmentElementBuilder(
        context: context,
        onTap: onTapAttachment,
      ),
    };
  }

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
    void Function(MarkdownAttachmentData attachment)? onTapAttachment,
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
      builders: buildersFor(
        context: context,
        onTapAttachment: onTapAttachment,
      ),
      onTapLink: onTapLink,
    );
  }
}

enum MarkdownAttachmentType {
  image,
  audio,
}

class MarkdownAttachmentData {
  final MarkdownAttachmentType type;
  final String hash;

  const MarkdownAttachmentData({
    required this.type,
    required this.hash,
  });

  bool get isImage => type == MarkdownAttachmentType.image;

  bool get isAudio => type == MarkdownAttachmentType.audio;

  String get typeValue {
    switch (type) {
      case MarkdownAttachmentType.image:
        return 'image';
      case MarkdownAttachmentType.audio:
        return 'audio';
    }
  }

  String get marker => '{{attachment:$typeValue|$hash}}';

  static MarkdownAttachmentData? fromElement(md.Element element) {
    final rawType = element.attributes['type'];
    final hash = element.attributes['hash'];

    if (rawType == null || hash == null || hash.trim().isEmpty) {
      return null;
    }

    final type = switch (rawType) {
      'image' => MarkdownAttachmentType.image,
      'audio' => MarkdownAttachmentType.audio,
      _ => null,
    };

    if (type == null) return null;

    return MarkdownAttachmentData(
      type: type,
      hash: hash.trim(),
    );
  }

  static MarkdownAttachmentData image(String hash) {
    return MarkdownAttachmentData(
      type: MarkdownAttachmentType.image,
      hash: hash,
    );
  }

  static MarkdownAttachmentData audio(String hash) {
    return MarkdownAttachmentData(
      type: MarkdownAttachmentType.audio,
      hash: hash,
    );
  }
}

final RegExp attachmentMarkerRegExp = RegExp(
  r'\{\{attachment:(image|audio)\|([a-zA-Z0-9_\-]+)\}\}',
);

List<MarkdownAttachmentData> extractMarkdownAttachments(String? content) {
  if (content == null || content.isEmpty) return [];

  return attachmentMarkerRegExp
      .allMatches(content)
      .map((match) {
        final type = match.group(1);
        final hash = match.group(2);

        if (type == null || hash == null) return null;

        return MarkdownAttachmentData(
          type: type == 'audio'
              ? MarkdownAttachmentType.audio
              : MarkdownAttachmentType.image,
          hash: hash,
        );
      })
      .whereType<MarkdownAttachmentData>()
      .toList();
}

Set<String> extractMarkdownAttachmentHashes(String? content) {
  return extractMarkdownAttachments(content)
      .map((attachment) => attachment.hash)
      .toSet();
}

// {{attachment:image|hash}}
// {{attachment:audio|hash}}
class AttachmentSyntax extends md.InlineSyntax {
  AttachmentSyntax()
      : super(
          r'\{\{attachment:(image|audio)\|([a-zA-Z0-9_\-]+)\}\}',
        );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final type = match.group(1);
    final hash = match.group(2);

    if (type == null || hash == null) return false;

    final label = type == 'image'
        ? 'Просмотреть изображение'
        : 'Прослушать голосовое';

    final element = md.Element.text('attachment', label);

    element.attributes['type'] = type;
    element.attributes['hash'] = hash;

    parser.addNode(element);
    return true;
  }
}

class AttachmentElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final void Function(MarkdownAttachmentData attachment)? onTap;

  AttachmentElementBuilder({
    required this.context,
    this.onTap,
  });

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final attachment = MarkdownAttachmentData.fromElement(element);

    if (attachment == null) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;

    final icon = attachment.isImage
        ? Icons.image_rounded
        : Icons.play_circle_fill_rounded;

    final t = AppLocalizations.of(context)!;

    final label =
        attachment.isImage ? t.viewImg : t.listenVoice;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap == null ? null : () => onTap!(attachment),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppText.medium_14a.copyWith(
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
