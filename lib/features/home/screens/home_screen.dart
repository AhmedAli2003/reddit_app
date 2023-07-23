import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/theme/theme_notifier.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/feed/screens/feed_screen.dart';
import 'package:reddit_app/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_app/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_app/features/home/drawers/profile_drawer.dart';
import 'package:reddit_app/features/posts/screens/add_post_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _tabWidgets = const [
    FeedScreen(),
    AddPostScreen(),
  ];

  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    // it cannot be null if we be in home screen
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeProvider);

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
      body: _tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: theme.iconTheme.color,
        backgroundColor: theme.colorScheme.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_rounded,
            ),
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
