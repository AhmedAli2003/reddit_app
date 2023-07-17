import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  void navigateToCommunityScreen(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when<Widget>(
          data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text('/r/${community.name}'),
                onTap: () => navigateToCommunityScreen(context, community.name),
              );
            },
          ),
          error: (error, _) => ErrorTextWidget(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
