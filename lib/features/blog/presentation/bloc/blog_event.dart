part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogEventUpload extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String authorId;
  final List<String> topics;

  BlogEventUpload({
    required this.image,
    required this.title,
    required this.content,
    required this.authorId,
    required this.topics,
  });
}
