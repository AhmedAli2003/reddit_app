import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

@immutable
class Comment {
  final String id;
  final String text;
  final DateTime creationTime;
  final String postId;
  final String userId;

  const Comment({
    required this.id,
    required this.text,
    required this.creationTime,
    required this.postId,
    required this.userId,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? creationTime,
    String? postId,
    String? userId,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      creationTime: creationTime ?? this.creationTime,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'creationTime': creationTime.millisecondsSinceEpoch,
      'postId': postId,
      'userId': userId,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      creationTime: DateTime.fromMillisecondsSinceEpoch(map['creationTime'] as int),
      postId: map['postId'] as String,
      userId: map['userId'] as String,
    );
  }

  factory Comment.fromText({
    required String text,
    required String userId,
    required String postId,
  }) {
    return Comment(
      id: const Uuid().v4(),
      text: text,
      creationTime: DateTime.now(),
      postId: postId,
      userId: userId,
    );
  }

  @override
  String toString() => 'Comment(id: $id, text: $text, creationTime: $creationTime, postId: $postId, userId: $userId)';

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
