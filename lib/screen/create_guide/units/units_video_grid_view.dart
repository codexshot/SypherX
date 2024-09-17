import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonbase_explore/screen/create_guide/units/video_box.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:moonbase_explore/app_constants/size_constants.dart';
import 'package:moonbase_explore/model/video_model.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_or_video_view_box.dart';
import '../../../bloc/explore_bloc.dart';
import '../../../utils/tempo_dotted_box_widget.dart';

class UnitsVideoGridView extends StatefulWidget {
  final int index;

  const UnitsVideoGridView(this.index, {super.key});

  @override
  State<UnitsVideoGridView> createState() => _UnitsVideoGridViewState();
}

class _UnitsVideoGridViewState extends State<UnitsVideoGridView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(builder: (context, state) {
      List<Video>? videos = [];
      try {
        videos = state.units?[widget.index - 1].videos;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      return ListView.builder(
        itemCount: videos?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: VideoViewBox(
              onTap: () {
                context.read<ExploreBloc>().navigateToVideoBuilderScreen(
                    context: context,
                    unitIndex: widget.index,
                    videosData: videos![index],
                    videoNumber:index + 1);
              },
              onDelete: () {
                setState(() {
                  context.read<ExploreBloc>().removeVideoAtIndex(
                      unitIndex: widget.index, index, context);
                });
              },
              video:videos![index]

            ),
          );
        },
      );
    });
  }
}
