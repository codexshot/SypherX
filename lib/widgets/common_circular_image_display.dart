import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';
import '../utils/string_utils.dart';
import 'TempoCacheImage.dart';


class TempoCircularImageDisplay  extends StatelessWidget{
  const TempoCircularImageDisplay({
    Key? key,
    this.imagePath,
    this.radius = TSizeConstants.radius20,
    this.imageUrl,
  }) : super(key: key);

  final String? imagePath;
  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: greyShaded300,
      ),
      child: StringUtils.isNullOrEmptyAfterTrim(imagePath)
          ? StringUtils.isNullOrEmptyAfterTrim(imageUrl)
              ? Padding(
                  padding: EdgeInsets.all(radius / 2),
                  child: SvgPicture.asset('assets/images/user.svg', fit: BoxFit.contain),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: TempoCacheImage(
                    imageUrl: imageUrl!,
                    // height: radius * 2,
                    // width: radius * 2,
                  ),
                )
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.memory(
                base64Decode(imagePath!),
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
