import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/shared/providers/storage_repository_provider.dart';
import 'package:reddit_app/app/shared/type_defs.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:routemaster/routemaster.dart';

final getCommunityByNameProvider = StreamProvider.family<Community, String>(
  (ref, name) => ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    ref: ref,
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepository: ref.watch(firebaseStorageRepositoryProvider),
  ),
);

final searchCommunityProvider = StreamProvider.family<List<Community>, String>(
  (ref, query) => ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController({
    required Ref ref,
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        super(false); // for loading

  Future<void> createCommunity(BuildContext context, String name) async {
    // user here cannot be null
    final creatorUid = _ref.read(userProvider)!.uid;
    final community = Community.byUser(name: name, creatorUid: creatorUid);

    state = true; // start loading
    final either = await _communityRepository.createCommunity(community);
    state = false; // end loading

    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) {
        showSnackBar(context, 'Community created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCimmunityByName(name);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Future<void> editCommunity({
    required BuildContext context,
    required File? profileFile,
    required File? bannerFile,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null) {
      final either = await _storageRepository.storeFile(
        path: 'communities/profiles',
        id: community.name,
        file: profileFile,
      );
      either.fold(
        (failure) => showSnackBar(context, failure.message),
        (profileUrl) => community = community.copyWith(avatar: profileUrl),
      );
    }

    if (bannerFile != null) {
      final either = await _storageRepository.storeFile(
        path: 'communities/banners',
        id: community.name,
        file: bannerFile,
      );
      either.fold(
        (failure) => showSnackBar(context, failure.message),
        (bannerUrl) => community = community.copyWith(banner: bannerUrl),
      );
    }

    final either = await _communityRepository.editCommunity(community);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Future<void> joinCommunity(BuildContext context, Community community) async {
    final user = _ref.read(userProvider)!;
    final FutureVoid either;
    final isInCommunity = community.members.contains(user.uid);
    if (isInCommunity) {
      either = _communityRepository.leaveCommunity(
        communityName: community.name,
        userId: user.uid,
      );
    } else {
      either = _communityRepository.joinCommunity(
        communityName: community.name,
        userId: user.uid,
      );
    }
    state = true;
    (await either).fold(
      (failure) => showSnackBar(context, failure.message),
      (_) {
        if (isInCommunity) {
          showSnackBar(context, 'Community left successfully');
        } else {
          showSnackBar(context, 'Community joined successfully');
        }
      },
    );
    state = false;
  }

  Future<void> addMods({
    required BuildContext context,
    required String communityName,
    required List<String> uids,
  }) async {
    state = true;
    final either = await _communityRepository.addMods(communityName: communityName, uids: uids);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => Routemaster.of(context).pop(),
    );
  }
}
