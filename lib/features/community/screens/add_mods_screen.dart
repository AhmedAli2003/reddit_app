import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/theme/app_colors.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/community/widgets/custom_adaptive_check_tile.dart';

final simpleProviderForUI = StateProvider<bool>((_) => false);

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
  final Set<String> previusMods = {};
  final Set<String> members = {};

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
          context: context,
          communityName: widget.name,
          uids: members.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (_, ref, __) {
              ref.watch(simpleProviderForUI);
              final change = setEquals(members, previusMods);
              return IconButton(
                onPressed: change || isLoading ? null : saveMods,
                icon: Icon(
                  Icons.done_rounded,
                  color: change ? AppColors.greyColor : AppColors.whiteColor,
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : ref.watch(getCommunityByNameProvider(widget.name)).when(
                data: (community) {
                  return ListView.builder(
                    itemCount: community.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final member = community.members[index];
                      return CustomAdaptiveCheckTile(
                        member: member,
                        members: members,
                        previusMods: previusMods,
                        mods: community.mods,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => ErrorTextWidget(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
