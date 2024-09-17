import 'dart:convert';

import 'package:moonbase_explore/model/upload_status_model.dart';

class Video {
  final String id;
  final String title;
  final String caption;
  final int videoNumber;
  final int unitNumber;
  final VideoDetails videoDetails;
  final int likesCount;
  final int totalCommentsCount;

  Video({
    required this.id,
    required this.title,
    required this.caption,
    required this.videoNumber,
    required this.unitNumber,
    required this.videoDetails,
    required this.likesCount,
    required this.totalCommentsCount,
  });

  Video copyWith({
    String? id,
    String? title,
    String? caption,
    int? videoNumber,
    int? unitNumber,
    VideoDetails? videoDetails,
    int? likesCount,
    int? totalCommentsCount,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      videoNumber: videoNumber ?? this.videoNumber,
      unitNumber: unitNumber ?? this.unitNumber,
      videoDetails: videoDetails ?? this.videoDetails,
      likesCount: likesCount ?? this.likesCount,
      totalCommentsCount: totalCommentsCount ?? this.totalCommentsCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'caption': caption,
      'videoNumber': videoNumber,
      'unitNumber': unitNumber,
      'videoDetails': videoDetails.toMap(),
      'likesCount': likesCount,
      'totalCommentsCount': totalCommentsCount,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      caption: map['caption'] ?? '',
      videoNumber: map['videoNumber']?.toInt() ?? 0,
      unitNumber: map['unitNumber']?.toInt() ?? 0,
      videoDetails: VideoDetails.fromMap(map['videoDetails']),
      likesCount: map['likesCount']?.toInt() ?? 0,
      totalCommentsCount: map['totalCommentsCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Video(id: $id, title: $title, caption: $caption, videoNumber: $videoNumber, unitNumber: $unitNumber, videoDetails: $videoDetails, likesCount: $likesCount, totalCommentsCount: $totalCommentsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Video &&
        other.id == id &&
        other.title == title &&
        other.caption == caption &&
        other.videoNumber == videoNumber &&
        other.unitNumber == unitNumber &&
        other.videoDetails == videoDetails &&
        other.likesCount == likesCount &&
        other.totalCommentsCount == totalCommentsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        caption.hashCode ^
        videoNumber.hashCode ^
        unitNumber.hashCode ^
        videoDetails.hashCode ^
        likesCount.hashCode ^
        totalCommentsCount.hashCode;
  }
}

class VideoDetails {
  final UploadStatsModel? uploadStats;
  final String videoPath;
  final String coverImagePath;
  final String localCoverImagePath;
  final String? localPath;
  VideoDetails({
    required this.videoPath,
    required this.coverImagePath,
    this.localCoverImagePath = '',
    this.localPath,
    this.uploadStats,
  });

  VideoDetails copyWith(
      {String? videoPath,
      String? coverImagePath,
      String? localCoverImagePath,
      String? localPath,
      UploadStatsModel? uploadStats}) {
    return VideoDetails(
      videoPath: videoPath ?? this.videoPath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      localCoverImagePath: localCoverImagePath ?? this.localCoverImagePath,
      localPath: localPath ?? this.localPath,
      uploadStats: uploadStats ?? this.uploadStats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoPath': videoPath,
      'coverImagePath': coverImagePath,
      'localCoverImagePath': localCoverImagePath,
      'localPath': localPath,
      'uploadStats': uploadStats?.toMap()
    };
  }

  factory VideoDetails.fromMap(Map<String, dynamic> map) {
    return VideoDetails(
      videoPath: map['videoPath'] ?? '',
      coverImagePath: map['coverImagePath'] ?? '',
      localCoverImagePath: map['localCoverImagePath'] ?? '',
      localPath: map['localPath'] ?? '',
      uploadStats: map['uploadStats'] != null
          ? UploadStatsModel.fromMap(map['uploadStats'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoDetails.fromJson(String source) =>
      VideoDetails.fromMap(json.decode(source));

  @override
  String toString() =>
      'VideoDetails(videoPath: $videoPath, coverImagePath: $coverImagePath)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoDetails &&
        other.videoPath == videoPath &&
        other.coverImagePath == coverImagePath;
  }

  @override
  int get hashCode => videoPath.hashCode ^ coverImagePath.hashCode;
}
