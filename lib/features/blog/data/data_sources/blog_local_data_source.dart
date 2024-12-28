import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void writeBlogs(List<BlogModel> blogs);
  List<BlogModel> readBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> readBlogs() {
    final blogs = box.values;
    debugPrint('blogs read: ${blogs.length}');
    return blogs.map((e) => BlogModel.fromJson(e)).toList();
  }

  @override
  void writeBlogs(List<BlogModel> blogs) {
    box.clear();
    box.addAll(blogs.map((e) => e.toJson(includeAuthorName: true)));
    debugPrint('blogs written: ${blogs.length}');
  }
}
