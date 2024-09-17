import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_collab_upload/moonbase_collab_upload.dart'
    as upload_package;
import 'package:moonbase_explore/bloc/hashtags/hastags_bloc.dart';
import 'package:moonbase_explore/bloc/monetization_bloc/monetization_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/model/explore_data_models.dart';
import 'package:moonbase_explore/model/quiz_model.dart';
import 'package:moonbase_explore/model/user_short_info.dart';
import 'package:tempo_location_service/tempo_location_service.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../app_constants/extensions.dart';
import '../app_constants/module_constants.dart';
import '../export_service.dart';
import '../hive/local_storage_manager.dart';
import '../model/guide.dart';
import '../model/unit_model.dart';
import '../model/video_model.dart';
import '../screen/create_guide/preview_screen.dart';
import '../screen/create_guide/units/unit_builder_screen.dart';
import '../screen/create_guide/units/unit_list_screen.dart';
import '../screen/create_guide/videos/video_builder_screen.dart';
import '../utils/custom_loader.dart';
import '../utils/utility.dart';
import '../widgets/categories_bottom_sheet.dart';
import '../widgets/video_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'draft/draft_bloc.dart';

part 'explore_event.dart';

part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  List<ExploreCategory> exploreCategory = [];

  VideoEditorController? coverVideoController;
  TextEditingController? guideTitleController = TextEditingController();
  TextEditingController? guideDescriptionController = TextEditingController();
  TextEditingController? guideCategoryController = TextEditingController();

  TextEditingController? currentUnitTitleController = TextEditingController();
  TextEditingController? currentUnitQuizController = TextEditingController();
  TextEditingController? currentUnitDescriptionController =
      TextEditingController();

  String? shortInfo;

  Function(String)? onGuidePreview;
  Future<List<QuizModel>?> Function(List<QuizModel> quizzes, List<Unit> units)?
      onQuizPressed;
  Future<QuizModel?> Function(
          QuizModel quiz, List<Unit> units, Function() onDelete)?
      onSingleQuizPressed;
  Function(QuizModel quiz, String pageTitle)? onSingleQuizPreview;
  ValueChanged<double>? onPriceChange;
  StreamController<String>? _quizCreationStream;
  StreamSubscription<String>? _quizSubscription;
  Widget? connectGroup;

  final LocalStorageManager localStorageManager = LocalStorageManager();

  String? localImage;
  bool visitedThisPage = false;
  final hiveKey = 'visited_this_page';

  VoidCallback? onDelete;

  Function(String)? onGuideSaved;

  String? guideIndex;

  //----------------------Bloc Init---------------------------------------------------------------------------------
  ExploreBloc() : super(ExploreState()) {
    on<ExploreEvent>((event, emit) {
      if (event is InitializeCollabByTypeEvent) {
        initializeCollabByTypeEvent(event.collabJson, event.context);
      } else if (event is ResetEvent) {
        emit(ExploreState());
        coverVideoController = null;
        guideTitleController?.clear();
        guideDescriptionController?.clear();
        guideCategoryController?.clear();
        currentUnitTitleController?.clear();
        currentUnitDescriptionController?.clear();
        localImage = '';
      }
    });
  }

  setQuizCreationStream(BuildContext context, StreamController<String> value) {
    _quizCreationStream = value;
    _quizSubscription = _quizCreationStream?.stream.listen((data) {
      debugPrint('Received quiz: $data');
      context.read<QuizzesBloc>().add(AddQuizEvent(QuizModel.fromJson(data)));
    });
  }

  disposeQuizSubscription() {
    _quizSubscription?.cancel();
  }

  UserShortInfo? getshortInfo() {
    final UserShortInfo dummyUserShortInfo = UserShortInfo(
        uid: "test",
        fullName: "Test",
        username: "Test username",
        profileImageUrl: "");
    return UserShortInfo.fromJson(shortInfo ?? dummyUserShortInfo.toJson());
  }

  setshortInfo(String? value) {
    shortInfo = value;
  }

  findCategory(name) {
    return exploreCategory.firstWhere((element) => element.name == name);
  }

  setExploreCategories(List<ExploreCategory> list) {
    if (exploreCategory.length != list.length) {
      exploreCategory.addAll(list);
    }
  }

  //-------------------------------set dummy categories--------------------------------------------------------

  setDummyCategories() {
    ExploreCategory dummyEntry = ExploreCategory(
        id: '1',
        name: 'Fitness',
        description: 'Fitness',
        createdAt: DateTime.now().toIso8601String(),
        updatedOn: DateTime.now().toIso8601String());
    List<ExploreCategory> list = [
      dummyEntry,
      dummyEntry,
      dummyEntry,
      dummyEntry,
      dummyEntry,
      dummyEntry,
      dummyEntry,
      dummyEntry
    ];
    exploreCategory.addAll(list);
  }

  //---------------------------Choose Guide trailer video ----------------------------------------------------------------------------

  chooseGuideVideo(ImagePicker picker, BuildContext context) async {
    try {
      showLoader(context);
      if (coverVideoController != null) {
        coverVideoController!.dispose();
      }
      await picker
          .pickVideo(
              source: ImageSource.gallery,
              maxDuration: const Duration(seconds: 10))
          .then((value) async {
        hideLoader(context);
        await playVideo(value!, context);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Video Picker  error $e");
      }
    }
  }

  //------------------------------Choose unit thumbnail----------------------------------------------------------------------------

  Future<String> chooseUnitThumbnail(
      ImagePicker picker, BuildContext context) async {
    try {
      String imagePath = '';
      showLoader(context);
      await picker.pickImage(source: ImageSource.gallery).then((value) async {
        hideLoader(context);
        imagePath = value!.path;
      });
      return imagePath;
    } catch (e) {
      if (kDebugMode) {
        print("Image Picker  error $e");
      }
      return '';
    }
  }

  //---------------------------Play Video----------------------------------------------------------------------------------

  playVideo(XFile file, BuildContext context) async {
    await initController(file, context).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPicker(
            controller: (value) async {
              coverVideoController = value;

              final config = VideoFFmpegVideoEditorConfig(coverVideoController!,
                  format: VideoExportFormat.mp4);
              final FFmpegVideoEditorExecute execute =
                  await config.getExecuteConfig();
              await ExportService.runFFmpegCommand(
                execute,
                onProgress: (stats) {
                  log(config
                      .getFFmpegProgress(stats.getTime().toInt())
                      .toString());
                },
                onError: (e, s) => log("Error on export video :($e)"),
                onCompleted: (file) {
                  initCompressVideoController(
                      XFile(execute.outputPath), context);
                  ExportService.dispose();
                },
              );
              /*     initCompressVideoController(
                  XFile(file.path), context);*/
            },
          ),
        ),
      );
    });
  }

  Future<String?> compressVideo(String path, BuildContext context) async {
    showCompressLoader(context);
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: true, // It's false by default
    );

    hideLoader(context);
    return mediaInfo!.file?.path;
  }

  //============Init CompressVideo============================

  Future<void> initCompressVideoController(
      XFile file, BuildContext context) async {
    if (file.path.contains('file:///') || file.path.contains('file://')) {
      file = XFile(file.path.replaceAll('file:///', ''));
    }
    String? path = file.path;
    if (coverVideoController != null) {
      coverVideoController!.dispose();
    }

    coverVideoController = VideoEditorController.file(
      File(path),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: MaxVideoTime),
    );
    coverVideoController!
        .initialize(aspectRatio: 9 / 16)
        .then((value) {})
        .catchError((error) {
      if (kDebugMode) {
        print("coverVideoController error $error");
      }
    });
  }

  //-----------------------------Init Video Controller ------------------------------------------------------------------

  Future<VideoEditorController?> initController(
      XFile file, BuildContext context) async {
    if (file.path.contains('file:///') || file.path.contains('file://')) {
      file = XFile(file.path.replaceAll('file:///', ''));
    }
    String? path = file.path;

    int sizeInBytes = await file.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 30) {
      await VideoCompress.deleteAllCache();
      path = await compressVideo(path, context);
    }

    path = await saveVideoToApplicationDirectory(path!);
    await VideoCompress.deleteAllCache();
    if (coverVideoController != null) {
      coverVideoController!.dispose();
    }
    coverVideoController = VideoEditorController.file(
      File(path!),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: MaxVideoTime),
    );
    coverVideoController!
        .initialize(aspectRatio: 9 / 16)
        .then((value) {})
        .catchError((error) {
      if (kDebugMode) {
        print("coverVideoController error $error");
      }
    });
    return coverVideoController;
  }

