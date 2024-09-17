import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/model/quiz_model.dart';

import 'model/unit_model.dart';
//
// void main() {
//   // runApp(TempoExplore());
// }

class TempoExplore extends StatelessWidget {
  final Widget child;
  final Function(String)? onGuidedPreview;
  final Function(String)? onGuideSaved ;

  final Function(QuizModel, String pageTitle)? onSingleQuizPreview;
  final Future<List<QuizModel>?> Function(List<QuizModel> quizzes, List<Unit> units) onQuizPressed;
  final Future<QuizModel?> Function(QuizModel quizzes, List<Unit> units, Function() onDelete) onSingleQuizPressed;
  final StreamController<String>? quizCreationStream;
  final VoidCallback onDelete;

  const TempoExplore({
    super.key,
    required this.child,
    required this.onGuidedPreview,
    required this.onQuizPressed,
    required this.onSingleQuizPressed,
    required this.onSingleQuizPreview,
    required this.onGuideSaved,
    required this.onDelete,
    this.quizCreationStream,

  });

  @override
  Widget build(BuildContext context) {
    context.read<ExploreBloc>().onGuidePreview = onGuidedPreview;
    context.read<ExploreBloc>().onGuideSaved = onGuideSaved;
    context.read<ExploreBloc>().onQuizPressed = onQuizPressed;
    context.read<ExploreBloc>().onDelete = onDelete;
    context.read<ExploreBloc>().onSingleQuizPressed = onSingleQuizPressed;
    context.read<ExploreBloc>().onSingleQuizPreview = onSingleQuizPreview;
    if (quizCreationStream != null) {
      context.read<ExploreBloc>().setQuizCreationStream(context, quizCreationStream!);
    }

    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}
