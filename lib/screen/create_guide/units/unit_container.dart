import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';
import 'package:moonbase_explore/app_constants/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_builder_screen.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_or_video_view_box.dart';

import '../../../model/unit_model.dart';
import '../../../utils/tempo_dotted_box_widget.dart';

class UnitContainer extends StatelessWidget {
  const UnitContainer.buildAddMoreUnit({super.key, this.unit});

  const UnitContainer.buildWithUnit({super.key, required this.unit});

  final Unit? unit;

  @override
  Widget build(BuildContext context) {
    return unit != null
        ? UnitOrVideoViewBox.unitViewContainer(
            unit: unit!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnitBuilderScreen(unit: unit),
                ),
              );
            },
            onDelete: () {

            },

          )
        : const SizedBox();
  }
}