//--------------------------------Dispose Video Controller-------------------------------------------------------------
  disposeVideoController() {
    coverVideoController!.dispose();
  }

  //------------------------Add Video to Unit---------------------------------------------------------------------------

  addVideoToUnit(Video video, int unitNumber) {
    int unitIndex = unitNumber;

    Unit unit = Unit(
      id: generateId(),
      unitNumber: unitIndex,
      title: currentUnitTitleController!.text,
      description: currentUnitDescriptionController!.text,
      videos: [],
      unitPicture: '',
    );

    emit(state.copyWith(
      units: state.units
        ?..add(
          unit,
        ),
    ));
  }

  //---------------------------------Trim and Edit Video------------------------------------------------------------------------
  Future<void> processVideo(
      VideoEditorController controller, BuildContext context) async {
    showLoader(context);

    // await controller.generateDefaultCoverThumbnail();
    // final coverData = controller.selectedCoverNotifier.value;
    File imageFile = File(controller.video.dataSource);
    final uint8list = await VideoThumbnail.thumbnailData(
      video: controller.file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    await Unit8ListToFile.bytesToImage(uint8list!).then((thumbnail) {
      emitGuideDetailState(thumbnail, imageFile);
      hideLoader(context);
      Navigator.pop(context);
    }).catchError((error) {
      hideLoader(context);
      if (kDebugMode) {
        print("coverData error $error");
      }
    });
  }

  //=================================Emit guide State===================================================================
  emitGuideDetailState(guideCover, video) {
    emit(state.copyWith(
      exploreThumbnail: guideCover,
      exploreTrailerVideo: File("empty string"),
    ));
  }

  //=========================================================================================================

  void saveGuideDetails(BuildContext context) {
    emit(state.copyWith(
      exploreTitle: guideTitleController!.text,
      exploreDescription: guideDescriptionController!.text,
    ));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnitListScreen()),
    );
  }

  //================================================================================================
  void onReorderVideoForAUnit(int oldIndex, int newIndex,
      {required int unitIndex}) {
    final List<Unit> list = [];
    list.addAll(state.units!);
    List<Video> videosForAUnit =
        list.firstWhere((element) => element.unitNumber == unitIndex).videos;

    final draggedVideo =
        (videosForAUnit[oldIndex]).copyWith(videoNumber: newIndex + 1);
    videosForAUnit.removeAt(oldIndex);

    for (int index = 0; index < videosForAUnit.length; index++) {
      final displacedElement = (videosForAUnit[index]).copyWith(
        videoNumber: index + 1,
      );
      videosForAUnit[index] = displacedElement;
    }

    videosForAUnit.insert(newIndex, draggedVideo);
    if (oldIndex < newIndex) {
      for (int index = oldIndex; index < newIndex; index++) {
        final displacedElement = (videosForAUnit[index]).copyWith(
          videoNumber: index + 1,
        );
        videosForAUnit[index] = displacedElement;
      }
    } else {
      for (int index = newIndex + 1; index <= oldIndex; index++) {
        final displacedElement = (videosForAUnit[index]).copyWith(
          videoNumber: index + 1,
        );
        videosForAUnit[index] = displacedElement;
      }
    }

    list.firstWhere((element) => element.unitNumber == unitIndex).videos
      ..clear()
      ..addAll(videosForAUnit);
    emit(state.copyWith(units: list));
  }

