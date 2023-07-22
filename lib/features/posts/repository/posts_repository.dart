import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
import 'package:reddit_app/app/shared/type_defs.dart';

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepository(
    firestore: ref.read(firebaseFirestoreProvider),
  ),
);

class PostsRepository {
  final FirebaseFirestore _firestore;

  const PostsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost({required Post post}) async {
    try {
      await _posts.doc(post.id).set(post.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
