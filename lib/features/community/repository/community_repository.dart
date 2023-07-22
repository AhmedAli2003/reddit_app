import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
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

  Stream<Community> getCimmunityByName(String name) {
    return _communities.doc(name).snapshots().map((doc) => Community.fromMap(doc.data() as Map<String, dynamic>));
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

  FutureVoid editCommunity(Community community) async {
    try {
      await _communities.doc(community.id).update(community.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      final List<Community> communities = [];
      for (final doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity({
    required String communityName,
    required String userId,
  }) async {
    try {
      await _communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId]),
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity({
    required String communityName,
    required String userId,
  }) async {
    try {
      await _communities.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId]),
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid addMods({
    required String communityName,
    required List<String> uids,
  }) async {
    try {
      await _communities.doc(communityName).update({'mods': uids});
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
