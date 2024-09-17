import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_form.dart';
import 'package:moonbase_theme/text_themes/moonbase_text_themes.dart';

import 'package:provider/provider.dart';
import 'package:moonbase_explore/app_constants/size_constants.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/model/collab_type.dart';
import 'package:moonbase_explore/model/unit_model.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_builder_screen.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../model/video_model.dart';
import '../../../utils/common_no_data_widget.dart';
import '../../../utils/utility.dart';
import '../../../widgets/custom_floating_action_btn.dart';
import '../create_guide_screen.dart';
import 'all_units_view_builder.dart';

class UnitListScreen extends StatefulWidget {
  const UnitListScreen({super.key});

  @override
  State<UnitListScreen> createState() => _UnitListScreenState();
}

class _UnitListScreenState extends State<UnitListScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> _onPressNext() async {
    final blocInstance = context.read<ExploreBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreateGuideScreen(isEditable: true,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      pageTitle: 'Units',
      resizeToAvoidBottomInset: true,
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onPressNext,
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizeConstants.padding10),
        child: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, state) => Column(
            children: [
              Expanded(
                child: state.units!.isNotEmpty
                    ? AllUnitsViewBuilder(
                        allUnits: state.units ?? [],
                      )
                    : Stack(
                        children: [
                          const Center(
                            child: TempoNoDataWidget(
                              text:
                                  '''Hey there! It looks like there are no units added to this guide yet. To add a unit, simply click on the "Add first unit" button and start creating your guide.''',
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UnitBuilderScreen(
                                      unit: Unit(
                                          id: '',
                                          unitNumber: 1,
                                          title: '',
                                          description: '',
                                          videos: [],
                                          unitPicture: ''))),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                      height: 60,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor),
                                      child: const Icon(Icons.add)),
                                  const Text(
                                    'New unit',
                                    style: textFieldW600Size12Poppins,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // TempoTextButton(
                          //   text: 'Add first unit',
                          //   width: 0,
                          //   radius: 15,
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => UnitBuilderScreen(
                          //               unit: Unit(id: '', unitNumber: 1, title: '', description: '', videos: []))),
                          //     );
                          //   },
                          // )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
