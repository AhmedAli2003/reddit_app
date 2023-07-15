import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    ref: ref,
    communityRepository: ref.watch(communityRepositoryProvider),
  ),
);

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController({
    required Ref ref,
    required CommunityRepository communityRepository,
  })  : _ref = ref,
        _communityRepository = communityRepository,
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

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }
}
