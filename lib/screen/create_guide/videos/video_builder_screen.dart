import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/bloc/video_bloc/video_bloc.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../app_constants/custom_snackbars.dart';
import '../../../app_constants/size_constants.dart';
import '../../../bloc/explore_bloc.dart';
import '../../../generated/assets.dart';
import '../../../model/video_model.dart';
import '../../../utils/enums.dart';
import '../../../widgets/VideoDialog.dart';
import '../../../widgets/common_edit_text_field.dart';
import '../../../widgets/common_text.dart';
import '../../../widgets/custom_floating_action_btn.dart';
import '../../../widgets/tempo_text_button.dart';
import '../description_text_field.dart';

class VideoBuilderScreen extends StatefulWidget {
  final Video? video;

  const VideoBuilderScreen({super.key, required this.video});

  @override
  State<VideoBuilderScreen> createState() => _VideoBuilderScreenState();
}

class _VideoBuilderScreenState extends State<VideoBuilderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final videoSelectorKey = DateTime.now().toUtc().millisecondsSinceEpoch;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    if (widget.video != null) {
      titleController.text = widget.video!.title;
      descriptionController.text = widget.video!.caption;
      context.read<VideoBloc>().video = widget.video;
      try {
        if (widget.video!.videoDetails.localPath != null) {
          await context
              .read<VideoBloc>()
              .initUnitController(
                  XFile(widget.video!.videoDetails.localPath!), context)
              .then((value) => context.read<VideoBloc>().emit(VideoState(
                  videoPath: widget.video!.videoDetails.localPath!,
                  imagePath: widget.video!.videoDetails.coverImagePath)));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return BgTempoScreen(
          pageTitle: 'Add video',
          resizeToAvoidBottomInset: true,
          onBackButtonPressed: () {
            context.read<VideoBloc>().add(ResetVideoBlocEvent());
            Navigator.pop(context);
          },
          floatingActionButton: CustomFloatingActionButton(
            onPressed:(){  saveVideo(context);},
          ),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: viewingCard(state.imagePath, context))
                  .onUserTap(() async {
                context.read<VideoBloc>().add(OpenImagePickerEvent(context));
              }),
              _buildForm(),
            ],
          )),
        );
      },
    );
  }

  Widget viewingCard(String? image, BuildContext context) {
    return image != null && image.isNotEmpty
        ? Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(File(image), fit: BoxFit.cover)),
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
                    ).onUserTap(() {
                      context
                          .read<VideoBloc>()
                          .add(OpenImagePickerEvent(context));
                    }),
                  ),
                  BlocBuilder<VideoBloc, VideoState>(
                    builder: (context, state) {
                      return Padding(
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
                        ).onUserTap(
                          () => showDialog(
                            context: context,
                            builder: (context) =>
                                VideoDialog(videoFile: File(state.videoPath!)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          )
        : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryColor,
                ),
                child: const Icon(Icons.add, size: 40, color: Colors.white))
            .onUserTap(
            () => context.read<VideoBloc>().add(
                  OpenImagePickerEvent(context),
                ),
          );
  }

/*  Widget _buildVideo(String imagePath) {
    return imagePath.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(File(imagePath), fit: BoxFit.cover),
          )
        : DottedBorder(
            color: secondaryColor,
            strokeWidth: 1,
            radius: const Radius.circular(15),
            borderType: BorderType.RRect,
            dashPattern: const [8, 4, 5],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: SvgPicture.asset(Assets.imagesUploadBillboardImage)),
                const SizedBox(height: 20),
                const TText('Add video here', variant: TypographyVariant.h1),
              ],
            ),
          );
  }*/

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizeConstants.tempoDefaultPadding),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TTextField(
              controller: titleController,
              label: 'Video Name',
              choice: ChoiceEnum.text,
              hintText: 'My awesome guide to the galaxy...',
            ),
            const SizedBox(height: 20),
            DescriptionTextField(
              controller: descriptionController,
              lableText: 'Description',
              hintText: 'Description...',
            ),
            const SizedBox(height: 5),

     /*       Row(
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
                        onPressed: () {},
                        enabledBackgroundColor: const Color(0xffFB655F),
                        isButtonEnabled: true,
                      ),
                    ),
                  ),
                )
              ],
            ),*/

          ],
        ),
      ),
    );
  }

  saveVideo(BuildContext context) {
    try {
      _formKey.currentState!.validate();
      bool isValidated = _formKey.currentState!.validate();

      if (isValidated) {
        context.read<VideoBloc>().add(ProcessSelectVideoEvent(
            context,
            titleController.text,
            descriptionController.text,
            widget.video!.unitNumber,
            widget.video!.videoNumber ?? 1,
            widget.video!.id ?? ''));
      } else {
        errorTopSnackBar(context, 'Something Went Wrong!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
