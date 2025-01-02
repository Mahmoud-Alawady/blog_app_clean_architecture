import 'dart:io';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_upload_state.dart';

class BlogUploadCubit extends Cubit<BlogUploadState> {
  final UploadBlog _uploadBlog;

  BlogUploadCubit({required UploadBlog uploadBlog})
      : _uploadBlog = uploadBlog,
        super(BlogUploadInitial());

  uploadBlog({
    required File? image,
    required String title,
    required String content,
    required String authorId,
    required List<String> topics,
  }) async {
    emit(BlogUploadLoading());
    final res = await _uploadBlog(UploadBlogParams(
        image: image,
        title: title,
        content: content,
        authorId: authorId,
        topics: topics));

    res.fold(
      (l) => emit(BlogUploadFailure(l.message)),
      (r) => emit(BlogUploadSuccess(r)),
    );
  }
}
