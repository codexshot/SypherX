import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:clean_dialog/clean_dialog.dart';
import 'app_colors.dart';

const int snackbarDurationInMilliseconds = 500;

//===============================Error SnackBar=====================================================
void errorTopSnackBar(BuildContext context, String message,
    {int durationInMilliSeconds = snackbarDurationInMilliseconds}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(message: message, maxLines: 5),
    displayDuration: Duration(milliseconds: durationInMilliSeconds),
  );
}

//===================================Top SnackBar====================================================
void infoTopSnackBar(BuildContext context, String message,
    {int durationInMilliSeconds = snackbarDurationInMilliseconds}) {
  showTopSnackBar(Overlay.of(context), CustomSnackBar.info(message: message, maxLines: 5, backgroundColor: purpleColor),
      displayDuration: Duration(milliseconds: durationInMilliSeconds));
}

//=================================Success SnackBar====================================================
void successTopSnackBar(BuildContext context, String message,
    {int durationInMilliSeconds = snackbarDurationInMilliseconds}) {
  showTopSnackBar(Overlay.of(context), CustomSnackBar.success(message: message, maxLines: 5),
      displayDuration: Duration(milliseconds: durationInMilliSeconds));
}

//=================================Warning DialogBox====================================================
void warningTopSnackBar(BuildContext context, String message,
     {required VoidCallback discard,String? deleteText}) {
  showDialog(
    context: context,
    builder: (context) => CleanDialog(
      title: 'Warning',
      content: message,
      backgroundColor: const Color(0XFFbe3a2c),
      titleTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
      contentTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      actions: [

        CleanDialogActionButtons(
          actionTitle: deleteText ?? 'Discard',
          onPressed: () {
            discard();

          },
        ),
        CleanDialogActionButtons(
          actionTitle: 'Cancel',
          textColor: const Color(0XFF27ae61),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

