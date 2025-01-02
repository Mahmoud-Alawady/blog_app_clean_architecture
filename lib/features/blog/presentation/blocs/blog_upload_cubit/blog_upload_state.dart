part of 'blog_upload_cubit.dart';

@immutable
sealed class BlogUploadState {}

final class BlogUploadInitial extends BlogUploadState {}

final class BlogUploadLoading extends BlogUploadState {}

final class BlogUploadFailure extends BlogUploadState {
  final String error;
  BlogUploadFailure(this.error);
}

final class BlogUploadSuccess extends BlogUploadState {
  final Blog blog;
  BlogUploadSuccess(this.blog);
}
