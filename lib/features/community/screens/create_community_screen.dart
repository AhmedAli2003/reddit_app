import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  late final TextEditingController _communityNameController;

  @override
  void initState() {
    super.initState();
    _communityNameController = TextEditingController();
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  void createCommunity() {
    final communityName = _communityNameController.text.trim();
    if (communityName.length < 3) {
      showSnackBar(
        context,
        'The community name must be 3 characters at least',
      );
    } else {
      ref.read(communityControllerProvider.notifier).createCommunity(
            context,
            communityName,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create a community'),
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Community name'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _communityNameController,
                    decoration: const InputDecoration(
                      hintText: 'r/Community_name',
                      filled: true,
                      fillColor: AppColors.greyColor,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: createCommunity,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: AppColors.blueColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                    child: const Text(
                      'Create community',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
