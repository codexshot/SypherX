import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:provider/provider.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/screen/collab-publishing/widget/collab_price_widget.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import '../../app_constants/app_colors.dart';
import '../../model/guide.dart';
import '../../model/collab_type.dart';
import '../../utils/utility.dart';
import '../../widgets/common_text.dart';
import '../../widgets/tempo_text_button.dart';
import 'hash_tags_widget.dart';

class CollabPublishingScreen extends StatelessWidget {
  const CollabPublishingScreen({Key? key, required this.collabType})
      : super(key: key);
  final CollabType collabType;

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
        pageTitle: 'Publish ${collabType.asString()}',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TText('You guide is Ready', variant: TypographyVariant.h1),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<DraftBloc, DraftState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      TempoTextButton(
                        text: 'Save as draft',
                        enabledBackgroundColor: secondaryColor,
                        onPressed: () async {
                          context
                              .read<DraftBloc>()
                              .add(SaveDraftEvent(context));
                        },
                      ),
                      const SizedBox(height: 5),
                      TempoTextButton(
                        text: 'Publish',
                        onPressed: () async {
                          final quizzes =
                              context.read<QuizzesBloc>().allQuizzes;
                          final Guide guides =
                              (await context.read<DraftBloc>().getDraft(context)).copyWith(units: []) as Guide;
                          //Attatching quizzes
                          if (context.mounted) {
                            context
                                .read<ExploreBloc>()
                                .onGuidePreview!(guides.toJson());
                          }

                          // context.read<ExploreBloc>().onGuidePreview!(guide);

                          // context.read<DraftBloc>().add(GetAllSavedDraftEvent(context));
                          // final collabState =
                          // Provider.of<ExploreState>(context, listen: false);
                          // try {
                          //   await collabState.saveGuideAsDraft().then((value) {
                          //     collabState.setViewCollab = value;
                          //     collabState.isPreview = true;
                          //     getIt<NavigationHelpers>()
                          //         .push(context, const ViewCollab());
                          //   });
                          // } catch (e) {
                          //   errorTopSnackBar(context, '$e');
                          // }
                        },
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ));
  }
}
