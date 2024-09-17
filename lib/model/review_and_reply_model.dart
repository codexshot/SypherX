import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:moonbase_explore/model/user_short_info.dart';

class Review {
  final String id;
  final String createdAt;
  final String exploreId;
  final String? updatedOn;
  final int likesCount;
  final int replyCount;
  final String text;
  final List<Reply> replies;
  final UserShortInfo userInfo;
  final int userRating;

  Review({
    required this.id,
    required this.createdAt,
    required this.exploreId,
    this.updatedOn,
    required this.likesCount,
    required this.replyCount,
    required this.text,
    required this.replies,
    required this.userInfo,
    required this.userRating,
  });

  Review copyWith({
    String? id,
    String? createdAt,
    String? exploreId,
    String? updatedOn,
    int? likesCount,
    int? replyCount,
    String? text,
    List<Reply>? replies,
    UserShortInfo? userInfo,
    int? userRating,
  }) {
    return Review(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      exploreId: exploreId ?? this.exploreId,
      updatedOn: updatedOn ?? this.updatedOn,
      likesCount: likesCount ?? this.likesCount,
      replyCount: replyCount ?? this.replyCount,
      text: text ?? this.text,
      replies: replies ?? this.replies,
      userInfo: userInfo ?? this.userInfo,
      userRating: userRating ?? this.userRating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'exploreId': exploreId,
      'updatedOn': updatedOn,
      'likesCount': likesCount,
      'replyCount': replyCount,
      'text': text.trim(),
      'replies': replies.map((x) => x.toMap()).toList(),
      'userInfo': userInfo.toMap(),
      'userRating': userRating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      createdAt: map['createdAt'] ?? '',
      exploreId: map['exploreId'] ?? '',
      updatedOn: map['updatedOn'],
      likesCount: map['likesCount']?.toInt() ?? 0,
      replyCount: map['replyCount']?.toInt() ?? 0,
      text: map['text'] ?? '',
      replies: List<Reply>.from(map['replies']?.map((x) => Reply.fromMap(x))),
      userInfo: UserShortInfo.fromMap(map['userInfo']),
      userRating: map['userRating']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(id: $id, createdAt: $createdAt, exploreId: $exploreId, updatedOn: $updatedOn, likesCount: $likesCount, replyCount: $replyCount, text: $text, replies: $replies, userInfo: $userInfo, userRating: $userRating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.exploreId == exploreId &&
        other.updatedOn == updatedOn &&
        other.likesCount == likesCount &&
        other.replyCount == replyCount &&
        other.text == text &&
        listEquals(other.replies, replies) &&
        other.userInfo == userInfo &&
        other.userRating == userRating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        exploreId.hashCode ^
        updatedOn.hashCode ^
        likesCount.hashCode ^
        replyCount.hashCode ^
        text.hashCode ^
        replies.hashCode ^
        userInfo.hashCode ^
        userRating.hashCode;
  }
}

class Reply {
  final String id;
  final String parentId;
  final int likesCount;
  final String text;
  final UserShortInfo userInfo;
  final String createdAt;
  final String? updatedOn;
  final String exploreId;
  Reply({
    required this.id,
    required this.parentId,
    required this.likesCount,
    required this.text,
    required this.userInfo,
    required this.createdAt,
    this.updatedOn,
    required this.exploreId,
  });

  Reply copyWith({
    String? id,
    String? parentId,
    int? likesCount,
    String? text,
    UserShortInfo? userInfo,
    String? createdAt,
    String? updatedOn,
    String? exploreId,
  }) {
    return Reply(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      likesCount: likesCount ?? this.likesCount,
      text: text ?? this.text,
      userInfo: userInfo ?? this.userInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedOn: updatedOn ?? this.updatedOn,
      exploreId: exploreId ?? this.exploreId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'likesCount': likesCount,
      'text': text,
      'userInfo': userInfo.toMap(),
      'createdAt': createdAt,
      'updatedOn': updatedOn,
      'exploreId': exploreId,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] ?? '',
      parentId: map['parentId'] ?? '',
      likesCount: map['likesCount']?.toInt() ?? 0,
      text: map['text'] ?? '',
      userInfo: UserShortInfo.fromMap(map['userInfo']),
      createdAt: map['createdAt'] ?? '',
      updatedOn: map['updatedOn'],
      exploreId: map['exploreId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) => Reply.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reply(id: $id, parentId: $parentId, likesCount: $likesCount, text: $text, userInfo: $userInfo, createdAt: $createdAt, updatedOn: $updatedOn, exploreId: $exploreId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reply &&
        other.id == id &&
        other.parentId == parentId &&
        other.likesCount == likesCount &&
        other.text == text &&
        other.userInfo == userInfo &&
        other.createdAt == createdAt &&
        other.updatedOn == updatedOn &&
        other.exploreId == exploreId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        parentId.hashCode ^
        likesCount.hashCode ^
        text.hashCode ^
        userInfo.hashCode ^
        createdAt.hashCode ^
        updatedOn.hashCode ^
        exploreId.hashCode;
  }
}
