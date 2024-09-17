import 'dart:convert';

import 'package:moonbase_explore/model/video_model.dart';

import '../database/explore_db_constants.dart';
import 'collab_model.dart';
import 'hash_tag_model.dart';

// ***************************************** Explore Model ******************************************

class ExploreCategory {
  final String id;
  final String name;
  final String description;
  final String? parentId;
  final String createdAt;
  final String updatedOn;

  ExploreCategory({
    required this.id,
    required this.name,
    required this.description,
    this.parentId,
    required this.createdAt,
    required this.updatedOn,
  });

  ExploreCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? createdAt,
    String? updatedOn,
  }) {
    return ExploreCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dbId: id,
      dbName: name,
      dbDescription: description,
      dbParentId: parentId,
      dbCreatedAt: createdAt,
      dbUpdatedOn: updatedOn,
    };
  }

  factory ExploreCategory.fromMap(Map<String, dynamic> map) {
    return ExploreCategory(
      id: map[dbId] ?? '',
      name: map[dbName] ?? '',
      description: map[dbDescription] ?? '',
      parentId: map[dbParentId] ?? '',
      createdAt: map[dbCreatedAt] ?? '',
      updatedOn: map[dbUpdatedOn] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExploreCategory.fromJson(String source) => ExploreCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, parentId: $parentId, createdAt: $createdAt, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExploreCategory &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.parentId == parentId &&
        other.createdAt == createdAt &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        parentId.hashCode ^
        createdAt.hashCode ^
        updatedOn.hashCode;
  }

  HashTags toHashTag() => HashTags(id: id, text: name, count: 0);
}

// ***************************************** Explore Model ******************************************

class ExploreRating {
  final String exploreId;
  final double rating;
  final int totalRatingCount;

  ExploreRating({
    required this.exploreId,
    required this.rating,
    required this.totalRatingCount,
  });

  ExploreRating copyWith({
    String? exploreId,
    double? rating,
    int? totalRatingCount,
  }) {
    return ExploreRating(
      exploreId: exploreId ?? this.exploreId,
      rating: rating ?? this.rating,
      totalRatingCount: totalRatingCount ?? this.totalRatingCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dbExploreId: exploreId,
      dbRating: rating,
      dbTotalRatingCount: totalRatingCount,
    };
  }

  factory ExploreRating.fromMap(Map<String, dynamic> map) {
    return ExploreRating(
      exploreId: map[dbExploreId] ?? '',
      rating: map[dbRating]?.toDouble() ?? 0.0,
      totalRatingCount: map[dbTotalRatingCount]?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExploreRating.fromJson(String source) => ExploreRating.fromMap(json.decode(source));

  @override
  String toString() => 'ExploreRating(exploreId: $exploreId, rating: $rating, totalRatingCount: $totalRatingCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExploreRating &&
        other.exploreId == exploreId &&
        other.rating == rating &&
        other.totalRatingCount == totalRatingCount;
  }

  @override
  int get hashCode => exploreId.hashCode ^ rating.hashCode ^ totalRatingCount.hashCode;
}

// ***************************************** Explore Options ******************************************
abstract class ExploreMoreOptions {
  final Collab explore;
  final String optionName;

  ExploreMoreOptions({
    required this.explore,
    required this.optionName,
  });

  Future<void> call();

  @override
  String toString() => 'ExploreMoreOptions(explore: $explore, optionName: $optionName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExploreMoreOptions && other.explore == explore && other.optionName == optionName;
  }

  @override
  int get hashCode => explore.hashCode ^ optionName.hashCode;
}

// ***************************************** Video State ******************************************

abstract class VideoMoreOptions {
  final Video video;
  final String optionName;
  final String exploreId;

  VideoMoreOptions({
    required this.video,
    required this.optionName,
    required this.exploreId,
  });

  Future<void> call();

  @override
  String toString() => 'VideoOptions(video: $video, optionName: $optionName, exploreId: $exploreId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoMoreOptions &&
        other.video == video &&
        other.optionName == optionName &&
        other.exploreId == exploreId;
  }

  @override
  int get hashCode => video.hashCode ^ optionName.hashCode ^ exploreId.hashCode;
}
