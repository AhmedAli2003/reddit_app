import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/shared_providers.dart';
import 'package:reddit_app/app/shared/type_defs.dart';

final communityRepositoryProvider = Provider<CommunityRepository>(
  (ref) => CommunityRepository(
    firestore: ref.read(firebaseFirestoreProvider),
  ),
);

class CommunityRepository {
  final FirebaseFirestore _firestore;
  const CommunityRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
      }
      await _communities.doc(community.name).set(community.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message!));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      final List<Community> communities = [];
      for (final doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }
}
