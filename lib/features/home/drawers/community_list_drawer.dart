import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunityScreen(BuildContext context) {
    Routemaster.of(context).push(AppRoutes.createCommunity);
  }

  void navigateToCommunityScreen(BuildContext context, String communityName) {
    Routemaster.of(context).push('${AppRoutes.community}/$communityName');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ListTile(
              title: const Text(
                'Create a community',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(
                Icons.add_rounded,
                color: AppColors.whiteColor,
                size: 32,
              ),
              onTap: () => navigateToCreateCommunityScreen(context),
            ),
            Expanded(
              child: ref.watch(userCommunitiesProvider).when<Widget>(
                    data: (communities) => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return ListTile(
                          title: Text(
                            'r/${community.name}',
                          ),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          onTap: () => navigateToCommunityScreen(context, community.name),
                        );
                      },
                    ),
                    error: (error, __) => ErrorTextWidget(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
