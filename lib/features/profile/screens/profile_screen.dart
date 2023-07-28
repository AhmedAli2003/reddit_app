import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/posts/widgets/post_card.dart';
import 'package:reddit_app/features/profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends ConsumerWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  void navigateToEditProfileScreen(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.editProfile}/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when<Widget>(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(user.banner, fit: BoxFit.cover),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 40, left: 20),
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture),
                          radius: 36,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 12, left: 20),
                        alignment: Alignment.bottomLeft,
                        child: OutlinedButton(
                          onPressed: () => navigateToEditProfileScreen(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Edit Profile'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${user.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${user.karma} karma'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                ),
              ],
              body: ref.watch(getUserPostsProvider(uid)).when(
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
