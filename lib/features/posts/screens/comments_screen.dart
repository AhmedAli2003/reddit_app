import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/post_model.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/posts/controller/posts_controller.dart';
import 'package:reddit_app/features/posts/widgets/post_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void addComment(String value) {
    ref.read(postsControllerProvider.notifier).addComment(
          context: context,
          text: value.trim(),
          postId: widget.postId,
        );
    setState(() {
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (post) => SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: post),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentController,
                        onSubmitted: addComment,
                        decoration: const InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'What are your thoughts...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, _) => ErrorTextWidget(error: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
