import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/constants/app_constants.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/theme/app_theme.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/profile/controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() => bannerFile = File(picked.files.first.path!));
    }
  }

  void selectProfileImage() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() => profileFile = File(picked.files.first.path!));
    }
  }

  void save(UserModel user) {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          context: context,
          profileFile: profileFile,
          bannerFile: bannerFile,
          newName: _nameController.text.trim(),
          user: user,
        );
  }

  Widget getBannerImage(UserModel user) {
    if (bannerFile != null) {
      return Image.file(bannerFile!, fit: BoxFit.cover);
    }
    if (user.banner.isNotEmpty && user.banner != AppConstants.bannerDefault) {
      return Image.network(user.banner, fit: BoxFit.cover);
    }
    return const Center(
      child: Icon(Icons.camera_alt_outlined, size: 44),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when<Widget>(
          data: (user) => Scaffold(
            backgroundColor: AppTheme.darkModeAppTheme.colorScheme.background,
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Edit Community'),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => save(user),
                    child: const Text('Save'),
                  ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: AppColors.whiteColor,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: getBannerImage(user),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 18,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        profileFile != null ? FileImage(profileFile!) as ImageProvider : NetworkImage(user.profilePicture),
                                    radius: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.blueColor),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, _) => ErrorTextWidget(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
