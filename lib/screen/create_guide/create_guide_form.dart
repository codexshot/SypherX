// import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/model/guide.dart';
import 'package:moonbase_explore/screen/create_guide/location_selector.dart';
import 'package:moonbase_explore/screen/create_guide/units/all_quizzes_builder.dart';
import 'package:moonbase_explore/screen/create_guide/units/all_units_view_builder.dart';
import 'package:moonbase_explore/utils/utility.dart';
import 'package:moonbase_explore/widgets/VideoDialog.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_text_style.dart';
import '../../app_constants/size_constants.dart';
import '../../generated/assets.dart';
import '../../hive/local_storage_manager.dart';
import '../../utils/enums.dart';
import '../../utils/focus_node_disabled.dart';
import '../../widgets/common_edit_text_field.dart';
import '../../widgets/common_text.dart';
import '../../widgets/tempo_text_button.dart';
import 'description_text_field.dart';

class CreateGuideForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? titleController,
      descriptionController,
      categoriesController;
  final File? exploreThumbnail;
  final bool guideIsEmpty;

  const CreateGuideForm(
      {super.key,
      required this.formKey,
      this.guideIsEmpty = false,
      required this.titleController,
      required this.descriptionController,
      this.categoriesController,
      required this.exploreThumbnail});

  @override
  State<CreateGuideForm> createState() => _CreateGuideFormState();
}

