import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/model/quiz_model.dart';

part 'quizzes_event.dart';

part 'quizzes_state.dart';

class QuizzesBloc extends Bloc<QuizzesEvent, QuizzesState> {
  QuizzesBloc() : super(const QuizzesState(quizzes: [])) {
    on<QuizzesEvent>((event, emit) {
      if (event is AddQuizEvent) {
        List<QuizModel> newList = [...(state.quizzes ?? []), event.quiz];
        emit(state.copyWith(quizzes: newList));
      } else if (event is RemoveQuizEvent) {
        List<QuizModel> newList = [...(state.quizzes ?? [])];
          newList.removeAt(event.quizId);
          emit(state.copyWith(quizzes: newList));
      } else if (event is UpdateQuizzesEvent) {
        List<QuizModel> newList = event.quizzes;
        emit(state.copyWith(quizzes: newList));
      } else if (event is UpdateQuizEvent) {
        List<QuizModel> newList = state.quizzes ?? [];
        newList[event.index] = event.quiz;
        emit(state.copyWith(quizzes: newList));
      }
    });
  }

  List<QuizModel> get allQuizzes => state.quizzes ?? <QuizModel>[];
}
