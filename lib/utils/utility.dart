import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';
import 'package:uuid/uuid.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';
import '../widgets/common_text.dart';

SizedBox heightBox5() => const SizedBox(height: TSizeConstants.height5);

SizedBox heightBox10() => const SizedBox(height: TSizeConstants.height10);

SizedBox heightBox20() => const SizedBox(height: TSizeConstants.height20);

SizedBox heightBox30() => const SizedBox(height: TSizeConstants.height30);

SizedBox widthBox5() => const SizedBox(width: TSizeConstants.width5);

SizedBox widthBox10() => const SizedBox(width: TSizeConstants.width10);

SizedBox widthBox20() => const SizedBox(width: TSizeConstants.width20);

SizedBox widthBox30() => const SizedBox(width: TSizeConstants.width30);

void dismissKeyboard() =>
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

Future<void> showAlertDailog(
  BuildContext context,
  String alertMessage, {
  required String successOption,
  required String cancelOption,
  required Function onSuccess,
  required Function onCancel,
  Color successColor = buttonRedColor,
  Color cancelColor = secondaryColor,
  bool isDismissible = true,
  String? subText,
}) async {
  dismissKeyboard();
  await showDialog(
    barrierDismissible: isDismissible,
    context: context,
    builder: (_) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: primaryColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        title: SingleChildScrollView(
          child: Column(
            children: [
              TText(
                alertMessage,
                variant: TypographyVariant.h1,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1000,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              heightBox5(),
              if (subText != null)
                Column(
                  children: [
                    TText(
                      subText,
                      variant: TypographyVariant.h3,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                      maxLines: 1000,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    heightBox5(),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: TText(
                        cancelOption,
                        variant: TypographyVariant.h1,
                        style: TextStyle(color: cancelColor),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ).onUserTap(onCancel),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: TText(
                        successOption,
                        variant: TypographyVariant.h1,
                        style: TextStyle(color: successColor),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ).onUserTap(onSuccess),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> isVideoCrossedLimit(XFile file) async {
  int sizeInBytes = await file.length();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  if (sizeInMb > 50) {
    return true;
  } else {
    return false;
  }
}

Future<String?> saveVideoToApplicationDirectory(String videoFilePath) async {
  try {
    // Get the application's document directory
    Directory appDirectory = await getApplicationDocumentsDirectory();
    const uuid = Uuid();

    // Create a file object with the desired name (you can change the name)
    File destinationFile = File('${appDirectory.path}/${uuid.v1()}.mp4');

    // Copy the video file to the destination
    await File(videoFilePath).copy(destinationFile.path);

    return destinationFile.path;
  } catch (e) {
    return videoFilePath;
  }
}

Color getColorForString(String uniqueString) {
  int hash = 0;
  for (int i = 0; i < uniqueString.length; i++) {
    hash =
        ((hash << 5) - hash) + uniqueString.codeUnitAt(i);
  }
  final red = (hash & 0xFF0000) >> 16;
  final green = (hash & 0xFF00) >> 8;
  final blue = (hash & 0xFF);
  return Color.fromRGBO(red, green, blue, 1.0);
}
