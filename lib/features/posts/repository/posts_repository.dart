import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/comment.dart';
import 'package:reddit_app/app/models/community_model.dart';
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
  CollectionReference get _comments => _firestore.collection(FirebaseConstants.commentsCollection);

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

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where(
          'communityName',
          whereIn: communities
              .map(
                (community) => community.name,
              )
              .toList(),
        )
        .orderBy(
          'creationDate',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(String postId) async {
    try {
      await _posts.doc(postId).delete();
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid upvote(Post post, String userId) async {
    try {
      if (post.downVotes.contains(userId)) {
        _posts.doc(post.id).update({
          'downVotes': FieldValue.arrayRemove([userId]),
        });
      }

      if (post.upVotes.contains(userId)) {
        _posts.doc(post.id).update({
          'upVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        _posts.doc(post.id).update({
          'upVotes': FieldValue.arrayUnion([userId])
        });
      }
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid downvote(Post post, String userId) async {
    try {
      if (post.upVotes.contains(userId)) {
        _posts.doc(post.id).update({
          'upVotes': FieldValue.arrayRemove([userId]),
        });
      }

      if (post.downVotes.contains(userId)) {
        _posts.doc(post.id).update({
          'downVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        _posts.doc(post.id).update({
          'downVotes': FieldValue.arrayUnion([userId])
        });
      }
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
