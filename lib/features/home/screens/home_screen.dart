import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_app/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_app/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // it cannot be null if we be in home screen
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu_rounded, size: 32),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search_rounded, size: 32),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => displayEndDrawer(context),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.profilePicture),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}
