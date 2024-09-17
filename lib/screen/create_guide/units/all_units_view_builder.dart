import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moonbase_explore/screen/create_guide/units/unit_container.dart';

import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../bloc/explore_bloc.dart';
import '../../../model/unit_model.dart';

class AllUnitsViewBuilder extends StatelessWidget {
  const AllUnitsViewBuilder(
      {super.key, required this.allUnits, this.gridPadding});

  final List<Unit> allUnits;
  final EdgeInsets? gridPadding;

  void _onAddUnit(BuildContext context) {
    context.read<ExploreBloc>().addUnit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: gridPadding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      child: GridView.builder(
        shrinkWrap: true,

        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),

        itemCount: allUnits.length + 1, // Adding 1 to account for the last "add more" item
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of columns
          crossAxisSpacing: 0, // Horizontal space between cells
          mainAxisSpacing: 0, // Vertical space between cells

        ),
        itemBuilder: (context, index) {
          if (index == allUnits.length) {
            // This is the last item which is the "add more" button
            return InkWell(
              onTap: () => _onAddUnit(context),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: const Icon(Icons.add),
                  ),
                  const Text(
                    'New unit',
                    style: textFieldW600Size12Poppins,
                  ),
                ],
              ),
            );
          } else {
            // This is a regular unit item
            final unit = allUnits[index];
            return UnitContainer.buildWithUnit(
              unit: unit,
            );
          }
        },
      ),
    );

  }
}
