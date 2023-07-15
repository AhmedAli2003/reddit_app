import 'package:flutter/material.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/features/auth/screens/login_screen.dart';
import 'package:reddit_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_app/features/home/screens/home_screen.dart';
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
  },
);
