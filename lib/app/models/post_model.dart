import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePicture;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String username;
  final String userId;
  final String type;
  final DateTime creationDate;
  final List<String> awards;

  const Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePicture,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.username,
    required this.userId,
    required this.type,
    required this.creationDate,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePicture,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? username,
    String? userId,
    String? type,
    DateTime? creationDate,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePicture: communityProfilePicture ?? this.communityProfilePicture,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      creationDate: creationDate ?? this.creationDate,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePicture': communityProfilePicture,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'username': username,
      'userId': userId,
      'type': type,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      communityName: map['communityName'] as String,
      communityProfilePicture: map['communityProfilePicture'] as String,
      upVotes: List<String>.from((map['upVotes'] as List<dynamic>)),
      downVotes: List<String>.from((map['downVotes'] as List<dynamic>)),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
      awards: List<String>.from((map['awards'] as List<dynamic>)),
    );
  }

  @override
  String toString() =>
      'Post(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePicture: $communityProfilePicture, upVotes: $upVotes, downVotes: $downVotes, commentCount: $commentCount, username: $username, userId: $userId, type: $type, creationDate: $creationDate, awards: $awards)';

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
