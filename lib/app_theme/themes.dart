import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TempoThemes {
  const TempoThemes._();

  static const systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  );

  // static ThemeData lightTheme = ThemeData(
  //   primaryColor: Style.brightGray,
  //   backgroundColor: Style.gainsBoro,
  //   scaffoldBackgroundColor: Style.gainsBoro,
  //   brightness: Brightness.light,
  //   cardColor: Style.brightGray,
  //   appBarTheme: AppBarTheme(
  //     color: Style.gainsBoro,
  //     actionsIconTheme: IconThemeData(color: Style.darkGunmetal),
  //     iconTheme: IconThemeData(color: Style.darkGunmetal),
  //   ),
  //   bottomAppBarColor: Style.gainsBoro,
  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //     backgroundColor: Style.gainsBoro,
  //   ),
  //   floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
  //     foregroundColor: darkOrange,
  //     backgroundColor: darkOrange,
  //   ),
  //   fontFamily: Style.fontPoppins,
  //   hintColor: Style.brightHintGray,
  //   textSelectionTheme: TextSelectionThemeData(
  //     cursorColor: Style.darkGunmetal,
  //   ),
  //   textTheme: const TextTheme().copyWith(
  //     headline1: TextStyle(color: Style.darkGunmetal),
  //     headline2: TextStyle(color: Style.darkGunmetal),
  //     headline3: TextStyle(color: Style.darkGunmetal),
  //     headline4: TextStyle(color: Style.darkGunmetal),
  //     headline5: TextStyle(color: Style.darkGunmetal, height: Style.lineSpacing, fontWeight: FontWeight.w500),
  //     headline6: TextStyle(color: Style.darkGunmetal),
  //     subtitle1: TextStyle(color: Style.darkGunmetal),
  //     subtitle2: TextStyle(color: Style.darkGunmetal),
  //     bodyText1: TextStyle(color: Style.darkGunmetal),
  //     bodyText2: TextStyle(color: Style.darkGunmetal),
  //   ),
  //   colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Style.iris),
  // );
}
