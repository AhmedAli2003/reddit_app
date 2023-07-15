import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunityScreen(BuildContext context) {
    Routemaster.of(context).push(AppRoutes.createCommunity);
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
          ],
        ),
      ),
    );
  }
}
