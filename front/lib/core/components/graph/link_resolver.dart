class LinkResolver {
  final Map<String, String> titleToId;

  const LinkResolver(this.titleToId);

  List<String> resolve(Set<String> links) {
    return links
        .map((title) => titleToId[title])
        .whereType<String>()
        .toList();
  }
}