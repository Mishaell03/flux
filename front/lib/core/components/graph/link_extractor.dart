class LinkExtractor {
  static final RegExp _hashtagRegex = RegExp(r'#(\w+)');
  static final RegExp _internalLinkRegex = RegExp(r'\[\[([^\]]+)\]\]');

  static ExtractedLinks extract(String text) {
    final hashtags = _hashtagRegex
        .allMatches(text)
        .map((m) => m.group(1)!)
        .toSet();

    final internalLinks = _internalLinkRegex
        .allMatches(text)
        .map((m) => m.group(1)!)
        .toSet();

    return ExtractedLinks(
      hashtags: hashtags,
      internalLinks: internalLinks,
    );
  }
}

class ExtractedLinks {
  final Set<String> hashtags;
  final Set<String> internalLinks;

  const ExtractedLinks({
    required this.hashtags,
    required this.internalLinks,
  });
}