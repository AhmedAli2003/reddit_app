import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/constants/app_constants.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/theme/app_theme.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

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

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          profileFile: profileFile,
          bannerFile: bannerFile,
          community: community,
        );
  }

  Widget getBannerImage(Community community) {
    if (bannerFile != null) {
      return Image.file(bannerFile!, fit: BoxFit.cover);
    }
    if (community.banner.isNotEmpty && community.banner != AppConstants.bannerDefault) {
      return Image.network(community.banner, fit: BoxFit.cover);
    }
    return const Center(
      child: Icon(Icons.camera_alt_outlined, size: 44),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when<Widget>(
          data: (community) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.colorScheme.background,
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Edit Community'),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => save(community),
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
                                    child: getBannerImage(community),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 18,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: CircleAvatar(
                                    backgroundImage: profileFile != null ? FileImage(profileFile!) as ImageProvider : NetworkImage(community.avatar),
                                    radius: 32,
                                  ),
                                ),
                              ),
                            ],
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