class _CreateGuideFormState extends State<CreateGuideForm> {
  GlobalKey<ScaffoldState> trailerVideoKey = GlobalKey();
  GlobalKey<ScaffoldState> thumbnailKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView(
            shrinkWrap: false,
            children: [
              /*  Padding(
                padding: const EdgeInsets.only(top: TSizeConstants.padding30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: viewingCard(widget.exploreThumbnail, context),
                    ),
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        futureBuilderWidget(),
                      ],
                    ),
                    const SizedBox(height: 5)
                  ],
                ),
              ),

              TTextField(
                controller: widget.titleController!,
                label: 'Title',
                choice: ChoiceEnum.text,
                hintText: 'My awesome guide to the galaxy ...',
              ),
              const SizedBox(height: 20),
              DescriptionTextField(
                controller: widget.descriptionController!,
                lableText: 'Description',
                hintText: 'The beautiful galaxy...',
              ),
              const SizedBox(height: 30),
              if(!widget.guideIsEmpty)...[
                Text("Units", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color:Colors.white),),
                const SizedBox(height: 10),
                BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context,state){
                      return AllUnitsViewBuilder(
                        allUnits: state.units ?? [],
                        gridPadding: EdgeInsets.zero,
                      );
                    }
                ),
                const SizedBox(height: 30),
                Text("Quizzes", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color:Colors.white),),
                const SizedBox(height: 10),
                BlocBuilder<QuizzesBloc, QuizzesState>(
                    builder: (context,state){
                      return AllQuizzesBuilder(
                        allQuizzes: state.quizzes ?? [],
                        gridPadding: EdgeInsets.zero,
                      );
                    }
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
                        child: TempoTextButton(
                          text: 'Preview',
                          radius: 15,
                          enabledBackgroundColor: primaryColor,
                          textStyle: const TextStyle(color: greyColor),
                          onPressed: () {

                            context.read<ExploreBloc>().onPreviewTapped(context);
                          },
                          isButtonEnabled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: TSizeConstants.collabButtonsHeight,
                        child: TempoTextButton(
                          text: 'Delete',
                          radius: 15,
                          onPressed: () {
                            warningTopSnackBar(context, 'Do you want to discard this guide?',
                                discard: () {
                                  try{
                                    Navigator.pop(context);
                                    context.read<ExploreBloc>().onDelete!();
                                    context.read<ExploreBloc>().add(ResetEvent());
                                  }catch(e){
                                    if (kDebugMode) {
                                      print(e);
                                    }
                                  }
                                });
                          },
                          enabledBackgroundColor: const Color(0xffFB655F),
                          isButtonEnabled: true,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: TSizeConstants.collabButtonsHeight,
                    child: TempoTextButton(
                      text: 'Publish',
                      radius: 15,
                      enabledBackgroundColor: primaryColor,
                      textStyle: const TextStyle(color: greyColor),
                      onPressed: () async{
                        final quizzes = context.read<QuizzesBloc>().allQuizzes;
                        Guide guide = await context.read<DraftBloc>().getDraft(context);
                        guide = guide.copyWith(quizzes:quizzes) as Guide;
                        if(context.mounted){
                          context.read<ExploreBloc>().onGuidePreview!(guide.toJson());
                        }
                      },
                      isButtonEnabled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: TSizeConstants.collabButtonsHeight,
                    child: TempoTextButton(
                      text: 'Save Draft',
                      radius: 15,
                      enabledBackgroundColor: primaryColor,
                      textStyle: const TextStyle(color: greyColor),
                      onPressed: () async{
                        final quizzes = context.read<QuizzesBloc>().allQuizzes;
                        Guide guide = await context.read<DraftBloc>().getDraft(context);
                        guide = guide.copyWith(quizzes:quizzes) as Guide;
                        if(context.mounted){
                          context.read<ExploreBloc>().onGuideSaved!(guide.toJson());
                        }
                      },
                      isButtonEnabled: true,
                    ),
                  ),
                ),
              ],
              // const LocationSelector(),
              // const SizedBox(height: 30),
              /*    Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
                  border: Border.all(
                    color: primaryDarkColor,
                    width: TSizeConstants.borderOpacity,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TText('Thumbnail', variant: TypographyVariant.subtitle),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        futureBuilderWidget(),
                      ],
                    ),
                    const SizedBox(height: 5)
                  ],
                ),
              ),
              const SizedBox(height: 30),*/
              /*    BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: TSizeConstants.collabButtonsHeight,
                    child: TempoTextButton(
                      text: 'Add units',
                      radius: 15,
                      onPressed: () async {
                        await context
                            .read<ExploreBloc>()
                            .reloadThumbnail()
                            .then((String? value) {
                          if (widget.formKey!.currentState!.validate() &&
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
                    ),
                  );
                },
              ),*/
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget futureBuilderWidget() {
    return InkWell(
      onTap: () async {
        await context.read<ExploreBloc>().pickThumbnail(context);
        setState(() {});
      },
      child: FutureBuilder<String?>(
        future: context.read<ExploreBloc>().reloadThumbnail(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            return
                /*  widget.exploreThumbnail == null
                ? DottedBorder(
                  color: secondaryColor,
                  strokeWidth: 1,
                  radius: const Radius.circular(15),
                  borderType: BorderType.RRect,
                  dashPattern: const [8, 4, 5],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: SvgPicture.asset(
                              Assets.imagesUploadBillboardImage)),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
                :*/
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        snapshot.data!.isNotEmpty
                            ? File(snapshot.data!)
                            : File(widget.exploreThumbnail!.path),
                        fit: BoxFit.fill,
                        errorBuilder: (context,_,__){
                          return  const Center(
                            child: Icon(
                              Icons.add,
                              size: 40,
                              color: buttonColor,
                            ),
                          );
                        },
                      ),
                    ),
                    snapshot.data!.isEmpty&&widget.exploreThumbnail!.path.isEmpty?const SizedBox():Container(
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Icon(
                          Icons.edit,
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.6,
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: buttonColor,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget viewingCard(File? image, BuildContext context) {
    return image != null
        ? Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(File(image.path), fit: BoxFit.cover),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: primaryColor,
                            size: 30,
                          ),
                          Text(
                            'Change',
                            style: appSubTitleTextStyle,
                          )
                        ],
                      ),
                    ).onUserTap(() async {
                      ImagePicker picker = ImagePicker();
                      final exploreBloc = context.read<ExploreBloc>();
                      exploreBloc.chooseGuideVideo(picker, context);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: primaryColor,
                            size: 30,
                          ),
                          Text(
                            'View',
                            style: appSubTitleTextStyle,
                          )
                        ],
                      ),
                    ).onUserTap(() => showDialog(
                        context: context,
                        builder: (context) => VideoDialog(
                            videoFile: context
                                .read<ExploreBloc>()
                                .coverVideoController!
                                .file))),
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              DottedBorder(
                color: secondaryColor,
                strokeWidth: 1,
                radius: const Radius.circular(15),
                borderType: BorderType.RRect,
                dashPattern: const [8, 4, 5],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: SvgPicture.asset(
                            Assets.imagesUploadBillboardImage)),
                    const SizedBox(height: 6),
                    const TText(
                      'Add trailer video here',
                      variant: TypographyVariant.h1,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).onUserTap(() async {
                ImagePicker picker = ImagePicker();
                final exploreBloc = context.read<ExploreBloc>();
                exploreBloc.chooseGuideVideo(picker, context);
              }),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TText(
                    'What is a trailer video?',
                    variant: TypographyVariant.h4,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: secondaryColor,
                  ),
                ],
              ).onUserTap(
                () async {
                  await showAlertDailog(context,
                      'A trailer video gives viewers an idea of what to expect from your guide. It will be viewable by all users from the explore page whether the guide is paid or free.',
                      successOption: 'Got it', cancelOption: '', onSuccess: () {
                    Navigator.of(context).pop();
                  }, onCancel: () {});
                },
              ),
            ],
          );
  }
}
