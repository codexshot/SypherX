import 'package:flutter/material.dart';


import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';
import '../model/connect_group_model.dart';
import '../utils/utility.dart';
import 'common_circular_image_display.dart';
import 'common_text.dart';

class TempoGroupShortDisplayWidget extends StatelessWidget  {
  const TempoGroupShortDisplayWidget({super.key, required this.room, this.isSelected, this.onPressed});

  final ConnectedGroupModel room;
  final bool? isSelected;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                TempoCircularImageDisplay(
                  imageUrl: room.roomImage,
                  radius: TSizeConstants.radius20,
                ),
                widthBox10(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TText(room.roomName, variant: TypographyVariant.body),
                      isSelected != null && isSelected!
                          ? const CircleAvatar(
                              radius: 10,
                              backgroundColor: primaryDarkColor,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
