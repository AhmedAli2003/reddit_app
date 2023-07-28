import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/posts/widgets/post_card.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({
    super.key,
    required this.name,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.modTools}/$name');
  }

  void joinCommunity(BuildContext context, WidgetRef ref, Community community) {
    ref.read(communityControllerProvider.notifier).joinCommunity(context, community);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isJoinLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when<Widget>(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(community.banner, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 36,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () => navigateToModTools(context),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('Mod Tools'),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: isJoinLoading
                                        ? null
                                        : () => joinCommunity(
                                              context,
                                              ref,
                                              community,
                                            ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${community.members.length} ${community.members.length == 1 ? 'member' : 'members'}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: ref.watch(getCommunityPostsProvider(name)).when(
                    data: (posts) => ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) => PostCard(post: posts[index]),
                    ),
                    error: (error, _) => ErrorTextWidget(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, __) => ErrorTextWidget(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
