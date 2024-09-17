import 'dart:developer';

import 'package:flutter/material.dart';

import '../../app_constants/app_colors.dart';
import '../../app_constants/app_text_style.dart';
import '../../app_constants/size_constants.dart';
import '../../app_constants/validators.dart';
import '../../utils/enums.dart';


class DescriptionTextField extends StatefulWidget {
  const DescriptionTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.lableText,
    this.buildValidator = true,  this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final String lableText;
  final bool buildValidator;
  final VoidCallback? onTap;

  @override
  State<DescriptionTextField> createState() => _DescriptionTextBoxState();
}

class _DescriptionTextBoxState extends State<DescriptionTextField> {
  int? _maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      minLines: 1,
      maxLines: _maxLines,
      keyboardType: TextInputType.multiline,
      onTap: widget.onTap,
      // validator: validators(context),asd
      onChanged: (value) {
        // dynamically adjust the height of the text field based on the amount of text entered by the user
        final textPainter = TextPainter(
          text: TextSpan(text: value, style: TStyles.chatTextStyle),
          maxLines: null,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: MediaQuery.of(context).size.width);
        final lineCount = textPainter.computeLineMetrics().length;

        log('lineCount: $lineCount');

        if (lineCount >= 5) {
          setState(() {
            _maxLines = 5;
          });
        }
      },
      validator: widget.buildValidator
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some description';
        }
        return null;
      }
          : null,
      cursorColor: primaryDarkColor,
      style: const TextStyle(color: Colors.black),
      decoration: textFieldInputDecoration.copyWith(
        labelText: widget.lableText,
        hintText: widget.hintText,
        errorStyle: const TextStyle(height: 0.5),
        labelStyle: labelTextStyle,
        hintStyle: hintTextStyle,
        focusColor: primaryColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizeConstants.textFieldBorderRadius),
          borderSide: const BorderSide(
            color: primaryColor,
            width: TSizeConstants.borderFocusedWidth,
          ),
        ),
      ),
    );
  }

  String? Function(String?)? validators(BuildContext context) {
    return TValidator.buildValidators(context, ChoiceEnum.text);
  }
}
