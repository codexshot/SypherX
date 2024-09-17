part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  final File? exploreThumbnail;
  final String? exploreTitle, exploreId, exploreDescription;
  final PlaceModel? exploreLocation;
  final File? exploreTrailerVideo;
  List<Unit>? units;
  final Video? currentVideo;
  ExploreCategory? exploreCategory;

  ExploreState({
    this.exploreThumbnail,
    this.exploreTitle,
    this.exploreId,
    this.exploreDescription,
    this.exploreLocation,
    this.exploreTrailerVideo,
    this.units = const [],
    this.currentVideo,
    this.exploreCategory,

  });

  @override
  List<Object?> get props => [
        exploreThumbnail,
        exploreTitle,
        exploreId,
        exploreDescription,
        exploreLocation,
        units,
        currentVideo,
        exploreCategory,
        exploreTrailerVideo,

      ];

  ExploreState copyWith({
    File? exploreThumbnail,
    String? exploreTitle,
    String? exploreId,
    String? exploreDescription,
    PlaceModel? exploreLocation,
    File? exploreTrailerVideo,
    List<Unit>? units,
    Video? currentVideo,
    File? exploreLocalThumbnail,
    ExploreCategory? exploreCategory,
  }) {
    return ExploreState(
        exploreThumbnail: exploreThumbnail ?? this.exploreThumbnail,
        exploreTitle: exploreTitle ?? this.exploreTitle,
        exploreId: exploreId ?? this.exploreId,
        exploreDescription: exploreDescription ?? this.exploreDescription,
        exploreLocation: exploreLocation ?? this.exploreLocation,
        exploreTrailerVideo: exploreTrailerVideo ?? this.exploreTrailerVideo,
        units: units ?? this.units,
        exploreCategory: exploreCategory ?? this.exploreCategory,
        currentVideo: currentVideo ?? this.currentVideo);
  }
}
