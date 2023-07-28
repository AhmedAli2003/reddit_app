import 'package:flutter/material.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/features/auth/screens/login_screen.dart';
import 'package:reddit_app/features/community/screens/add_mods_screen.dart';
import 'package:reddit_app/features/community/screens/community_screen.dart';
import 'package:reddit_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_app/features/community/screens/edit_community_screen.dart';
import 'package:reddit_app/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_app/features/posts/screens/add_post_type_screen.dart';
import 'package:reddit_app/features/posts/screens/comments_screen.dart';
import 'package:reddit_app/features/profile/screens/edit_profile_screen.dart';
import 'package:reddit_app/features/home/screens/home_screen.dart';
import 'package:reddit_app/features/profile/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    AppRoutes.createCommunity: (_) => const MaterialPage(child: CreateCommunityScreen()),
    '${AppRoutes.community}/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '${AppRoutes.modTools}/:name': (route) => MaterialPage(
          child: ModToolsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '${AppRoutes.editCommunity}/:name': (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '${AppRoutes.addMods}/:name': (route) => MaterialPage(
          child: AddModsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '${AppRoutes.profile}/:uid': (route) => MaterialPage(
          child: ProfileScreen(
            uid: route.pathParameters['uid']!,
          ),
        ),
    '${AppRoutes.editProfile}/:uid': (route) => MaterialPage(
          child: EditProfileScreen(
            uid: route.pathParameters['uid']!,
          ),
        ),
    '${AppRoutes.addPost}/:type': (route) => MaterialPage(
          child: AddPostTypeScreen(
            type: route.pathParameters['type']!,
          ),
        ),
    '${AppRoutes.post}/:postId': (route) => MaterialPage(
          child: CommentsScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),
  },
);
