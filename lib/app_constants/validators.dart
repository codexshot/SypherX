import 'package:flutter/material.dart';

import '../locale/app_localizations.dart';
import '../utils/enums.dart';


const String field_empty_text = "This field can't be empty";

class TValidator {
  static String? Function(String?)? buildValidators(BuildContext context, ChoiceEnum choice) {
    // final locale = AppLocalizations.of(context);

    String? emailValidators(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return "invalid_email";
      }

      if (!value.startsWith(RegExp(r'[A-Za-z]'))) {
        return "invalid_email";
      }
      if (value.length > 32) {
        return "email_must_be_less_than";
      }
      if (value.length < 6) {
        return "email_is_short";
      }
      return null;
    }

    String? nameValidators(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      if (value.length > 32) {
        return "name_must_be_less_than";
      }
      if (!value.startsWith(RegExp(r'[A-za-z]'))) {
        return "invalid_name";
      }
      if (value.length < 3) {
        return "name_should_be_at_least";
      }
      if (value.contains(RegExp(r'[0-9]'))) {
        return "invalid_name";
      }
      if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
        return "invalid_name";
      }
      return null;
    }

    String? phoneValidtors(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      if (value.length < 10) {
        return "phone_number_must_be_less";
      }
      if (value.contains(RegExp(r'[A-Z]')) || value.contains(RegExp(r'[a-z]')) || value.contains(".com")) {
        return "only_ten_digits";
      }
      if (value.length > 10) {
        return "invalid_phone_number";
      }
      if (!RegExp(r"[0-9]{10}").hasMatch(value)) {
        return "invalid_phone_number";
      }
      if (!value.startsWith(RegExp(r"[0-9]"))) {
        return "invalid_phone_number";
      }
      return null;
    }

    String? passwordValidators(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      return null;
    }

    String? confirmPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      } else if (value.length < 8) {
        return "password_less_than";
      }

      return null;
    }

    String? textValidator(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }

      return null;
    }

    String? optionalValidator(String? value) {
      return null;
    }

    String? addressValidator(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      if (value.length > 46) {
        return "text_cant_be_more";
      }

      return null;
    }

    String? forgotPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return field_empty_text;
      }
      //For Number
      if (value.startsWith(RegExp(r"[0-9]"))) {
        if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
          return "invalid_phone_number";
        }
        if (value.length < 10) {
          return "phone_number_must_be_less";
        }
        if (value.length > 10) {
          return "invalid_phone_number";
        }

        if (value.contains(RegExp(r'[A-Z]')) || value.contains(RegExp(r'[a-z]')) || value.contains(".com")) {
          return "only_ten_digits";
        }

        return null;
      }

      //for email
      if (!value.startsWith(RegExp(r'[A-Z][a-z]'))) {
        if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(value)) {
          return "invalid_email";
        }
        if (value.length > 32) {
          return "email_must_be_less_than";
        }
        if (value.length < 6) {
          return "email_is_short";
        }

        return null;
      }

      return null;
    }

    if (choice == ChoiceEnum.name) return nameValidators;
    if (choice == ChoiceEnum.email) return emailValidators;
    if (choice == ChoiceEnum.password) return passwordValidators;
    if (choice == ChoiceEnum.phone) return phoneValidtors;
    if (choice == ChoiceEnum.confirmPassword) return confirmPasswordValidators;
    if (choice == ChoiceEnum.reset) return forgotPasswordValidators;
    if (choice == ChoiceEnum.text) return textValidator;
    if (choice == ChoiceEnum.address) return addressValidator;
    if (choice == ChoiceEnum.optionalText) return optionalValidator;


    return nameValidators;
  }

// static bool isValidLink(String url) {
//   return AnyLinkPreview.isValidLink(url);
// }
}
