import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/bloc/monetization_bloc/monetization_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/model/guide.dart';

import 'package:moonbase_explore/model/collab_type.dart';
import 'package:moonbase_explore/model/price_model.dart';
import 'package:moonbase_explore/model/quiz_model.dart';
import 'package:moonbase_explore/model/user_short_info.dart';
import 'package:moonbase_explore/model/video_model.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/screen/drafts/saved_drafts_screen.dart';

import '../../app_constants/custom_snackbars.dart';
import '../../hive/local_storage_manager.dart';
import '../../model/unit_model.dart';
import '../hashtags/hastags_bloc.dart';

part 'draft_event.dart';

part 'draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  final LocalStorageManager _localStorageManager = LocalStorageManager();

  DraftBloc() : super(const DraftState([])) {
    on<DraftEvent>((event, emit) {
      if (event is SaveDraftEvent) {
        saveDraft(event.context);
      } else if (event is GetAllSavedDraftEvent) {
        getAllDrafts(event.context);
      }
    });
  }

  saveDraft(BuildContext context) async {
    final guide = await getDraft(context);

    await _localStorageManager.insertDraft(guide.id, guide).then((value) {
      successTopSnackBar(context, 'Saved this guide as draft');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SavedDraftsScreen()),
      );
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const SavedDraftsScreen()), ModalRoute.withName("/"));
    }, onError: (e) {
      errorTopSnackBar(context, "Something went wrong!!!");
    });
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

  //==========Get Drafts================

  Future<Guide> getDraft(BuildContext context) async {
    final exploreBloc = context.read<ExploreBloc>();
    List<Unit>? units = exploreBloc.state.units;
    final title = exploreBloc.guideTitleController!.text;
    final description = exploreBloc.guideDescriptionController!.text;
    const collabType = CollabType.guide;
    UserShortInfo? shortInfo = context.read<ExploreBloc>().getshortInfo();

    String coverImagePath = '';

    if (exploreBloc.localImage != null && exploreBloc.localImage!.isNotEmpty) {
      coverImagePath = removeFileString(exploreBloc.localImage!);
    } else {
      coverImagePath = removeFileString(exploreBloc.state.exploreThumbnail!.path);
    }

    final trailerVideo = VideoDetails(
      videoPath: "",//removeFileString(exploreBloc.state.exploreTrailerVideo!.path),
      coverImagePath: coverImagePath,
    );
    List<QuizModel> quizzes = context.read<QuizzesBloc>().state.quizzes??[];

    Guide collab = Guide(
        id: exploreBloc.state.exploreId??exploreBloc.generateId(),
        collabType: collabType,
        buyers: [],
        title: title,
        description: description,
        trailerVideo: trailerVideo,
        creatorInfo: shortInfo!,
        location: exploreBloc.state.exploreLocation,
        units: units!,
        quizzes: quizzes,
    );
    return collab;
  }

  deleteDraft(String key, BuildContext context) async {
    await _localStorageManager.deleteDraft(key).then((value) => add(GetAllSavedDraftEvent(context)), onError: (e) {
      errorTopSnackBar(context, "Something went wrong!!!");
    });
  }

  getAllDrafts(BuildContext context) async {
    final drafts = await _localStorageManager.getAllDrafts();
    emit(DraftState(drafts!));
  }

  navigateToScreen(BuildContext context, Guide draft) {
    context.read<ExploreBloc>().add(InitializeCollabByTypeEvent(draft.toJson(), context));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateGuideScreen(
          isEditable: true,
        ),
      ),
    );
  }
}
