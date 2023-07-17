import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  final Set<String> members = {};
  bool firstTime = true;

  void addMember(String member) {
    setState(() => members.add(member));
  }

  void removeMember(String member) {
    setState(() => members.remove(member));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                        data: (user) {
                          if (community.mods.contains(member) && firstTime == true) {
                            members.add(member);
                          }
                          firstTime = false;
                          return CheckboxListTile.adaptive(
                            value: members.contains(user.uid),
                            onChanged: (val) {
                              if (val!) {
                                addMember(user.uid);
                              } else {
                                removeMember(user.uid);
                              }
                            },
                            secondary: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePicture),
                            ),
                            title: Text(user.name),
                          );
                        },
                        error: (error, stackTrace) => ErrorTextWidget(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      );
                },
              );
            },
            error: (error, stackTrace) => ErrorTextWidget(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
