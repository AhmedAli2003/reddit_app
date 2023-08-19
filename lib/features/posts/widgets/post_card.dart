import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/constants/app_assets.dart';
import 'package:reddit_app/app/constants/app_constants.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/theme/theme_notifier.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/posts/controller/posts_controller.dart';
import 'package:reddit_app/features/posts/widgets/moderator_icon.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(BuildContext context, WidgetRef ref) {
    ref.read(postsControllerProvider.notifier).deletePost(context: context, postId: post.id);
  }

  void upvote(BuildContext context, WidgetRef ref) {
    ref.read(postsControllerProvider.notifier).upvote(context: context, post: post);
  }

  void downvote(BuildContext context, WidgetRef ref) {
    ref.read(postsControllerProvider.notifier).downvote(context: context, post: post);
  }

  void awardPost(BuildContext context, WidgetRef ref, String award) async {
    ref.read(postsControllerProvider.notifier).awardPost(
          context: context,
          post: post,
          award: award,
        );
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.profile}/${post.userId}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.community}/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.post}/${post.id}');
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
                              GestureDetector(
                                onTap: () => navigateToCommunity(context),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(post.communityProfilePicture),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: Text(
                                      'r/${post.communityName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => navigateToUserProfile(context),
                                    child: Text(
                                      'u/${post.username}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
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
                          if (post.awards.isNotEmpty) ...[
                            SizedBox(
                              height: 24,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (_, index) => Image.asset(AppAssets.awards[post.awards[index]]!),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
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
                          onPressed: () => upvote(context, ref),
                          icon: Icon(
                            AppConstants.up,
                            size: 28,
                            color: post.upVotes.contains(user.uid) ? AppColors.blueColor : null,
                          ),
                        ),
                        Text('${post.upVotes.length - post.downVotes.length}'),
                        IconButton(
                          onPressed: () => downvote(context, ref),
                          icon: Icon(
                            AppConstants.down,
                            size: 28,
                            color: post.downVotes.contains(user.uid) ? AppColors.redColor : null,
                          ),
                        ),
                        IconButton(
                          onPressed: () => navigateToComments(context),
                          icon: const Icon(Icons.comment_rounded),
                        ),
                        Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}'),
                        const Spacer(),
                        ModeratorIcon(postId: post.id, communityId: post.communityName),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: user.awards.length,
                                  padding: const EdgeInsets.all(20),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemBuilder: (context, index) {
                                    final award = user.awards[index];
                                    return GestureDetector(
                                      onTap: () => awardPost(context, ref, award),
                                      child: Image.asset(AppAssets.awards[award]!),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.card_giftcard_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
