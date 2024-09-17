import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moonbase_explore/bloc/video_bloc/video_bloc.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import 'package:moonbase_explore/widgets/tempo_text_button.dart';
import 'package:video_editor/video_editor.dart';
import '../../../bloc/explore_bloc.dart';
import '../../../widgets/common_text.dart';

class UnitVideoPicker extends StatefulWidget {
  const UnitVideoPicker({
    super.key,
  });

  @override
  State<UnitVideoPicker> createState() => _UnitVideoPickerState();
}

class _UnitVideoPickerState extends State<UnitVideoPicker> {
  @override
  void initState() {
    try {
      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                _first = false;
              }));
      // context.read<VideoBloc>().videoEditorController!.initialize().then((_) => setState(() {}));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    super.initState();
  }

  bool _first = true;

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      pageTitle: 'Edit video',
      onBackButtonPressed: () {
        context.read<VideoBloc>().videoEditorController!.video.pause();



        // context.read<VideoBloc>().videoEditorController!.video.dispose();
        Navigator.pop(context);
      },
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 3),
        firstChild: const SizedBox(),
        secondChild: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _topNavBar(context.read<VideoBloc>().videoEditorController!, 30.0),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CropGridViewer.preview(controller: context.read<VideoBloc>().videoEditorController!),
                  AnimatedBuilder(
                    animation: context.read<VideoBloc>().videoEditorController!.video,
                    builder: (_, __) => AnimatedOpacity(
                      opacity: context.read<VideoBloc>().videoEditorController!.isPlaying ? 0 : 1,
                      duration: kThemeAnimationDuration,
                      child: GestureDetector(
                        onTap: context.read<VideoBloc>().videoEditorController!.video.play,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
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
                children: _trimSlider(context.read<VideoBloc>().videoEditorController!),
              ),
            ),
            // _coverSelection(context.read<VideoBloc>().videoEditorController!),
          ]),
        ),
        crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }

  @override
  void dispose() {
    context.read<VideoBloc>().add(ResetVideoBlocEvent());
    super.dispose();
  }

  List<Widget> _trimSlider(VideoEditorController controller) {
    return [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            controller,
            controller.video,
          ]),
          builder: (_, __) {
            final int duration = controller.videoDuration.inSeconds;
            final double pos = controller.trimPosition * duration;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60 / 4),
              child: Row(children: [
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
              ]),
            );
          },
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        margin: const EdgeInsets.only(top: 10),
        child: TrimSlider(
          controller: controller,
          height: 60,
          horizontalMargin: 10 / 4,
          child: TrimTimeline(
            controller: controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TempoTextButton(
          text: 'Done',
          onPressed: () async {
            controller.video.pause();


            Navigator.pop(context, controller);
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
