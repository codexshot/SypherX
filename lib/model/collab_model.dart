import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:moonbase_explore/model/price_model.dart';
import 'package:moonbase_explore/model/prospective_error_model.dart';
import 'package:moonbase_explore/model/review_and_reply_model.dart';
import 'package:moonbase_explore/model/user_short_info.dart';
import 'package:moonbase_explore/model/video_model.dart';
import 'package:tempo_location_service/tempo_location_service.dart';

import '../database/explore_db_constants.dart';
import 'guide.dart';
import 'collab_type.dart';
import 'connect_group_model.dart';
import 'explore_data_models.dart';
import 'hash_tag_model.dart';

enum GuideStatus {
  uninitialised,
  initialised,
  uploading,
  published;

  static GuideStatus fromString(String index) {
    switch (index) {
      case 'uninitialised':
        return uninitialised;
      case 'initialised':
        return initialised;
      case 'uploading':
        return uploading;
      case 'published':
        return published;
      default:
        return uninitialised;
    }
  }

  String asString() {
    switch (this) {
      case uninitialised:
        return 'uninitialised';
      case initialised:
        return 'initialised';
      case uploading:
        return 'uploading';
      case published:
        return 'published';
      default:
        return 'uninitialised';
    }
  }
}

abstract class Collab {
  final String id;
  final CollabType collabType;
  final ExploreCategory? category;
  final String title;
  final String description;
  final PlaceModel? location;
  final VideoDetails trailerVideo;
  final ConnectedGroupModel? connectedGroup;
  final List<HashTags> tags;
  final bool isFree;
  final CollabPrice? price;
  final List<Review> latestReviews;
  final int totalReviewsCount;
  final ExploreRating? exploreRating;
  final UserShortInfo creatorInfo;
  final List<Buyer> buyers;
  final GuideStatus? status;
  final ProspectiveError? error;
  final bool isPromoted;

  Collab({
    required this.id,
    required this.collabType,
    required this.buyers,
    this.category,
    required this.title,
    required this.description,
    this.location,
    required this.trailerVideo,
    this.connectedGroup,
    this.tags = const [],
    this.isFree = true,
    this.price,
    this.latestReviews = const [],
    this.totalReviewsCount = 0,
    required this.creatorInfo,
    this.exploreRating,
    this.status,
    this.error,
    this.isPromoted = false
  });

  Collab copyWith({
    String? id,
    CollabType? collabType,
    ExploreCategory? category,
    String? title,
    String? description,
    PlaceModel? location,
    VideoDetails? trailerVideo,
    ConnectedGroupModel? connectedGroup,
    List<HashTags>? tags,
    bool? isFree,
    CollabPrice? price,
    List<Review>? latestReviews,
    int? totalReviewsCount,
    UserShortInfo? creatorInfo,
    ExploreRating? rating,
    List<Buyer> buyers,
    GuideStatus? status,
    ProspectiveError? error,
    bool? isPromoted,
  });

  factory Collab.fromMap(Map<String, dynamic> map) {
    final collabType = CollabType.fromString(map[dbCollabType]);
    /* switch (collabType) {
      case CollabType.routine:
        return Routine.fromMap(map);
      case CollabType.guide:
        return Guide.fromMap(map);
    }*/
    return Guide.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      dbId: id,
      dbCollabType: collabType.asString(),
      dbCategory: category?.toMap(),
      dbTitle: title.trim(),
      dbDescription: description.trim(),
      dbLocation: location?.toJson(),
      dbTrailerVideo: trailerVideo.toMap(),
      dbConnectedGroup: connectedGroup?.toMap(),
      dbTags: tags.map((x) => x.toMap()).toList(),
      dbIsFree: isFree,
      dbPrice: price?.toMap(),
      dbLatestReviews: latestReviews.map((x) => x.toMap()).toList(),
      dbTotalReviewsCount: totalReviewsCount,
      dbCreatorInfo: creatorInfo.toMap(),
      dbExploreRating: exploreRating?.toMap(),
      dbBuyers: buyers.map((e) => e.toJson()).toList(),
      dbStatus: status?.asString(),
      dbErrorMessage: error?.toMap(),
      dbIsPromoted: isPromoted,
    };
  }

  String toJson() => json.encode(toMap());

  factory Collab.fromJson(String source) => Collab.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Collab(id: $id, collabType: $collabType, category: $category, title: $title, description: $description, location: $location, trailerVideo: $trailerVideo, connectedGroup: $connectedGroup, tags: $tags, isFree: $isFree, price: $price, latestReviews: $latestReviews, totalReviewsCount: $totalReviewsCount, creatorInfo: $creatorInfo, rating: $exploreRating, isPromoted $isPromoted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Collab &&
        other.id == id &&
        other.collabType == collabType &&
        other.category == category &&
        other.title == title &&
        other.description == description &&
        other.location == location &&
        other.trailerVideo == trailerVideo &&
        other.connectedGroup == connectedGroup &&
        listEquals(other.tags, tags) &&
        other.isFree == isFree &&
        other.price == price &&
        listEquals(other.latestReviews, latestReviews) &&
        other.totalReviewsCount == totalReviewsCount &&
        other.exploreRating == exploreRating &&
        other.creatorInfo == creatorInfo &&
        other.buyers == buyers &&
        other.isPromoted == isPromoted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        collabType.hashCode ^
        category.hashCode ^
        title.hashCode ^
        description.hashCode ^
        location.hashCode ^
        trailerVideo.hashCode ^
        connectedGroup.hashCode ^
        tags.hashCode ^
        isFree.hashCode ^
        price.hashCode ^
        latestReviews.hashCode ^
        totalReviewsCount.hashCode ^
        exploreRating.hashCode ^
        buyers.hashCode ^
        creatorInfo.hashCode ^
        isPromoted.hashCode;
  }
}

extension CollabExtension on Collab {
  // bool get isRoutine => this is Routine;
  bool get isGuide => this is Guide;
  // bool get isMeCreator => creatorInfo.uid == getIt<PreferenceManager>().myUid;
}

class Buyer {
  String? buyerCustId;
  String? purchasedDate;

  Buyer({this.buyerCustId, this.purchasedDate});

  Buyer.fromJson(Map<String, dynamic> json) {
    buyerCustId = json['buyer_cust_id'];
    purchasedDate = json['purchased_date'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['buyer_cust_id'] = buyerCustId;
    data['purchased_date'] = purchasedDate;
    return data;
  }
}

extension ExplorePurchaseExtension on Collab {
  // bool get isPurchased => buyers.any((element) => element.buyerCustId == getIt<PreferenceManager>().myUid);
}
