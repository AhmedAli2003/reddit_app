import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // it cannot be null if we be in home screen
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}
