class Blog {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String authorId;
  final String? authorName;
  final String imageUrl;
  final List<String> topics;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    required this.imageUrl,
    required this.topics,
  });
}
