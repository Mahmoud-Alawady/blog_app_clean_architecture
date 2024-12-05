import 'dart:io';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  List<String> selectedTopics = [];
  File? selectedImage;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogUploadSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogPage.route(), (route) => false);

                showSnackBar(context, 'blog uploaded successfully!');
              } else if (state is BlogFailure) {
                showSnackBar(context, state.error);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: Loader(),
                  ),
                );
              }
              return IconButton(
                  iconSize: 26,
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedImage != null) {
                      final authorId = (context.read<AppUserCubit>().state
                              as AppUserLoggedIn)
                          .user
                          .id;
                      context.read<BlogBloc>().add(
                            BlogEventUpload(
                              image: selectedImage!,
                              title: titleController.text.trim(),
                              content: contentController.text.trim(),
                              authorId: authorId,
                              topics: selectedTopics,
                            ),
                          );
                    }
                  },
                  icon: const Icon(Icons.done_rounded));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildImageSelector(),
                const SizedBox(height: 20),
                _buildTopicsSelector(),
                const SizedBox(height: 20),
                BlogEditor(controller: titleController, hintText: 'Blog title'),
                const SizedBox(height: 10),
                BlogEditor(
                    controller: contentController, hintText: 'Blog content'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: () async {
        final image = await pickImage();
        if (image != null) {
          setState(() => selectedImage = image);
        }
      },
      child: selectedImage != null
          ? SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : DottedBorder(
              dashPattern: const [10, 4],
              color: AppPallete.borderColor,
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              radius: const Radius.circular(12),
              child: const SizedBox(
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 40),
                    SizedBox(height: 14),
                    Text('Select your image', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTopicsSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          'Technology',
          'Business',
          'Programming',
          'Entertainment',
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (selectedTopics.contains(e)) {
                        selectedTopics.remove(e);
                      } else {
                        selectedTopics.add(e);
                      }

                      setState(() {});
                    },
                    child: Chip(
                      label: Text(e),
                      color: selectedTopics.contains(e)
                          ? const WidgetStatePropertyAll(AppPallete.gradient1)
                          : null,
                      side: BorderSide(
                          color: selectedTopics.contains(e)
                              ? AppPallete.backgroundColor
                              : AppPallete.borderColor),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
