import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
import 'package:reddit_app/app/shared/type_defs.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firestore: ref.read(firebaseFirestoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  const UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      await _users.doc(user.uid).update(user.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPosts(String userId) {
    return _posts
        .where('userId', isEqualTo: userId)
        .orderBy('creationDate', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (doc) => Post.fromMap(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      await _users.doc(user.uid).update({
        'karma': user.karma,
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
