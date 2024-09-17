import 'dart:io';

import 'package:flutter/material.dart';
import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../model/unit_model.dart';
import '../../../model/video_model.dart';

///
class UnitOrVideoViewBox extends StatelessWidget {
  const UnitOrVideoViewBox.unitViewContainer(
      {super.key,
      required this.unit,
      this.video,
      required this.onTap,
      required this.onDelete});

  const UnitOrVideoViewBox.videoViewContainer(
      {super.key,
      this.unit,
      required this.video,
      required this.onTap,
      required this.onDelete});

  final Unit? unit;
  final Video? video;
  final void Function() onTap;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          unit != null &&
                  unit!.videos.isNotEmpty &&
                  unit!.videos.first.videoDetails.coverImagePath.isNotEmpty
              ? _ViewBox(
                  title: 'Unit ${unit!.unitNumber}: ${unit!.title}',
                  localFilePath: unit!.videos.first.videoDetails.coverImagePath,
                  unit: unit!)
              : video != null && video!.videoDetails.coverImagePath.isNotEmpty
                  ? _ViewBox(
                      localFilePath: video!.videoDetails.coverImagePath,
                      title: 'Video ${video!.videoNumber}: ${video!.title}',
                      unit: unit!)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/no_image_found.png'),
                        ),
                        Text(
                          unit == null ? '' : 'Unit ${unit!.unitNumber}',
                          style: textFieldW600Size12Poppins,
                        ),
                      ],
                    ),
          // Positioned(
          //   right: -15.0,
          //   top: -10.0,
          //   child: IconButton(
          //     icon: const Icon(Icons.delete),
          //     onPressed: onDelete,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ViewBox extends StatelessWidget {
  const _ViewBox(
      {required this.localFilePath, required this.title, required this.unit});

  final String localFilePath;
  final String title;
  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircleAvatar(
        radius: 30,
        backgroundImage: unit.unitPicture.isEmpty
            ? const NetworkImage('https://placehold.co/600x400')
                as ImageProvider<Object>?
            : FileImage(File(unit.unitPicture)) as ImageProvider<Object>?,
      ),

      // Container(
      //     height: 60,
      //     width: 60,
      //     decoration:
      //         const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
      //     child: const Icon(Icons.add)),
      Text(
        'Unit ${unit.unitNumber}',
        style: textFieldW600Size12Poppins,
      ),
    ]);
  }
}
