import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/comment.dart';
import 'package:reddit_app/app/models/community_model.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/shared/providers/storage_repository_provider.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/posts/repository/posts_repository.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postsControllerProvider = StateNotifierProvider<PostsController, bool>(
  (ref) => PostsController(
    ref: ref,
    postsRepository: ref.watch(postsRepositoryProvider),
    storageRepository: ref.watch(firebaseStorageRepositoryProvider),
  ),
);

final userPostsProvider = StreamProvider.family<List<Post>, List<Community>>(
  (ref, communities) => ref.read(postsControllerProvider.notifier).fetchUserPosts(communities),
);

final getPostByIdProvider = StreamProvider.family<Post, String>(
  (ref, postId) => ref.read(postsControllerProvider.notifier).getPostById(postId),
);

class PostsController extends StateNotifier<bool> {
  final Ref _ref;
  final PostsRepository _postsRepository;
  final StorageRepository _storageRepository;
  PostsController({
    required Ref ref,
    required PostsRepository postsRepository,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _postsRepository = postsRepository,
        _storageRepository = storageRepository,
        super(false); // for loading

  Future<void> shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePicture: selectedCommunity.avatar,
      upVotes: const [],
      downVotes: const [],
      commentCount: 0,
      username: user.name,
      userId: user.uid,
      type: 'text',
      creationDate: DateTime.now(),
      awards: const [],
      description: description,
    );
    final either = await _postsRepository.addPost(post: post);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) {
        showSnackBar(context, 'Posted successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Future<void> shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePicture: selectedCommunity.avatar,
      upVotes: const [],
      downVotes: const [],
      commentCount: 0,
      username: user.name,
      userId: user.uid,
      type: 'link',
      creationDate: DateTime.now(),
      awards: const [],
      link: link,
    );
    final either = await _postsRepository.addPost(post: post);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) {
        showSnackBar(context, 'Posted successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Future<void> shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? image,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageEither = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: image,
    );
    imageEither.fold(
      (imageFailure) => showSnackBar(context, imageFailure.message),
      (imageUrl) async {
        final post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePicture: selectedCommunity.avatar,
          upVotes: const [],
          downVotes: const [],
          commentCount: 0,
          username: user.name,
          userId: user.uid,
          type: 'image',
          creationDate: DateTime.now(),
          awards: const [],
          link: imageUrl,
        );
        final either = await _postsRepository.addPost(post: post);
        state = false;
        either.fold(
          (failure) => showSnackBar(context, failure.message),
          (_) {
            showSnackBar(context, 'Posted successfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postsRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Future<void> deletePost({
    required BuildContext context,
    required String postId,
  }) async {
    state = true;
    final either = await _postsRepository.deletePost(postId);
    state = false;
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => null,
    );
  }

  Future<void> upvote({
    required BuildContext context,
    required Post post,
  }) async {
    final uid = _ref.read(userProvider)!.uid;
    final either = await _postsRepository.upvote(post, uid);
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => null,
    );
  }

  Future<void> downvote({
    required BuildContext context,
    required Post post,
  }) async {
    final uid = _ref.read(userProvider)!.uid;
    final either = await _postsRepository.downvote(post, uid);
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => null,
    );
  }

  Stream<Post> getPostById(String postId) {
    return _postsRepository.getPostById(postId);
  }

  Future<void> addComment({
    required BuildContext context,
    required String text,
    required String postId,
  }) async {
    final userId = _ref.read(userProvider)!.uid;
    final comment = Comment.fromText(text: text, userId: userId, postId: postId);
    final either = await _postsRepository.addComment(comment);
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => null,
    );
  }
}