//================================================================================================
  generateId() {
    var uuid = const Uuid();
    final id = uuid.v1();
    return id;
  }

//================================================================================================
  void emitUnitState(Video unitVideo, int unitIndex) {
    final List<Unit> list = [];
    list.addAll(state.units!);
    String videoId = unitVideo.id;

    bool isDuplicate = false;

    for (var element in list) {
      for (var element in element.videos) {
        if (element.id == videoId) {
          isDuplicate = true;
        }
      }
    }

    try {
      list
          .firstWhere((element) => element.unitNumber == unitIndex)
          .videos
          .add(unitVideo);

      if (isDuplicate) {
        list
            .firstWhere((element) => element.unitNumber == unitIndex)
            .videos
            .removeWhere((element) => element.id == videoId);
        list
            .firstWhere((element) => element.unitNumber == unitIndex)
            .videos
            .insert(unitVideo.videoNumber - 1, unitVideo);
      }
    } catch (e) {
      List<Video> unitVideos = [unitVideo];

      Unit unit = Unit(
        id: generateId(),
        unitNumber: unitIndex,
        title: currentUnitTitleController!.text,
        description: currentUnitDescriptionController!.text,
        videos: unitVideos,
        unitPicture: '',
      );

      list.add(unit);
    }
    emit(
      state.copyWith(currentVideo: unitVideo, units: list),
    );
  }

  //==============Save unit title and description ===================================

  saveTitleAndDescriptionUnit(title, description, int unitIndex, unitPicture) {
    final List<Unit> list = [];
    list.addAll(state.units!);
    Unit fetchedUnit =
        list.firstWhere((element) => element.unitNumber == unitIndex);
    int insertIndex = list.indexOf(fetchedUnit);
    list.remove(fetchedUnit);
    Unit tempUnit = fetchedUnit.copyWith(
        title: title, description: description, unitPicture: unitPicture);
    list.insert(insertIndex, tempUnit);
    emit(
      state.copyWith(units: list),
    );
  }

