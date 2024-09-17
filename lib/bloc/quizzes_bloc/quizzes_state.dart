part of 'quizzes_bloc.dart';

class QuizzesState extends Equatable {
  final List<QuizModel>? quizzes;

  @override
  List<Object?> get props => [quizzes];

  const QuizzesState({
    this.quizzes
  });

  QuizzesState copyWith({
    List<QuizModel>? quizzes
  }) {
    return QuizzesState(
      quizzes: quizzes ?? this.quizzes
    );
  }
}
