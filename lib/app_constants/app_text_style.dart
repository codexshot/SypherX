import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';
import 'package:moonbase_explore/app_constants/size_constants.dart';

import 'app_colors.dart';

class TStyles {
  static const tempoDefaultFontFamily = fontAlata;

  static const fontAlata = 'Alata';
  static const fontPacifico = 'Pacifico';
  static const fontRoboto = 'Roboto';

  static TextStyle text16(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400, fontFamily: fontAlata);
  }

  static TextStyle appTitleTextStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w500, color: Colors.white, fontFamily: fontAlata);
  }

  static ThemeData dateTimePickerTheme(BuildContext context) => Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryDarkColor,
          onPrimary: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryDarkColor,
          ),
        ),
      );

  static const floatingLabelTextStyle = TextStyle(
    color: primaryDarkColor,
    fontWeight: FontWeight.w400,
    fontSize: TSizeConstants.fontSize16,
    fontFamily: fontAlata,
    height: 1,
    letterSpacing: 0.0,
  );

  static Decoration? authBoxDecoration() {
    return const BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(TSizeConstants.avatarRadius30),
        topRight: Radius.circular(TSizeConstants.avatarRadius30),
      ),
    );
  }

  static const borderRadius30 = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  static final bottomNavBarBoxShadows = [
    BoxShadow(
      color: greyColor.withOpacity(0.2),
      offset: const Offset(0, -2),
      blurRadius: 1.0,
      spreadRadius: 1.0,
    ),
  ];

  //Chat BNB
  static const chatBnbPadding = EdgeInsets.only(bottom: 20, top: 0, left: 10, right: 10);
  static final chatBnbDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: primaryColor),
    borderRadius: BorderRadius.circular(25),
  );

  static final chatBnbBorderDecoration =
      OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: const BorderSide(color: primaryColor));

  static const chatTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.2,
    fontFamily: 'Alata',
  );

  static InputDecoration chatRoomSearchFieldDecoration = InputDecoration(
    hintText: 'Search....',
    hintStyle: hintTextStyle.copyWith(fontSize: 14, color: secondaryColor),
    labelStyle: labelTextStyle,
    border: InputBorder.none,
  );

  static Theme dtTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryDarkColor,
          ),
        ),
      ),
      child: child!,
    );
  }

  static InputBorder textFieldBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
    borderSide: const BorderSide(
      color: primaryDarkColor,
      width: TSizeConstants.borderSideWidth,
    ),
  );

  static BoxShadow imageShadow = BoxShadow(
      blurRadius: 1.0, color: greyShaded300.withOpacity(0.7), spreadRadius: 1.0, offset: const Offset(0.1, 1.0));
}

const appTitleTextStyle = TextStyle(
  fontSize: TSizeConstants.fontSize16,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

const textFieldW600Size12Poppins = TextStyle(
  fontSize: TSizeConstants.fontSize12,
  fontWeight: FontWeight.w600,
  fontFamily: 'Poppins',
  color: Colors.white,
);
const appSubTitleTextStyle = TextStyle(
  fontSize: TSizeConstants.fontSize14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const prefixTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.grey,
);

const suffixTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

const hintTextStyle = TextStyle(
  fontSize: TSizeConstants.fontSize14,
  color: greyColor,
  fontFamily: 'Alata',
  fontWeight: FontWeight.w400,
);

const titleTextStyle = TextStyle(
  color: lightBlack,
  fontWeight: FontWeight.w700,
  fontSize: TSizeConstants.fontSize24,
  fontFamily: 'Alata',
  height: 1,
  letterSpacing: 0.0,
);

const labelTextStyle = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.w400,
  fontSize: TSizeConstants.fontSize16,
  fontFamily: 'Alata',
  height: 1,
  letterSpacing: 0.0,
);

InputDecoration textFieldInputDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  labelStyle: labelTextStyle,
  floatingLabelStyle: TStyles.floatingLabelTextStyle,
  filled: true,
  fillColor: Colors.white,
  hintStyle: hintTextStyle,
  contentPadding: const EdgeInsets.symmetric(horizontal: TSizeConstants.padding20, vertical: TSizeConstants.padding20),
  border: TStyles.textFieldBorderStyle,
  focusedBorder: TStyles.textFieldBorderStyle
      .copyWith(borderSide: const BorderSide(color: primaryDarkColor, width: TSizeConstants.borderFocusedWidth)),
  enabledBorder: TStyles.textFieldBorderStyle,
);

InputDecoration searchLocationInputDecoration(
        String formattedText, bool isSearchTextEmpty, TextEditingController controller) =>
    InputDecoration(
      hintText: formattedText.isNotEmpty ? formattedText : 'Search address', //TODO: ADD LOCAE
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: primaryDarkColor,
          width: TSizeConstants.borderFocusedWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: primaryDarkColor,
          width: TSizeConstants.borderFocusedWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: primaryDarkColor,
          width: TSizeConstants.borderFocusedWidth,
        ),
      ),
      hintStyle: hintTextStyle,
      contentPadding: const EdgeInsets.only(left: 15, top: 15.0),
      suffixIcon: Container(
        height: 35,
        width: 35,
        margin: const EdgeInsets.only(top: 6.0),
        child: GestureDetector(
          child: isSearchTextEmpty
              ? const Icon(
                  Icons.search,
                  color: primaryDarkColor,
                )
              : const Icon(
                  Icons.clear,
                  color: primaryDarkColor,
                ).onUserTap(() {
                  controller.clear();
                }),
        ),
      ),
    );

TextStyle get greyText14 => const TextStyle(
      color: greyColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 1.2,
      fontFamily: TStyles.tempoDefaultFontFamily,
    );

TextStyle get titleText20 => const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      fontFamily: TStyles.tempoDefaultFontFamily,
    );
