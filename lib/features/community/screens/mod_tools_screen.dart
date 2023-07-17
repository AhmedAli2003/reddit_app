import 'package:flutter/material.dart';
import 'package:reddit_app/app/router/app_routes.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    super.key,
    required this.name,
  });

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.editCommunity}/$name');
  }

  void navigateToAddModsScreen(BuildContext context) {
    Routemaster.of(context).push('${AppRoutes.addMods}/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.add_moderator_rounded,
              color: AppColors.whiteColor,
            ),
            title: const Text('Add Modarators'),
            onTap: () => navigateToAddModsScreen(context),
          ),
          ListTile(
            leading: const Icon(
              Icons.edit_rounded,
              color: AppColors.whiteColor,
            ),
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunityScreen(context),
          ),
        ],
      ),
    );
  }
}
