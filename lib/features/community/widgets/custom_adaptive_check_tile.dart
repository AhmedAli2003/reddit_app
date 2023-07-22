import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:reddit_app/features/community/screens/add_mods_screen.dart';

class CustomAdaptiveCheckTile extends ConsumerStatefulWidget {
  final String member;
  final Set<String> members;
  final Set<String> previusMods;
  final List<String> mods;

  const CustomAdaptiveCheckTile({
    super.key,
    required this.member,
    required this.members,
    required this.previusMods,
    required this.mods,
  });

  @override
  ConsumerState<CustomAdaptiveCheckTile> createState() => _CustomAdaptiveCheckTileState();
}

class _CustomAdaptiveCheckTileState extends ConsumerState<CustomAdaptiveCheckTile> {
  bool firstTime = true;

  void updateSaveButtonState() {
    ref.read(simpleProviderForUI.notifier).update((state) => !state);
  }

  void addMember(String uid) {
    setState(() => widget.members.add(uid));
    updateSaveButtonState();
  }

  void removeMember(String uid) {
    setState(() => widget.members.remove(uid));
    updateSaveButtonState();
  }

  void onChange(bool val, String uid) => val ? addMember(uid) : removeMember(uid);

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserDataProvider(widget.member)).when(
          data: (user) {
            if (firstTime && widget.mods.contains(widget.member)) {
              firstTime = false;
              widget.previusMods.add(widget.member);
              widget.members.add(widget.member);
            }
            return CheckboxListTile.adaptive(
              value: widget.members.contains(user.uid),
              onChanged: (val) => onChange(val!, user.uid),
              secondary: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicture),
              ),
              title: Text(user.name),
            );
          },
          error: (error, stackTrace) => ErrorTextWidget(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
