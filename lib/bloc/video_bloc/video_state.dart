part of 'video_bloc.dart';

class VideoState extends Equatable {
  final String? videoPath;
  final String? imagePath;

  @override
  // TODO: implement props
  List<Object?> get props => [videoPath,imagePath];

  const VideoState({
    this.videoPath,
    this.imagePath
  });

  VideoState copyWith({
    String? videoPath,
    String? imagePath
  }) {
    return VideoState(
      videoPath: videoPath ?? this.videoPath,
      imagePath: imagePath??this.imagePath
    );
  }
}
