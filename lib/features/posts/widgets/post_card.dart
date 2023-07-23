import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/constants/app_constants.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/theme/theme_notifier.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/posts/controller/posts_controller.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(BuildContext context, WidgetRef ref) {
    ref.read(postsControllerProvider.notifier).deletePost(context: context, postId: post.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';

    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.drawerTheme.backgroundColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(post.communityProfilePicture),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'r/${post.communityName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'u/${post.username}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (post.userId == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(context, ref),
                                  icon: const Icon(Icons.delete, color: AppColors.redColor),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isTypeImage)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: AnyLinkPreview(
                                displayDirection: UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Text(
                              post.description!,
                              style: const TextStyle(color: AppColors.whiteColor),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            AppConstants.up,
                            size: 28,
                            color: post.upVotes.contains(user.uid) ? AppColors.redColor : null,
                          ),
                        ),
                        Text('${post.upVotes.length - post.downVotes.length}'),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            AppConstants.down,
                            size: 28,
                            color: post.downVotes.contains(user.uid) ? AppColors.blueColor : null,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_rounded),
                        ),
                        Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
