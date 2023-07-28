import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/posts/controller/posts_controller.dart';

class ModeratorIcon extends ConsumerWidget {
  final String postId;
  final String communityId;
  const ModeratorIcon({
    super.key,
    required this.postId,
    required this.communityId,
  });

  void deletePost(BuildContext context, WidgetRef ref) {
    ref.read(postsControllerProvider.notifier).deletePost(context: context, postId: postId);
  }

  Future<bool> isMod(WidgetRef ref) async {
    return await ref.read(communityControllerProvider.notifier).isMod(communityId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: isMod(ref),
      builder: (_, snapshot) => snapshot.data != null && snapshot.data!
          ? IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: ListTile(
                    leading: const Icon(Icons.delete, color: AppColors.redColor),
                    title: const Text('Delete the post'),
                    onTap: () => deletePost(context, ref),
                  ),
                ),
              ),
              icon: const Icon(Icons.admin_panel_settings_rounded),
            )
          : const SizedBox(),
    );
  }
}
