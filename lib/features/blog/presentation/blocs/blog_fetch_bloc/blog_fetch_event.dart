part of 'blog_fetch_bloc.dart';

@immutable
sealed class BlogFetchEvent {}

class BlogFetchEventGetAllBlogs extends BlogFetchEvent {}
