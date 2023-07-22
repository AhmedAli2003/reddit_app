import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/posts/controller/posts_controller.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  File? bannerFile;
  late final String type;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkController;
  Community? selectedCommunity;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    _titleController = TextEditingController();
    if (type == 'text') {
      _descriptionController = TextEditingController();
    } else if (type == 'link') {
      _linkController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    if (type == 'text') {
      _descriptionController.dispose();
    } else if (type == 'link') {
      _linkController.dispose();
    }
    super.dispose();
  }

  void selectBannerImage() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() => bannerFile = File(picked.files.first.path!));
    }
  }

  Widget getBannerImage(UserModel user) {
    if (bannerFile != null) {
      return Image.file(bannerFile!, fit: BoxFit.cover);
    }
    return const Center(
      child: Icon(Icons.camera_alt_outlined, size: 44),
    );
  }

  String get postTitle => _titleController.text.trim();

  void sharePost() {
    if (postTitle.isNotEmpty && selectedCommunity != null) {
      if (type == 'image' && bannerFile != null) {
        ref.read(postsControllerProvider.notifier).shareImagePost(
              context: context,
              title: postTitle,
              selectedCommunity: selectedCommunity!,
              image: bannerFile,
            );
      } else if (type == 'text') {
        ref.read(postsControllerProvider.notifier).shareTextPost(
              context: context,
              title: postTitle,
              selectedCommunity: selectedCommunity!,
              description: _descriptionController.text.trim(),
            );
      } else if (type == 'link') {
        ref.read(postsControllerProvider.notifier).shareLinkPost(
              context: context,
              title: postTitle,
              selectedCommunity: selectedCommunity!,
              link: _linkController.text.trim(),
            );
      } else {
        debugPrint('Type must be link, text or image!!!');
      }
    } else {
      showSnackBar(
        context,
        selectedCommunity == null ? 'Choose a community' : 'Enter a title for the post',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = type == 'image';
    final isTypeText = type == 'text';
    final isTypeLink = type == 'link';
    // final currentTheme = ref.watch(themeProvider);
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(postsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter title here',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blueColor),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isTypeImage)
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
                  if (isTypeText)
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter description here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blueColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: _linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter link here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blueColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (communities) {
                          if (communities.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                            value: selectedCommunity,
                            items: communities
                                .map(
                                  (community) => DropdownMenuItem(
                                    value: community,
                                    child: Text(
                                      community.name,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (community) {
                              setState(() => selectedCommunity = community);
                            },
                          );
                        },
                        error: (error, _) => ErrorTextWidget(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
    );
  }
}
