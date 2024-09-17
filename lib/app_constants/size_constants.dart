//Screen size constants
import 'package:flutter/material.dart';

class TSizeConstants {
  static const double tempoDefaultPadding = padding20;
  static const double tempoDefaultChatTileHeight = height65;

  //Paddings
  static const double padding3 = 3;
  static const double padding5 = 5;
  static const double padding10 = 10;
  static const double padding16 = 16;
  static const double padding20 = 20;
  static const double padding24 = 24;
  static const double padding30 = 30;

  //Height/Width
  static const double height5 = 5;
  static const double height10 = 10;
  static const double height20 = 20;
  static const double height40 = 40;
  static const double height30 = 40;
  static const double height50 = 50;
  static const double height56 = 56;
  static const double height65 = 65;
  static const double height80 = 80;
  static const double height100 = 100;
  static const double height120 = 120;
  static const double height150 = 150;
  static const double height200 = 200;
  static const double height500 = 500;
  static const double width10 = 10;
  static const double width5 = 5;
  static const double width20 = 20;
  static const double width30 = 30;
  static const double width40 = 40;
  static const double width50 = 50;
  static const double width56 = 56;
  static const double width100 = 100;
  static const double width120 = 120;
  static const double width150 = 150;

  static const double defaultElevation = 10.0;
  static const double iconHeight16 = 16;
  static const double iconHeight20 = 20;
  static const double bottomSheetRadius = 20;

  //Radius
  static const double defaultRadius = radius12;

  static const double radius12 = 12.0;
  static const double radius15 = 15.0;
  static const double radius20 = 20.0;
  static const double avatarRadius25 = 25;
  static const double avatarRadius30 = 30;
  static const double avatarRadius40 = 40;
  static const double avatarRadius50 = 50;

  //Buttons/Text Field
  static const double tempoButtonHeight = 55;
  static const double tempoTextFieldHeight = height80;
  static const double textFieldBorderRadius = 10;
  static const int defaultNameTextLength24 = 24;
  static const double borderSideWidth = 0.5;
  static const double borderFocusedWidth = 1.5;
  static const double backgroundOpacity = 0.20;
  static const double borderOpacity = 0.50;
  static const double defaultReplyCardHeight = 60;
  static const double defaultChatScreenBottomPadding = 30;
  static const double collabButtonsHeight = 45;


  //Font Size

  static const double fontSize12 = 12;
  static const double fontSize14 = 14;
  static const double fontSize16 = 16;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;
  static const double fontSize24 = 24;

  //Icon size
  static const double iconSize18 = 18.0;
  static const double iconSize20 = 20.0;
  static const double iconSize23 = 23.0;
  static const double cicularIconSize = 28.0;
  static const double bigIconSize = 36.0;
  static const double tempoDefaultIconSize = 23.0;

  static const Size prefferdSize = Size.fromHeight(kToolbarHeight - 10);

  static double bodyHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.80;
  }

  static double getkeyboardSize(BuildContext context) {
    return MediaQuery.of(context).size.height * .38;
  }
}
