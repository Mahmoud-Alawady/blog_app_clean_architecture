import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
