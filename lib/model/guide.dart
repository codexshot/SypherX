import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:moonbase_explore/model/price_model.dart';
import 'package:moonbase_explore/model/prospective_error_model.dart';
import 'package:moonbase_explore/model/quiz_model.dart';
import 'package:moonbase_explore/model/review_and_reply_model.dart';
import 'package:moonbase_explore/model/unit_model.dart';
import 'package:moonbase_explore/model/user_short_info.dart';
import 'package:moonbase_explore/model/video_model.dart';
import 'package:tempo_location_service/tempo_location_service.dart';

import '../database/explore_db_constants.dart';
import 'collab_model.dart';
import 'collab_type.dart';
import 'connect_group_model.dart';
import 'explore_data_models.dart';
import 'hash_tag_model.dart';

class Guide extends Collab {
  Guide({
    required super.id,
    super.collabType = CollabType.guide,
    super.category,
    required super.title,
    required super.description,
    super.location,
    required super.trailerVideo,
    super.connectedGroup,
    required this.units,
    required this.quizzes,
    super.tags,
    super.isFree,
    super.price,
    super.latestReviews,
    super.totalReviewsCount,
    super.exploreRating,
    required super.creatorInfo,
    required super.buyers,
    super.status,
    super.error,
    super.isPromoted,
  });

  final List<Unit> units;
  final List<QuizModel> quizzes;

  @override
  Collab copyWith({
    String? id,
    CollabType? collabType,
    ExploreCategory? category,
    String? title,
    String? description,
    PlaceModel? location,
    VideoDetails? trailerVideo,
    ConnectedGroupModel? connectedGroup,
    List<Unit>? units,
    List<QuizModel>? quizzes,
    List<HashTags>? tags,
    bool? isFree,
    CollabPrice? price,
    List<Review>? latestReviews,
    int? totalReviewsCount,
    ExploreRating? rating,
    UserShortInfo? creatorInfo,
    List<Buyer>? buyers,
    GuideStatus? status,
    ProspectiveError? error,
    bool? isPromoted,
  }) =>
      Guide(
        id: id ?? this.id,
        collabType: CollabType.guide,
        category: category ?? this.category,
        title: title ?? this.title,
        description: description ?? this.description,
        location: location ?? this.location,
        trailerVideo: trailerVideo ?? this.trailerVideo,
        connectedGroup: connectedGroup ?? this.connectedGroup,
        units: units ?? this.units,
        quizzes: quizzes ?? this.quizzes,
        tags: tags ?? this.tags,
        price: price ?? this.price,
        isFree: isFree ?? this.isFree,
        latestReviews: latestReviews ?? this.latestReviews,
        totalReviewsCount: totalReviewsCount ?? this.totalReviewsCount,
        exploreRating: rating ?? exploreRating,
        creatorInfo: creatorInfo ?? this.creatorInfo,
        buyers: buyers ?? this.buyers,
        status: status ?? this.status,
        error: error ?? this.error,
        isPromoted: isPromoted ?? this.isPromoted
      );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map.addAll(super.toMap());
    map.addAll({
      dbUnits: units.map((x) => x.toMap()).toList(),
    });
    map.addAll({
      dbQuizzes: quizzes.map((x) => x.toMap()).toList(),
    });
    return map;
  }

  factory Guide.fromMap(Map<String, dynamic> map) {
    return Guide(
      id: map[dbId],
      collabType: CollabType.fromString(map[dbCollabType]),
      category: map[dbCategory] != null ? ExploreCategory.fromMap(map[dbCategory]) : null,
      location: map[dbLocation] != null ? PlaceModel.fromJson(map[dbLocation]) : null,
      title: map[dbTitle],
      description: map[dbDescription],
      trailerVideo: VideoDetails.fromMap(map[dbTrailerVideo]),
      connectedGroup: map[dbConnectedGroup] != null ? ConnectedGroupModel.fromMap(map[dbConnectedGroup]) : null,
      units: map[dbUnits] != null ? List<Unit>.from(map[dbUnits]?.map((x) => Unit.fromMap(x))) : [],
      quizzes: map[dbQuizzes] != null ? List<QuizModel>.from(map[dbQuizzes]?.map((x) => QuizModel.fromMap(x))) : [],
      tags: map[dbTags] != null ? List<HashTags>.from(map[dbTags]?.map((x) => HashTags.fromMap(x))) : [],
      isFree: map[dbIsFree] ?? true,
      price: map[dbPrice] != null ? CollabPrice.fromMap((map[dbPrice])) : null,
      latestReviews:
          map[dbLatestReviews] != null ? List<Review>.from(map[dbLatestReviews]?.map((x) => Review.fromMap(x))) : [],
      totalReviewsCount: map[dbTotalReviewsCount] ?? 0,
      exploreRating: map[dbExploreRating] != null ? ExploreRating.fromMap(map[dbExploreRating]) : null,
      creatorInfo: UserShortInfo.fromMap(map[dbCreatorInfo]),
      buyers: map[dbBuyers] != null ? List<Buyer>.from(map[dbBuyers]?.map((x) => Buyer.fromJson(x))) : [],
      status: map[dbStatus] != null ? GuideStatus.fromString(map[dbStatus]) : null,
      error: ProspectiveError.fromMap(map[dbErrorMessage] ?? {}),
      isPromoted: map[dbIsPromoted] ?? false,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Guide.fromJson(String source) => Guide.fromMap(json.decode(source));

  @override
  String toString() => 'Guide(units: $units, quizzes:$quizzes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Guide && listEquals(other.units, units) && listEquals(other.quizzes, quizzes);
  }

  @override
  int get hashCode => units.hashCode ^ quizzes.hashCode;
}
