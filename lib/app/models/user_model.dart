import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' show immutable;
import 'package:reddit_app/app/constants/app_constants.dart';

@immutable
class UserModel {
  final String name;
  final String email;
  final String profilePicture;
  final String banner;
  final String uid;
  final bool isNotGuest;
  final int karma;
  final List<String> awards;

  const UserModel({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.banner,
    required this.uid,
    required this.isNotGuest,
    required this.karma,
    required this.awards,
  });

  factory UserModel.fromCredential(User user) {
    return UserModel(
      name: user.displayName ?? AppConstants.unknown,
      email: user.email ?? AppConstants.unknown,
      profilePicture: user.photoURL ?? AppConstants.avatarDefault,
      banner: AppConstants.bannerDefault,
      uid: user.uid,
      isNotGuest: true,
      karma: 0,
      awards: const ['til', 'awesomeAns', 'helpful', 'thankyou', 'rocket', 'plusone', 'platinum', 'gold'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePicture,
    String? banner,
    String? uid,
    bool? isNotGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isNotGuest: isNotGuest ?? this.isNotGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'banner': banner,
      'uid': uid,
      'isNotGuest': isNotGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      profilePicture: map['profilePicture'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isNotGuest: map['isNotGuest'] as bool,
      karma: map['karma'] as int,
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() =>
      'UserModel(name: $name, email: $email, profilePicture: $profilePicture, banner: $banner, uid: $uid, isNotGuest: $isNotGuest, karma: $karma, awards: $awards)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
