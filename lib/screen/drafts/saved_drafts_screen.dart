import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';

import '../../app_constants/app_colors.dart';
import '../../bloc/explore_bloc.dart';
import '../../model/guide.dart';
import '../../model/collab_model.dart';
import '../../utils/common_no_data_widget.dart';
import '../../utils/utility.dart';
import '../../widgets/common_video_with_content_widget.dart';

class SavedDraftsScreen extends StatefulWidget {
  const SavedDraftsScreen({
    super.key,
  });

  @override
  State<SavedDraftsScreen> createState() => _SavedDraftsScreenState();
}

class _SavedDraftsScreenState extends State<SavedDraftsScreen> {
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DraftBloc>().getAllDrafts(context);
    });


    super.initState();
  }

  Future<void> _onDelete(Guide collab) async {
    await showAlertDailog(context, 'Do you want to discard ${collab.title}?',
        successOption: 'Yes',
        cancelOption: 'No',
        onSuccess: () async {
          await context.read<DraftBloc>().deleteDraft(collab.id, context);
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop());
  }

  Future<void> _onEdit(Guide collab, BuildContext context) async {
    context.read<DraftBloc>().navigateToScreen(context, collab);
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
        pageTitle: 'Drafts',
        child: BlocBuilder<DraftBloc, DraftState>(builder: (context, state) {
          return state.guides.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  itemCount: state.guides.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        key: ValueKey(state.guides[index].id),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TempoVideoWithContentWidget.buildWithLocalImagePath(
                              title: state.guides[index].title,
                              content: state.guides[index].description,
                              localCoverImagePath: state.guides[index].trailerVideo.coverImagePath,
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _onEdit(state.guides[index], context);
                                },
                                icon: const Icon(Icons.edit, color: purpleColor, size: 20),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _onDelete(state.guides[index]);
                                },
                                icon: const Icon(Icons.delete, color: buttonRedColor, size: 20),
                              ),
                            ],
                          )
                        ],
                      ),
                      index + 1 < state.guides.length ? const Divider() : const SizedBox(),
                    ],
                  ),
                )
              : const Center(
                  child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TempoNoDataWidget(text: 'No drafts!'),
                ));
        }));
  }
}
