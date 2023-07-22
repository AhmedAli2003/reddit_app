import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('${AppRoutes.addPost}/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAddPostCard(
            icon: Icons.image_outlined,
            onTap: () => navigateToType(context, 'image'),
          ),
          CustomAddPostCard(
            icon: Icons.font_download_outlined,
            onTap: () => navigateToType(context, 'text'),
          ),
          CustomAddPostCard(
            icon: Icons.link_outlined,
            onTap: () => navigateToType(context, 'link'),
          ),
        ],
      ),
    );
  }
}

class CustomAddPostCard extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  const CustomAddPostCard({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 16,
          child: Center(
            child: Icon(
              icon,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