//================================================================================================
  void saveUnitDetails(BuildContext context) {
    currentUnitDescriptionController?.clear();
    currentUnitTitleController?.clear();
    Navigator.pop(context);
  }

//================================================================================================
  void removeVideoAtIndex(int key, BuildContext context,
      {required int unitIndex}) {
    final List<Unit> list = [];
    list.addAll(state.units!);
    list
        .firstWhere((element) => element.unitNumber == unitIndex)
        .videos
        .removeAt(key);
    final List<Unit> tempList = [];
    final videosForAUnit =
        list.firstWhere((element) => element.unitNumber == unitIndex).videos;
    List<Video> tempVideos = [];
    for (var element in videosForAUnit) {
      final Video displacedElement = element.copyWith(
        videoNumber: videosForAUnit.indexOf(element) + 1,
      );
      tempVideos.add(displacedElement);
    }

    for (int index = 0; index < list.length; index++) {
      final displacedElement = list
          .firstWhere((element) => element.unitNumber == unitIndex)
          .copyWith(
            videos: list
                .firstWhere((element) => element.unitNumber == unitIndex)
                .videos
              ..clear()
              ..addAll(tempVideos),
          );
      tempList.add(displacedElement);
    }
    emit(
      state.copyWith(units: tempList),
    );
  }

//================================================================================================
  String randomId() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

//================================================================================================
  void navigateToVideoBuilderScreen(
      {required BuildContext context,
      required int unitIndex,
      Video? videosData,
      required int videoNumber}) {
    videosData ??= Video(
        id: '',
        title: '',
        caption: '',
        videoNumber: videoNumber,
        unitNumber: unitIndex,
        videoDetails: VideoDetails(videoPath: '', coverImagePath: ''),
        likesCount: 0,
        totalCommentsCount: 0);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoBuilderScreen(video: videosData)),
    );
  }

//================================================================================================
  showCategoryPicker(BuildContext context) {
    showCategoryBottomSheet(context, exploreCategory);
  }

//================================================================================================
  setCategory(ExploreCategory category, BuildContext context) {
    guideCategoryController?.text = category.name;
    Navigator.pop(context);
  }

