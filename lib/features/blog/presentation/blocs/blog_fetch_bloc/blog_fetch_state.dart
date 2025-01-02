part of 'blog_fetch_bloc.dart';

@immutable
sealed class BlogFetchState {}

final class BlogFetchInitial extends BlogFetchState {}

final class BlogFetchLoading extends BlogFetchState {}

final class BlogFetchFailure extends BlogFetchState {
  final String error;
  BlogFetchFailure(this.error);
}

final class BlogFetchSuccess extends BlogFetchState {
  final List<Blog> blogs;
  BlogFetchSuccess(this.blogs);
}
