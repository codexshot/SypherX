import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';
import 'common_text.dart';


class TempoChangeButton extends StatelessWidget {
  const TempoChangeButton({super.key, required this.text, this.onPressed});
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        color: Colors.grey[300],
        child: TText(
          text,
          variant: TypographyVariant.h1,
          style: const TextStyle(color: primaryDarkColor),
        ),
      ),
    );
  }
}
