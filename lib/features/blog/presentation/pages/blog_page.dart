import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogEventGetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blog App'),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add_circled),
              iconSize: 28,
              padding: const EdgeInsets.only(right: 10),
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
            )
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) return const Loader();
            if (state is BlogFetchSuccess) {
              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, i) {
                  final blog = state.blogs[i];
                  return BlogCard(
                      blog: blog,
                      color: [
                        AppPallete.gradient1,
                        AppPallete.gradient2,
                        AppPallete.gradient3,
                      ][i % 3]);
                },
              );
            }
            return const SizedBox();
          },
        ));
  }
}
