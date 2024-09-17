import 'dart:io';

import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:flutter/material.dart';

import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../model/unit_model.dart';
import '../../../model/video_model.dart';
import '../custom_dropdown.dart';

///
class VideoViewBox extends StatelessWidget {
  const VideoViewBox(
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: video!.videoDetails.coverImagePath.isEmpty
                      ? const AssetImage("assets/no_image_found.png")
                      : FileImage(File(video!.videoDetails.coverImagePath))
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" ${video!.videoNumber}. ${video!.title}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: greyColor,
                        fontWeight: FontWeight.w400)),

                AnimatedReadMoreText(
                  video!.caption,
                  maxLines: 3,
                  // Set a custom text for the expand button. Defaults to Read more
                  readMoreText: 'Show more',
                  // Set a custom text for the collapse button. Defaults to Read less
                  readLessText: 'Show less',
                  // Set a custom text style for the main block of text
                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: greyColor,
                      fontWeight: FontWeight.w400),
                  // Set a custom text style for the expand/collapse button
                  buttonTextStyle:const TextStyle(
                      fontSize: 12,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w400),
                )

              ],
            ),
          ),
          CustomDropDownButton(
            onDelete: onDelete,
            onEdit: onTap,
          ),
        ],
      ),
    );
  }
}
