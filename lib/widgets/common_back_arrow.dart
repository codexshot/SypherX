import 'dart:io';

import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';

class TBackArrow extends StatelessWidget {
  const TBackArrow({
    Key? key,
    this.onTap,
    this.arrowColor = buttonColor,
  }) : super(key: key);

  final Function? onTap;
  final Color arrowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              onTap!();
            }
          : () {
              Navigator.of(context).pop();
            },
      child: Icon(
        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        size: TSizeConstants.iconSize23,
        color: arrowColor,
      ),
    );
  }
}
