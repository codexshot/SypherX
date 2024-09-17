import 'package:flutter/material.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';
import 'common_text.dart';

class TButton extends StatelessWidget {
  final ButtonType buttonType;
  final void Function()? onPressed;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderStyle borderStyle;
  final Color borderColor;
  final double borderWidth;
  final double minbuttonWidth;
  final double minbuttonHeight;
  final double buttonRadius = 30.0;
  final double buttonElevation;
  final double verticalPadding;
  final double? horrizontalPadding;
  final TextStyle? textStyle;

  const TButton({
    Key? key,
    required this.buttonType,
    required this.onPressed,
    this.icon = Icons.access_alarm,
    this.text = '',
    this.backgroundColor = primaryDarkColor,
    this.foregroundColor = Colors.white,
    this.borderStyle = BorderStyle.none,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.minbuttonWidth = TSizeConstants.width20,
    this.minbuttonHeight = 0,
    this.horrizontalPadding = 15.0,
    this.verticalPadding = 15.0,
    this.textStyle,
    this.buttonElevation = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonType == ButtonType.iconButton
        ? IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
          )
        : TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              alignment: Alignment.center,
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                  (states) => EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horrizontalPadding ?? 15.0)),
              minimumSize: MaterialStateProperty.resolveWith<Size>((states) => Size(minbuttonWidth, minbuttonHeight)),
              elevation: MaterialStateProperty.resolveWith<double>((states) => buttonElevation),
              shadowColor: MaterialStateProperty.resolveWith<Color>((states) => backgroundColor),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                    side: BorderSide(
                      color: borderColor,
                      style: borderStyle,
                      width: borderWidth,
                    )),
                
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>((states) => BorderSide(
                    color: borderColor,
                    style: borderStyle,
                    width: borderWidth,
                  )),
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => backgroundColor),
              foregroundColor: MaterialStateProperty.resolveWith<Color>((states) => foregroundColor),
            ),
            child: TText(
              text,
              variant: TypographyVariant.title,
              style: textStyle ?? TextStyle(color: foregroundColor, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          );
  }
}

enum ButtonType {
  iconButton,
  textButton,
}
