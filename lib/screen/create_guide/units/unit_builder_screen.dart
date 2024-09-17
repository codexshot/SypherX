import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/screen/create_guide/units/all_videos_view_builder.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';

import '../../../app_constants/custom_snackbars.dart';
import '../../../app_constants/size_constants.dart';
import '../../../model/unit_model.dart';
import '../../../utils/enums.dart';
import '../../../utils/utility.dart';
import '../../../widgets/common_edit_text_field.dart';
import '../../../widgets/custom_floating_action_btn.dart';
import '../../../widgets/tempo_text_button.dart';
import '../description_text_field.dart';

class UnitBuilderScreen extends StatefulWidget {
  const UnitBuilderScreen({super.key, required this.unit});

  final Unit? unit;

  @override
  State<UnitBuilderScreen> createState() => _UnitBuilderScreenState();
}

class _UnitBuilderScreenState extends State<UnitBuilderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String unitPicture = '';

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  setInitialValues() {
    if (widget.unit != null) {
      context.read<ExploreBloc>().currentUnitTitleController!.text =
          widget.unit!.title;
      context.read<ExploreBloc>().currentUnitDescriptionController!.text =
          widget.unit!.description;
      setState(() {
        unitPicture = widget.unit!.unitPicture;
      });
    }
  }

  //==========================================================================================

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: 86.0,
            height: 103.0,
            child: InkWell(
              onTap: () async {
                ImagePicker picker = ImagePicker();
                final exploreBloc = context.read<ExploreBloc>();
                final pic =
                    await exploreBloc.chooseUnitThumbnail(picker, context);
                setState(() {
                  unitPicture = pic;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                      radius: 35.0,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: unitPicture.isNotEmpty
                          ? FileImage(
                              File(unitPicture),
                            )
                          : null),
                  const Center(
                    child: Icon(
                      Icons.camera_alt, // Camera icon
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  Positioned(
                    bottom: 2.0, // Adjust the positioning as needed
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: const BoxDecoration(
                        color: Color(0xffF35307),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit, // Edit icon
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TTextField(
            controller: context.read<ExploreBloc>().currentUnitTitleController!,
            label: 'Unit Name',
            choice: ChoiceEnum.text,
            hintText: 'Give your unit a name...',
          ),
          const SizedBox(height: 20),
          DescriptionTextField(
            controller:
                context.read<ExploreBloc>().currentUnitDescriptionController!,
            lableText: 'Description',
            hintText: 'The description of the unit...',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: TSizeConstants.collabButtonsHeight,
                  child: BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) => TempoTextButton(
                      text: '+ Add Video',
                      radius: 15,
                      enabledBackgroundColor: primaryColor,
                      textStyle: const TextStyle(color: greyColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllVideosViewBuilder(
                                    unit: widget.unit,
                                  )),
                        );
                      },
                      isButtonEnabled: true,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: TSizeConstants.collabButtonsHeight,
                  child: BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) => TempoTextButton(
                      text: 'Delete',
                      radius: 15,
                      onPressed: () {
                        final index = widget.unit!.unitNumber - 1;
                        context
                            .read<ExploreBloc>()
                            .currentUnitTitleController!
                            .clear();
                        context
                            .read<ExploreBloc>()
                            .currentUnitDescriptionController!
                            .clear();
                        context.read<ExploreBloc>().removeUnit(context, index);
                      },
                      enabledBackgroundColor: const Color(0xffFB655F),
                      isButtonEnabled: true,
                    ),
                  ),
                ),
              )
            ],
          )
          /*BlocBuilder<QuizzesBloc, QuizzesState>(builder: (context, state) {
            List<QuizModel> unitQuizzes = BlocProvider.of<QuizzesBloc>(context)
                .unitQuizzes(widget.unit?.unitNumber ?? 1);

            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: unitQuizzes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(children: [
                      const Icon(Icons.question_answer),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TText(unitQuizzes[index].quizTitle,
                            variant: TypographyVariant.body),
                      ),
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            context.read<QuizzesBloc>().add(
                                RemoveQuizEvent(unitQuizzes[index].quizId));
                          })
                    ]),
                  );
                });
          }),*/
          /*        QuizButton(
            onPressed: () {
              Unit? fetchedUnit;
              const maxQuizzesPerUnit = 3;
              if (context.read<QuizzesBloc>().unitQuizzes(widget.unit?.unitNumber ?? 1).length - 1 <
                  maxQuizzesPerUnit) {
                String guideTitle = context.read<ExploreBloc>().guideTitleController?.text ?? "";
                try {
                  context.read<ExploreBloc>().saveTitleAndDescriptionUnit(
                      context.read<ExploreBloc>().currentUnitTitleController!.text,
                      context.read<ExploreBloc>().currentUnitDescriptionController!.text,
                      widget.unit?.unitNumber ?? 1);
                  final List<Unit> list = [];
                  list.addAll(context.read<ExploreBloc>().state.units!);
                  fetchedUnit = list.firstWhere((element) => element.unitNumber == widget.unit!.unitNumber);
                } catch (e) {
                  print(e);
                }
                context.read<ExploreBloc>().onQuizPressed!(widget.unit?.unitNumber ?? 1, guideTitle, fetchedUnit!);
              } else {
                if (kDebugMode) {
                  print("Max number of quizzes for this unit is $maxQuizzesPerUnit");
                }
              }
            },
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      pageTitle: 'Unit ${widget.unit?.unitNumber ?? 1}',
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          _onPressNext(unitPicture);
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizeConstants.padding20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(),
                    heightBox20(),
                    /*       const TText('Add your videos for the unit here',
                        variant: TypographyVariant.bodyLarge),
                    heightBox20(),*/
                    // UnitsVideoGridView(
                    //   int.parse(widget.unit?.unitNumber.toString() ?? '1'),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressNext(String unitPicture) {
    if (_formKey.currentState!.validate() && unitPicture.isNotEmpty) {
      context.read<ExploreBloc>().saveTitleAndDescriptionUnit(
          context.read<ExploreBloc>().currentUnitTitleController!.text,
          context.read<ExploreBloc>().currentUnitDescriptionController!.text,
          widget.unit?.unitNumber ?? 1,
          unitPicture);
      context.read<ExploreBloc>().saveUnitDetails(context);
    }
    if (unitPicture.trim().isEmpty) {
      errorTopSnackBar(context, 'Please select a unit picture');
    }
  }
}
