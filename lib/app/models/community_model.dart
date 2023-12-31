import 'package:flutter/foundation.dart';

import 'package:reddit_app/app/constants/app_constants.dart';

@immutable
class Community {
  final String id;
  final String name;
  final String creatorUid;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> mods;

  const Community({
    required this.id,
    required this.name,
    required this.creatorUid,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.mods,
  });

  factory Community.byUser({
    required String name,
    required String creatorUid,
  }) {
    return Community(
      id: name,
      name: name,
      creatorUid: creatorUid,
      avatar: AppConstants.avatarDefault,
      banner: AppConstants.bannerDefault,
      members: [creatorUid],
      mods: [creatorUid],
    );
  }

  Community copyWith({
    String? id,
    String? name,
    String? creatorUid,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? mods,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorUid: creatorUid ?? this.creatorUid,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'creatorUid': creatorUid,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      creatorUid: map['creatorUid'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: List<String>.from((map['members'])),
      mods: List<String>.from((map['mods'])),
    );
  }

  @override
  String toString() => 'Community(id: $id, name: $name, creatorUid: $creatorUid, banner: $banner, avatar: $avatar, members: $members, mods: $mods)';

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
