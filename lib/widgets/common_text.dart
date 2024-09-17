import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/app_text_style.dart';


class TText  extends StatelessWidget{
  final String data;
  final TypographyVariant? variant;

  final Locale? locale;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;

  const TText(
      this.data, {
        @required this.variant,
        Key? key,
        this.locale,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.semanticsLabel,
        this.softWrap,
        this.strutStyle,
        this.style,
        this.textAlign,
        this.textDirection,
        this.textScaleFactor,
        this.textWidthBasis,
      }) : super(key: key);

  static TextStyle? styleForVariant(
      BuildContext context, TypographyVariant variant,
      {TextStyle overrides = const TextStyle()}) {
    TextStyle style;
    // final theme = Theme.of(context);
    switch (variant) {
      case TypographyVariant.title:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          fontFamily: TStyles.tempoDefaultFontFamily,
          height: 1.2,
          letterSpacing: 0.0,
        );
        break;
      case TypographyVariant.titleSmall:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.header:
        style = const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,


        );
        break;
      case TypographyVariant.headerSmall:
        style = const TextStyle(
          color: lightBlack,
          fontWeight: FontWeight.w400,
          fontSize: 18,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.h1:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.0,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.h2:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.h3:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.h4:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 10,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.body:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.button:
        style = const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
          letterSpacing: 0.5,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.bodySmall:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 10,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.bodyLarge:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 15,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;

    //TODO: REPLACE THESE
      case TypographyVariant.newh1:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w300,
          fontSize: 96,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: -1.5,
        );
        break;
      case TypographyVariant.newh2:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w300,
          fontSize: 60,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: -0.5,
        );
        break;
      case TypographyVariant.newh3:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 48,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.0,
        );
        break;
      case TypographyVariant.newh4:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 34,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.25,
        );
        break;
      case TypographyVariant.newh5:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 24,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.0,
        );
        break;
      case TypographyVariant.newh6:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.15,
        );
        break;
      case TypographyVariant.subtitle:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.15,
        );
        break;
      case TypographyVariant.subtitleSmall:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.10,
        );
        break;

      case TypographyVariant.newBody:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.2,
          letterSpacing: 0.5,
          fontFamily: TStyles.tempoDefaultFontFamily,
        );
        break;
      case TypographyVariant.newBodySmall:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.25,
        );
        break;
      case TypographyVariant.newButton:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 1.25,
        );
        break;
      case TypographyVariant.caption:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 12,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 0.40,
        );
        break;

      case TypographyVariant.overline:
        style = const TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 10,
          height: 1.2,
          fontFamily: TStyles.tempoDefaultFontFamily,
          letterSpacing: 1.5,
        );
        break;
    }

    return style.merge(overrides);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
    TText.styleForVariant(context, variant!)!.merge(this.style);
    return Text(
      data,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      // softWrap: softWrap,
      style: style,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      // locale: locale,
      maxLines: maxLines,
      // strutStyle: this.strutStyle,
      // textDirection: this.textDirection,
    );
  }
}

enum TypographyVariant {
  title,
  titleSmall,
  header,
  headerSmall,
  h1,
  h2,
  h3,
  h4,
  body,
  bodyLarge,
  button,
  newh1,
  newh2,
  newh3,
  newh4,
  newh5,
  newh6,
  subtitle,
  subtitleSmall,
  bodySmall,
  newBody,
  newBodySmall,
  newButton,
  caption,
  overline,
}
