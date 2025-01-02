import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_fetch_event.dart';
part 'blog_fetch_state.dart';

class BlogFetchBloc extends Bloc<BlogFetchEvent, BlogFetchState> {
  final GetAllBlogs _getAllBlogs;

  BlogFetchBloc({required GetAllBlogs getAllBlogs})
      : _getAllBlogs = getAllBlogs,
        super(BlogFetchInitial()) {
    on<BlogFetchEvent>((event, emit) => emit(BlogFetchLoading()));
    on<BlogFetchEventGetAllBlogs>(_onBlogEventGetAllBlogs);
  }

  void _onBlogEventGetAllBlogs(
    BlogFetchEventGetAllBlogs event,
    Emitter<BlogFetchState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFetchFailure(l.message)),
      (r) => emit(BlogFetchSuccess(r)),
    );
  }
}
