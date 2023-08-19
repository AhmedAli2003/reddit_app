import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/keys/enums.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/shared/providers/storage_repository_provider.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/profile/repository/user_profile_repository.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>(
  (ref) => UserProfileController(
    ref: ref,
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
    storageRepository: ref.watch(firebaseStorageRepositoryProvider),
  ),
);

final getUserPostsProvider = StreamProvider.family<List<Post>, String>(
  (ref, userId) => ref.read(userProfileControllerProvider.notifier).getUserPosts(userId),
);

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        super(false);

  Future<void> editProfile({
    required BuildContext context,
    required File? profileFile,
    required File? bannerFile,
    required String newName,
    required UserModel user,
  }) async {
    state = true;
    if (profileFile != null) {
      final either = await _storageRepository.storeFile(
        path: 'users/profiles',
        id: user.uid,
        file: profileFile,
      );
      either.fold(
        (failure) => showSnackBar(context, failure.message),
        (profileUrl) => user = user.copyWith(profilePicture: profileUrl),
      );
    }

    if (bannerFile != null) {
      final either = await _storageRepository.storeFile(
        path: 'users/banners',
        id: user.uid,
        file: bannerFile,
      );
      either.fold(
        (failure) => showSnackBar(context, failure.message),
        (bannerUrl) => user = user.copyWith(banner: bannerUrl),
      );
    }

    user = user.copyWith(name: newName);

    final either = await _userProfileRepository.editProfile(user);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String userId) {
    return _userProfileRepository.getUserPosts(userId);
  }

  Future<void> updateUserKarma(UserKarma userKarma) async {
    var user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + userKarma.karma);
    final either = await _userProfileRepository.updateUserKarma(user);
    either.fold(
      (failure) => null,
      (_) => _ref.read(userProvider.notifier).update((_) => user),
    );
  }
}
