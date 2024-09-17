import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';

import 'collab_cover_image_display.dart';
import 'common_text.dart';
import 'common_text_display_box_widget.dart';

class TempoVideoWithContentWidget extends StatelessWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final void Function()? onPressed;
  final String? localCoverImagePath;

  const TempoVideoWithContentWidget.buildWithImageUrl(
      {super.key, required this.title, required this.content, required this.imageUrl, this.onPressed, this.localCoverImagePath});

  const TempoVideoWithContentWidget.buildWithLocalImagePath(
      {super.key, required this.title, required this.content, this.imageUrl, this.onPressed, required this.localCoverImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CollabCoverImageDisplay(
                        imageUrl: imageUrl,
                        localCoverImage: localCoverImagePath,
                      ),
                    ),
                  ),
                  if (imageUrl != null)
                    const Positioned(
                      top: 35,
                      left: 60,
                      child: Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.white,
                        size: 30,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                ],
              ).onUserTap(onPressed ?? () {}),
              const SizedBox(width: 10),
              Expanded(
                child: TText(
                  title,
                  variant: TypographyVariant.h1,
                  maxLines: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TempoTextDisplayBoxWidget(
            text: content,
            maximumLinesToCheck: 5,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
