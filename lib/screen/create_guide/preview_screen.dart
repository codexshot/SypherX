import 'dart:async';
import 'dart:developer';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/model/guide.dart';
import 'package:moonbase_explore/model/quiz_model.dart';
import 'package:moonbase_explore/utils/utility.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';

import '../../widgets/TempoCacheImage.dart';

class PreviewScreen extends StatelessWidget {
  final Guide guide;

  const PreviewScreen({super.key, required this.guide});

  void _previewQuiz(BuildContext context, QuizModel quiz, String pageTitle)async{
      context.read<ExploreBloc>().previewQuiz(quiz, pageTitle);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(guide.trailerVideo.coverImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Platform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              guide.title,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                countText(
                                  guide.units.isEmpty
                                      ? ''
                                      : guide.units.length > 1
                                          ? '${guide.units.length} units'
                                          : '1 unit',
                                ),
                                // countText(' units \u25C9'),
                                //TODO: NOT IMPLEMENTED YET

                                // countText(
                                //     guideDetails.info!.units!.isNotEmpty ? ' ${guideDetails.info!.units!.length}' : '0'),
                                // countText(' quizzes')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 29,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  chipWidget(
                                    () {},
                                    'View',
                                    const Color(0xff3CFF96),
                                  ),
                                  /* chipWidget(
                                    () {},
                                    'AI Tutor',
                                    const Color(0xffDE86FE),
                                  ),
                                  chipWidget(
                                    () {},
                                    'Summary',
                                    const Color(0xffDE86FE),
                                  ),
                                  chipWidget(
                                    () {},
                                    'Notes',
                                    const Color(0xffDE86FE),
                                  ),*/
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                guide.description,
                                maxLines: null,
                                style: GoogleFonts.roboto(
                                  color: const Color(0xffC5CBCC),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Units'
                              '',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: guide.units.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: RowDetail(
                                            guide.units[index].title,
                                            guide.units[index].videos.length,
                                            guide.units[index].unitPicture,
                                            index),
                                      ),
                                      index == guide.units.length - 1 ||
                                              guide.units.isEmpty
                                          ? Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    color:
                                                        const Color(0xff3CFF96),
                                                  ),
                                                  height: 50,
                                                  width: 50,
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Color(0xff20454E),
                                                  ),
                                                ),
                                                countText('New Unit'),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  );
                                },
                              ),
                            ),
                            if(guide.quizzes.isNotEmpty)Text(
                              'Quizzes'
                              '',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if(guide.quizzes.isNotEmpty)const SizedBox(
                              height: 10.0,
                            ),

                            if(guide.quizzes.isNotEmpty)SizedBox(
                              height: 110,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: guide.quizzes.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return MoonbaseFab(
                                    isCircular: true,
                                    label: "Quiz ${index + 1}",
                                    subtitle:
                                    "${guide.quizzes[index].questions.length} question${guide.quizzes[index].questions.length != 1 ? "s" : ""}",
                                    backgroundColor: getColorForString(guide.quizzes[index].quizTitle.replaceAll(" ", "").toLowerCase()),
                                    child: const SizedBox(),
                                    onPressed: ()=>_previewQuiz(context, guide.quizzes[index], "Quiz ${index + 1}"),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget RowDetail(title, videoNo, String coverImagePath, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.file(
                File(coverImagePath),
                fit: BoxFit.fill,
              )),
        ),
        countText('Unit ${index + 1}'),
        miniText('$videoNo videos')
      ],
    );
  }
}

Widget QuizTile(
    title, questionNo, String coverImagePath, int index, bool isAddQuiz) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      !isAddQuiz
          ? SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    coverImagePath,
                    fit: BoxFit.fill,
                  )),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: const Color(0xff3CFF96),
              ),
              height: 50,
              width: 50,
              child: const Icon(
                Icons.add,
                color: Color(0xff20454E),
              ),
            ),
      isAddQuiz ? countText('New Unit') : countText('Quiz ${index + 1}'),
      isAddQuiz ? const SizedBox() : miniText('$questionNo Questions')
    ],
  );
}

Widget countText(text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 12),
  );
}

Widget miniText(text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 9),
  );
}

Widget chipWidget(VoidCallback onPress, text, bgColor) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: SizedBox(
      height: 29,
      child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(5)),
        child: Text(
          text,
          style: const TextStyle(
              color: Color(0xff20454E), fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
