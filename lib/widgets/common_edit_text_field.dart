import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/app_text_style.dart';
import '../app_constants/size_constants.dart';
import '../app_constants/validators.dart';
import '../utils/enums.dart';



class TTextField extends StatelessWidget {
  const TTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText = '',
    required this.choice,
    this.maxLines = 1,
    this.textInputAction,
    this.isEnabled = true,
    this.contentPadding,
    this.borderColor,
    this.maxLengthEnforced = false,
    this.validations,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.isMandatory = false,
    this.textCapitalization,
  }) : super(key: key);

  final TextEditingController controller;
  final String label, hintText;
  final ChoiceEnum choice;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool isEnabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final bool maxLengthEnforced;
  final String? Function(String?)? validations;
  final Widget? suffixIcon;
  final Function? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool isMandatory;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      enabled: isEnabled,
      focusNode: focusNode,
      cursorColor: buttonColor,
      style: const TextStyle(color: Colors.black),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLength: maxLength,
      obscureText: (choice == ChoiceEnum.password || choice == ChoiceEnum.confirmPassword) ? true : false,
      maxLines: maxLines,
      keyboardType: keyboardType ?? getKeyboardType(choice),
      decoration: getInputDecoration(),
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: validations ?? validators(choice, context),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap != null
          ? () {
        onTap!();
      }
          : () {},
      // onChanged: (String? val) {},
    );
  }

  InputDecoration getInputDecoration() {
    return textFieldInputDecoration.copyWith(
      labelText: "$label${isMandatory ? ' *' : ''}",
      hintText: hintText,
      errorStyle: const TextStyle(height: 0.5),
      labelStyle: labelTextStyle,
      hintStyle: hintTextStyle,
      focusColor: buttonColor,
      contentPadding: contentPadding,
      suffixIcon: suffixIcon ?? const SizedBox(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: primaryDarkColor,
          width: TSizeConstants.borderFocusedWidth,
        ),
      ),
    );
  }

  TextInputType getKeyboardType(ChoiceEnum choice) {
    switch (choice) {
      case ChoiceEnum.name:
        return TextInputType.text;
      case ChoiceEnum.email:
        return TextInputType.emailAddress;
      case ChoiceEnum.password:
        return TextInputType.text;
      case ChoiceEnum.confirmPassword:
        return TextInputType.text;
      case ChoiceEnum.phone:
        return TextInputType.phone;
      case ChoiceEnum.reset:
        return TextInputType.emailAddress;
      case ChoiceEnum.address:
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }

  String? Function(String?)? validators(ChoiceEnum choice, BuildContext context) {
    return TValidator.buildValidators(context, choice);
  }
}
