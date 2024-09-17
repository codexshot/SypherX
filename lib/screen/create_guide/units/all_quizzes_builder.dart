import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/model/quiz_model.dart';

import 'package:moonbase_explore/screen/create_guide/units/unit_container.dart';
import 'package:moonbase_explore/utils/utility.dart';

import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../bloc/explore_bloc.dart';
import '../../../model/unit_model.dart';

class AllQuizzesBuilder extends StatelessWidget {
  const AllQuizzesBuilder({super.key, required this.allQuizzes, this.gridPadding});

  final List<QuizModel> allQuizzes;
  final EdgeInsets? gridPadding;

  void _onAddQuiz(BuildContext context)async {
    final modifiedQuizzes = await context.read<ExploreBloc>().updateQuizzes(allQuizzes);
    if(modifiedQuizzes !=null && context.mounted){
      context.read<QuizzesBloc>().add(UpdateQuizzesEvent(modifiedQuizzes));
    }
  }

  void _onUpdateQuiz(BuildContext context, int index)async {
    final modifiedQuiz = await context.read<ExploreBloc>().updateQuiz(allQuizzes[index], (){
      context.read<QuizzesBloc>().add(RemoveQuizEvent(index));
    });
    if(modifiedQuiz !=null && context.mounted){
      context.read<QuizzesBloc>().add(UpdateQuizEvent(index, modifiedQuiz));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: gridPadding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: List.generate(allQuizzes.length+1, (index){
          if (index == allQuizzes.length) {
            return InkWell(
              onTap: () => _onAddQuiz(context),
              child: Column(
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      child: const Icon(Icons.add)),
                  const SizedBox(height: 5,),
                  const Text(
                    "New Quiz",
                    style: textFieldW600Size12Poppins,
                  ),
                ],
              ),
            );
          } else {
            final quiz = allQuizzes[index];
            return InkWell(
              onTap: () => _onUpdateQuiz(context, index),
              child: Column(
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: getColorForString(quiz.quizTitle.toLowerCase().replaceAll(" ", ""))),
                      ),
                  const SizedBox(height: 5,),
                  Text(
                    "Quiz ${index+1}",
                    style: textFieldW600Size12Poppins,
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "${quiz.questions.length} question${quiz.questions.length == 1 ?"":"s"}",
                    style: textFieldW600Size12Poppins,
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
