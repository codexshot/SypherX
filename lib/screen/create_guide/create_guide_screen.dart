// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import '../../app_constants/custom_snackbars.dart';
import '../../app_constants/size_constants.dart';
import '../../model/guide.dart';
import '../../widgets/tempo_text_button.dart';
import 'create_guide_form.dart';

class CreateGuideScreen extends StatefulWidget {
  final bool isEditable;
  final Map<String, dynamic>? editableJson;
  final String? index;

  const CreateGuideScreen(
      {super.key, this.isEditable = false, this.editableJson, this.index});

  @override
  State<CreateGuideScreen> createState() => _CreateGuideScreenState();
}

class _CreateGuideScreenState extends State<CreateGuideScreen> {
  final videoSelectorKey = DateTime
      .now()
      .toUtc()
      .timeZoneOffset;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    if (!widget.isEditable) {
      final blocInstance = context.read<ExploreBloc>();
      blocInstance.guideIndex = '';
      blocInstance.add(ResetEvent());
    } else {
      if (widget.editableJson != null) {
        final blocInstance = context.read<ExploreBloc>();
        blocInstance.setDraft(widget.editableJson!, context);
        try {
          blocInstance.guideIndex = widget.index!;
        } catch (e) {

        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        final blocInstance = context.read<ExploreBloc>();
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            warningTopSnackBar(context, 'Do you want to discard this guide?',
                discard: () {
                  // Navigator.pop(context);
                  context.read<ExploreBloc>().onDelete!();
                  context.read<ExploreBloc>().add(ResetEvent());
                });
          },
          child: BgTempoScreen(
              pageTitle: 'Create Guide',
              resizeToAvoidBottomInset: true,
              onBackButtonPressed: () {
                warningTopSnackBar(
                    context, 'Do you want to discard this guide?', discard: () {
                  // Navigator.pop(context);
                  context.read<ExploreBloc>().onDelete!();
                  context.read<ExploreBloc>().add(ResetEvent());
                });
              },
              floatingActionButton: (state.units?.isEmpty ?? true)
                  ? FloatingActionButton(
                onPressed: () async {
                  await context
                      .read<ExploreBloc>()
                      .reloadThumbnail()
                      .then((String? value) {
                    if (formKey.currentState!.validate() &&
                        value != null) {
                      context
                          .read<ExploreBloc>()
                          .saveGuideDetails(context);
                    } else {
                      errorTopSnackBar(
                          context, "Please upload the cover photo");
                    }
                  });
                },
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.black,
                ),
              )
                  : null,
              child: CreateGuideForm(
                formKey: formKey,
                titleController: blocInstance.guideTitleController,
                descriptionController: blocInstance.guideDescriptionController!,
                categoriesController: blocInstance.guideCategoryController,
                exploreThumbnail: state.exploreThumbnail,
                guideIsEmpty: state.units?.isEmpty ?? true,
              )),
        );
      },
    );
  }
}
