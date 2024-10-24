import 'package:flutter/material.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/widgets/loader.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  const AuthGradientButton({
    this.isLoading = false,
    this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLoading
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.grey,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(
                colors: [
                  AppPallete.gradient1,
                  AppPallete.gradient2,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(400, 55),
              backgroundColor: AppPallete.transparentColor,
              shadowColor: AppPallete.transparentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7))),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const Loader()
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                )),
    );
  }
}
