part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class OpenImagePickerEvent extends VideoEvent {
  final BuildContext context;


  OpenImagePickerEvent(this.context);

}

class ProcessSelectVideoEvent extends VideoEvent {
 final BuildContext context;
 final String title, caption;
 final int unitIndex, videoNo;
  final String id;
  ProcessSelectVideoEvent(this.context, this.title, this.caption, this.unitIndex, this.videoNo,  this.id);

}

class ResetVideoBlocEvent extends VideoEvent {}
