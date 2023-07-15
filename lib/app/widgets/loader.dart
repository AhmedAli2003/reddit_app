import 'package:flutter/material.dart';
import 'package:reddit_app/app/theme/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.blueColor,
      ),
    );
  }
}
