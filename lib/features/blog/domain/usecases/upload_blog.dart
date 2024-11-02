import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    final blog = await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      authorId: params.authorId,
      topics: params.topics,
    );

    return blog;
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final String authorId;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.authorId,
    required this.topics,
  });
}
