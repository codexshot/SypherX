import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';
import 'package:moonbase_explore/app_constants/size_constants.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';

import '../app_constants/app_colors.dart';
import '../model/explore_data_models.dart';
import 'common_text.dart';

List<ExploreCategory> categoryList = [];

showCategoryBottomSheet(context, List<ExploreCategory> list) {
  if (categoryList.isEmpty || list.length != categoryList.length) {
    categoryList.addAll(list);
  }

  showFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 0.8,
    context: context,
    builder: buildWidget,
    anchors: [0, 0.5, 0.8],
    isSafeArea: false,
    bottomSheetColor: Colors.transparent,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(TSizeConstants.radius20),
      color: Colors.white,
    ),
  );
}

Widget buildWidget(BuildContext context, ScrollController scrollController, double bottomSheetOffset) {
  return Material(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizeConstants.radius20)),
    color: Colors.white,
    child: ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      children: [
        const Center(
            child: TText(
          "Select Category",
          variant: TypographyVariant.titleSmall,
        )),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: categoryList
              .map(
                (e) => categoryTile(context, category: e),
              )
              .toList(),
        )
      ],
    ),
  );
}

Widget categoryTile(BuildContext context, {required ExploreCategory category}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          width: 2,
          color: buttonRedColor.withOpacity(0.40),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: buttonRedColor.withOpacity(0.40),
          width: MediaQuery.of(context).size.width * 0.60,
          child: TText(
            category.name.toUpperCase(),
            variant: TypographyVariant.body,
            style: const TextStyle(
              color: buttonRedColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Icon(Icons.accessibility_rounded),
      ],
    ).onUserTap(() => {context.read<ExploreBloc>().setCategory(category, context)}),
  );
}
