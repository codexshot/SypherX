import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';
import 'package:moonbase_explore/screen/create_guide/units/units_video_grid_view.dart';
import 'package:moonbase_explore/widgets/tempo_text_button.dart';

import '../../../bloc/explore_bloc.dart';
import '../../../model/unit_model.dart';
import '../../../model/video_model.dart';
import '../../../widgets/base_tempo_screen.dart';
import '../../../widgets/custom_floating_action_btn.dart';

class AllVideosViewBuilder extends StatefulWidget {
  final Unit? unit;

  const AllVideosViewBuilder({super.key, required this.unit});

  @override
  State<AllVideosViewBuilder> createState() => _AllVideosViewBuilderState();
}

class _AllVideosViewBuilderState extends State<AllVideosViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(builder: (context, state) {
      List<Video>? videos = [];
      try {
        videos = state.units?[widget.unit!.unitNumber - 1].videos;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }

      return BgTempoScreen(
        pageTitle: 'Videos',
        actions: [
          SizedBox(
            width: 90,
            height: 25,
            child: TempoTextButton(
                radius: 5,
                text: '+ Add Video',
                enabledBackgroundColor: primaryColor,
                textStyle: const TextStyle(fontSize: 11, color: greyColor),
                onPressed: () {
                  context.read<ExploreBloc>().navigateToVideoBuilderScreen(
                      context: context,
                      unitIndex: widget.unit!.unitNumber,
                      videosData: null,
                      videoNumber: videos?.length ?? 1);
                }),
          ),
        ],
        floatingActionButton: CustomFloatingActionButton(
          onPressed: _onPressNext,
        ),
        child: UnitsVideoGridView(
          int.parse(widget.unit?.unitNumber.toString() ?? '1'),
        ),
      );
    });
  }

  void _onPressNext() {
    Navigator.pop(context);
  }
}
