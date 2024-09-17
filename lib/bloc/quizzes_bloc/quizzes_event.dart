part of 'quizzes_bloc.dart';

@immutable
abstract class QuizzesEvent {}

class AddQuizEvent extends QuizzesEvent {
  final QuizModel quiz;
  AddQuizEvent(this.quiz);
}

class UpdateQuizzesEvent extends QuizzesEvent {
  final List<QuizModel> quizzes;
  UpdateQuizzesEvent(this.quizzes);
}

class UpdateQuizEvent extends QuizzesEvent {
  final QuizModel quiz;
  final int index;
  UpdateQuizEvent(this.index,this.quiz);
}

class RemoveQuizEvent extends QuizzesEvent {
  final int quizId;
  RemoveQuizEvent(this.quizId);

}