import 'package:flutter/material.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_text_style.dart';
import 'common_text.dart';

class THeaderTitle extends StatelessWidget {
  const THeaderTitle(
    this.text, {
    Key? key,
    this.color,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return TText(
      text,
      variant: TypographyVariant.title,
      style: titleTextStyle.copyWith(color: color ?? lightBlack, fontSize: 20),
      textAlign: textAlign,
      maxLines: 3,
    );
  }
}

class TSubtitle extends StatelessWidget {
  final String text;
  final Color? color;

  const TSubtitle(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TText(
      text,
      variant: TypographyVariant.h3,
      style: TextStyle(color: color ?? greyColor),
      maxLines: 3,
    );
  }
}
