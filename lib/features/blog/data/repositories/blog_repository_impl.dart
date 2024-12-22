import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String authorId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure('No internet connection!'));
      }
      final id = const Uuid().v4();
      final imageUrl =
          await blogRemoteDataSource.uploadBlogImage(image: image, id: id);
      final blog = BlogModel(
        id: id,
        title: title,
        content: content,
        createdAt: DateTime.now(),
        authorId: authorId,
        imageUrl: imageUrl,
        topics: topics,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blog);
      return Right(uploadedBlog);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final blogs = blogLocalDataSource.readBlogs();
        return Right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.writeBlogs(blogs);
      return Right(blogs);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
