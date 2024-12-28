import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.authorId,
    super.authorName,
    required super.imageUrl,
    required super.topics,
  });

  Map<String, dynamic> toJson({bool includeAuthorName = false}) {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      if (includeAuthorName) 'profiles': {'name': authorName},
      'image_url': imageUrl,
      'topics': topics,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map json) {
    return BlogModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorId: json['author_id'],
      authorName: json['profiles']?['name'],
      imageUrl: json['image_url'],
      topics: List.from(json['topics'] ?? []),
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
    );
  }
}