//================================================================================================
  void addUnit(BuildContext context) {
    int i = state.units!.length + 1;
    Unit obj = Unit(
        id: generateId(),
        unitNumber: i,
        title: '',
        description: '',
        videos: [],
        unitPicture: '');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UnitBuilderScreen(unit: obj)),
    );
  }

  //=====================================================================
  void removeUnit(BuildContext context, int index) {
    try {
      state.units!.removeAt(index);
      emit(state.copyWith(units: state.units));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Navigator.pop(context);
  }

  //================================================================================================
  Future<List<QuizModel>?> updateQuizzes(List<QuizModel> quizzes) async {
    if (onQuizPressed == null) {
      return null;
    } else {
      return onQuizPressed!(quizzes, state.units ?? <Unit>[]);
    }
  }

  Future<QuizModel?> updateQuiz(QuizModel quiz, Function() onDelete) async {
    if (onSingleQuizPressed == null) {
      return null;
    } else {
      return onSingleQuizPressed!(quiz, state.units ?? <Unit>[], onDelete);
    }
  }

  Future<QuizModel?> previewQuiz(QuizModel quiz, String pageTitle) async {
    if (onSingleQuizPressed == null) {
      return null;
    } else {
      return onSingleQuizPreview!(quiz, pageTitle);
    }
  }

//================================================================================================
  Future<String?> reloadThumbnail() async {
    String? imagePath;
    try {
      if (localImage != null && localImage!.isNotEmpty) {
        imagePath = localImage;

      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return imagePath;
    /*  try {
      if (imagePath == null || imagePath.isEmpty) {
        coverVideoController?.generateDefaultCoverThumbnail();
        File file = await Unit8ListToFile.bytesToImage(
            coverVideoController!.selectedCoverVal!.thumbData!);
        imagePath = file.path;
      }
      return imagePath;
    } catch (e) {
      imagePath = state.exploreThumbnail?.path;
      return imagePath;
    }*/
  }

  //================================================================================================
  void setGuideLocation(PlaceModel location) {
    emit(state.copyWith(exploreLocation: location));
  }

  //================================================================================================
  void initializeCollabByTypeEvent(String collab, BuildContext context) {
    Guide parsedCollab = Guide.fromMap(jsonDecode(collab));
    File thumbnail = File(parsedCollab.trailerVideo.coverImagePath);
    File trailerVideo = File(parsedCollab.trailerVideo.videoPath);

    emit(state.copyWith(
        exploreTitle: parsedCollab.title,
        exploreDescription: parsedCollab.description,
        exploreThumbnail: thumbnail,
        exploreTrailerVideo: trailerVideo,
        exploreLocation: parsedCollab.location,
        exploreCategory: parsedCollab.category,
        units: parsedCollab.units));
    guideCategoryController?.text = parsedCollab.category?.name ?? '';
    guideTitleController?.text = parsedCollab.title;
    guideDescriptionController?.text = parsedCollab.description;
    initController(XFile(parsedCollab.trailerVideo.videoPath), context);
    if (parsedCollab.price!.originalPrice != 0) {
      context
          .read<MonetizationBloc>()
          .add(AddPriceEvent(price: parsedCollab.price!.originalPrice));
    }
    context
        .read<HastagsBloc>()
        .add(AddHashTagsToListEvent(hashTags: parsedCollab.tags));
  }

  Future<void> pickThumbnail(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      localImage = image.path;
      coverVideoController?.generateDefaultCoverThumbnail(
          file: File(image.path));
    }
  }

  Future<void> initializingStorageBoxes() async {
    await Hive.initFlutter();
    await LocalStorageManager().openInAppTutorialsBox();
  }

  Future<void> onPreviewTapped(BuildContext context) async {
    await context.read<DraftBloc>().getDraft(context).then((guide) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(guide: guide)),
      );
    });
  }

  void setDraft(Map<String, dynamic> editableJson, BuildContext context) {
    upload_package.UGuide guide = upload_package.UGuide.fromMap(editableJson);
    guideTitleController?.text = guide.guideName;
    guideDescriptionController?.text = guide.description;

    final List<QuizModel> quizzes = [];
    for (upload_package.UQuiz quiz in guide.quizzes) {
      List<QuestionModel> questions = [];

      for (upload_package.UQuestion question in quiz.questions) {
        final QuestionModel questionModel =
            QuestionModel.fromMap(question.toMap());
        questions.add(questionModel);
      }

      QuizModel quizModel = QuizModel(
          quizId: quiz.id,
          quizDescription: quiz.quizDescription,
          quizTitle: quiz.quizTitle,
          groupName: quiz.groupName,
          courseName: quiz.courseName,
          status: QuizStatus.notStarted,
          quizType: QuizType.manual ,
          selectedUnits: quiz.selectedUnits,
          questions: questions);
      quizzes.add(quizModel);
    }
    List<Unit> units = [];
    for (var element in guide.units) {
      final Unit unit = Unit.fromMap(element.toMap());
      units.add(unit);
    }

    context.read<QuizzesBloc>().add(UpdateQuizzesEvent(quizzes));
    localImage=guide.trailerVideo.localCoverImagePath;
    emit(state.copyWith(
        exploreThumbnail: File(guide.trailerVideo.localCoverImagePath),
        exploreId: guide.id,
        units: units));
  }
}
