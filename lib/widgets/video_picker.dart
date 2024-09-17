import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import 'package:moonbase_explore/widgets/tempo_text_button.dart';
import 'package:video_editor/video_editor.dart';
import '../bloc/explore_bloc.dart';
import 'common_text.dart';

class VideoPicker extends StatefulWidget {
  final Function(VideoEditorController) controller;

  const VideoPicker({super.key, required this.controller});

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  bool _first = true;

  @override
  void initState() {
    Future.delayed(
        const Duration(milliseconds: 500),
        () => setState(() {
              _first = false;
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      pageTitle: 'Edit video',
      onBackButtonPressed: () {
        context.read<ExploreBloc>().coverVideoController!.video.pause();
        Navigator.pop(context);
      },
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 3),
        secondChild: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _topNavBar(context.read<ExploreBloc>().coverVideoController!, 30.0),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: context.read<ExploreBloc>().coverVideoController!.video.value.aspectRatio,
                    child: CropGridViewer.preview(controller: context.read<ExploreBloc>().coverVideoController!),
                  ),
                  AnimatedBuilder(
                    animation: context.read<ExploreBloc>().coverVideoController!.video,
                    builder: (_, __) => AnimatedOpacity(
                      opacity: 1,
                      duration: kThemeAnimationDuration,
                      child: GestureDetector(
                        onTap: () {
                          if (context.read<ExploreBloc>().coverVideoController!.video.value.isPlaying) {
                            context.read<ExploreBloc>().coverVideoController!.video.pause;
                          } else {
                            context.read<ExploreBloc>().coverVideoController!.video.play;
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            context.read<ExploreBloc>().coverVideoController!.video.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _trimSlider(context.read<ExploreBloc>().coverVideoController!),
              ),
            ),
            // _coverSelection(controller),
          ]),
        ),
        firstChild: const SizedBox(),
        crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _trimSlider(VideoEditorController controller) {
    return [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              controller,
              controller.video,
            ]),
            builder: (_, __) {
              final int duration = controller.videoDuration.inSeconds;
              final double pos = controller.trimPosition * duration;

              return Row(children: [
                Text(
                  formatter(
                    Duration(seconds: pos.isNaN ? 0 : pos.toInt()),
                  ),
                ),
                const Expanded(child: SizedBox()),
                AnimatedOpacity(
                  opacity: controller.isTrimming ? 1 : 0,
                  duration: kThemeAnimationDuration,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(formatter(controller.startTrim)),
                    const SizedBox(
                      child: TText(
                        ' - ',
                        variant: TypographyVariant.titleSmall,
                      ),
                    ),
                    Text(formatter(controller.endTrim)),
                  ]),
                ),
              ]);
            },
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height*0.2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: !_first?TrimSlider(
          controller: controller,
          height: 60,
          horizontalMargin: 10 / 4,
          maxViewportRatio: 2.5,
          child: TrimTimeline(
            controller: controller,
            padding: const EdgeInsets.only(top: 5),
          ),
        ):const SizedBox(),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TempoTextButton(
          text: 'Done',
          onPressed: () {
            controller.video.pause();
            widget.controller(controller);
            context.read<ExploreBloc>().processVideo(controller, context);
          },
        ),
      )
    ];
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  Widget _topNavBar(controller, height) {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(
                onPressed: () => controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(Icons.rotate_left),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right),
                tooltip: 'Rotate clockwise',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
          ],
        ),
      ),
    );
  }
}
