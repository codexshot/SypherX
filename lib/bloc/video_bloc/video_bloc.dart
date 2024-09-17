import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../app_constants/extensions.dart';
import '../../app_constants/module_constants.dart';
import '../../export_service.dart';
import '../../model/video_model.dart';
import '../../screen/create_guide/units/unit_video_picker.dart';
import '../../utils/custom_loader.dart';
import '../../utils/utility.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoEditorController? videoEditorController;
  Video? video;

  ImagePicker picker = ImagePicker();

  VideoBloc() : super(const VideoState(imagePath: '')) {
    on<VideoEvent>((event, emit) {
      if (event is OpenImagePickerEvent) {
        chooseUnitVideo(picker, event.context);
      } else if (event is ProcessSelectVideoEvent) {
        setVideoResult(event.context, event.title, event.caption, event.unitIndex, event.videoNo, event.id);
      } else if (event is ResetVideoBlocEvent) {
        emit(const VideoState());
        videoEditorController = null;
      }
    });
  }

  //==============Choose unit video==================================================================================================

  chooseUnitVideo(ImagePicker picker, BuildContext context) async {
    try {
      showCompressLoader(context);
      await picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60)).then((value) async {

        hideLoader(context);
        await processSelectedVideo(value!, context);

      });
    } catch (e) {
      if (kDebugMode) {
        print("Video Picker  error $e");
      }
    }
  }
  //------------------------Play unit video--------------------------------------------------------------------------------

  processSelectedVideo(XFile file, BuildContext context) async {


    await initUnitController(file, context).then((value) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UnitVideoPicker()),
      );
      videoEditorController = result;
      final String imagePath = await processVideoPath(context);
      emit(state.copyWith(videoPath: removeFileString(videoEditorController!.file.path), imagePath: imagePath));
      videoEditorController!.dispose();
     /* final config = VideoFFmpegVideoEditorConfig(videoEditorController!, format: VideoExportFormat.mp4);
      showLoader(context);
      final FFmpegVideoEditorExecute execute = await config.getExecuteConfig();

      await ExportService.runFFmpegCommand(
        execute,
        onProgress: (stats) {
          log(config.getFFmpegProgress(stats.getTime().toInt()).toString());
        },
        onError: (e, s) => log("Error on export video :($e)"),
        onCompleted: (file) async {
          hideLoader(context);
          await initCompressedVideoController(XFile(execute.outputPath), context);
          final String imagePath = await processVideoPath(context);
          emit(state.copyWith(videoPath: removeFileString(execute.outputPath), imagePath: imagePath));
          ExportService.dispose();
        },
      );*/
    });
  }

  Future<String?> compressVideo(String path, BuildContext context) async {
    // showCompressLoader(context);
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    // hideLoader(context);
    return mediaInfo!.file?.path;
  }

Future<VideoEditorController?> initCompressedVideoController(XFile file, BuildContext context) async {
    if (file.path.contains('file:///') || file.path.contains('file://')) {
      file = XFile(file.path.replaceAll('file:///', ''));
    }
    try {
      if (videoEditorController != null) {
        videoEditorController!.dispose();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    videoEditorController = VideoEditorController.file(
      File(file.path),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: MaxVideoTime),
    );
    videoEditorController!.initialize(aspectRatio: 9 / 16).then((value) {}).catchError((error) {
      if (kDebugMode) {
        print("coverVideoController error $error");
      }
    });
    return videoEditorController;
  }
  //-----------------------------Init Video Controller ------------------------------------------------------------------

  Future<VideoEditorController?> initUnitController(XFile file, BuildContext context) async {
    if (file.path.contains('file:///') || file.path.contains('file://')) {
      file = XFile(file.path.replaceAll('file:///', ''));
    }
    try {
      if (videoEditorController != null) {
        videoEditorController!.dispose();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    String? path = file.path;

   /* int sizeInBytes = await file.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 30) {
      await VideoCompress.deleteAllCache();
      path = await compressVideo(path, context);
    }
*/
    path = await saveVideoToApplicationDirectory(path);
    await VideoCompress.deleteAllCache();
    if (videoEditorController != null) {
      videoEditorController!.dispose();
    }
    videoEditorController = VideoEditorController.file(
      File(path!),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: MaxVideoTime),
    );
    videoEditorController!.initialize(aspectRatio: 9 / 16).then((value) {}).catchError((error) {
      if (kDebugMode) {
        print("coverVideoController error $error");
      }
    });

    return videoEditorController;
  }

  Future<String> processVideoPath(BuildContext context) async {
    String? imagePath = '';

    // showLoader(context);
    /* if (video != null) {
      imagePath = video?.videoDetails.coverImagePath??video!.videoDetails.localPath;
    }*/
    if (videoEditorController != null) {
      try {
        final uint8list = await VideoThumbnail.thumbnailData(
          video: videoEditorController!.file.path,
          imageFormat: ImageFormat.JPEG,
          quality:100,
        );
        // await videoEditorController!.generateDefaultCoverThumbnail();
        await Unit8ListToFile.bytesToImage(uint8list!).then((value) {
          imagePath = value.path;
        }, onError: (e) {
          // hideLoader(context);
          errorTopSnackBar(context, "Something went wrong!!!");
        });

      } catch (e) {
        // hideLoader(context);
        if (kDebugMode) {
          print(e);
        }
      }
    }
    // hideLoader(context);
    return imagePath ?? '';
  }

  String removeFileString(String file) {
    if (file.contains('file:///') || file.contains('file://')) {
      if (Platform.isAndroid) {
        file = file.replaceAll('file:///', '');
      } else {
        file = file.replaceAll('file:///private', '');
      }
    }
    return file;
  }

  Future<void> setVideoResult(
      BuildContext context, String title, String caption, int unitIndex, int videoNo, String videoId) async {
    showLoader(context);
    // final String data = await processVideoPath(context);
    if (state.imagePath!.trim().isNotEmpty) {
      var uuid = const Uuid();
      // if (videoId.trim().isEmpty) {
      //   videoId = uuid.v1();
      // }
      Video tempVideo = Video(
          id: videoId.trim().isEmpty ? uuid.v1() : videoId,
          title: title,
          caption: caption,
          videoNumber: videoId.trim().isEmpty ? videoNo + 1 : videoNo,
          unitNumber: unitIndex,
          videoDetails: VideoDetails(
              localPath: removeFileString(state.videoPath!), coverImagePath: state.imagePath!, videoPath: ''),
          likesCount: 0,
          totalCommentsCount: 0);

      context.read<ExploreBloc>().emitUnitState(tempVideo, unitIndex);
      add(ResetVideoBlocEvent());
      Navigator.pop(context);
      hideLoader(context);
    } else {}
  }
}
