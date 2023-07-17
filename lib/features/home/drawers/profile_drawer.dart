import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(authControllerProvider);
    return Drawer(
      child: SafeArea(
        child: isLoading
            ? const Loader()
            : Column(
                children: [
                  const SizedBox(height: 24),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicture),
                    radius: 72,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'u/${user.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  ListTile(
                    title: const Text('My Profile'),
                    leading: const Icon(
                      Icons.person_rounded,
                      color: AppColors.whiteColor,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.redColor,
                    ),
                    onTap: () => logout(ref),
                  ),
                  Switch.adaptive(
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
      ),
    );
  }
}
