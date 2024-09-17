import 'package:flutter/material.dart';
import '../locale/app_localizations.dart';

extension StringExtension on String? {
  String get toCamelCase {
    if (this?.isEmpty ?? true) return '';
    if (this?.toLowerCase() == 'iphone') {
      return 'iPhone';
    }
    return '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase() ?? ''}';
  }

  bool get isNotNullOrEmpty => !StringUtils.isNullOrEmptyAfterTrim(this);

  bool get isNullOrEmpty => StringUtils.isNullOrEmptyAfterTrim(this);

  bool get isEmptyAfterTrim => StringUtils.isEmptyAfterTrim(this ?? '');

  bool get isNotEmptyAfterTrim => StringUtils.isNotEmptyAfterTrim(this ?? '');

  bool isEqualTo(String text) {
    return this?.toLowerCase().contains(text.toLowerCase()) ?? false;
  }
}

class StringUtils {
  static const String flickr = 'flickr';
  static const String signalHint = '• smithJ OR \n \t\t\t\t\t  • https://signal.me/smithJ';

  static bool isEmptyAfterTrim(String value) {
    return value.trim().isEmpty;
  }

  static bool isNotEmptyAfterTrim(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isNullOrEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return true;
    }
    return false;
  }

  static bool isNullOrEmptyAfterTrim(String? value) {
    if (value == null || value.trim().isEmpty) {
      return true;
    }
    return false;
  }

  static String getInitials(String displayName) {
    var buffer = StringBuffer('');
    if (!isEmptyAfterTrim(displayName)) {
      var nameList = displayName.trim().split(' ');
      if (nameList.length > 1) {
        if (nameList.first.isNotEmpty) buffer.write(nameList.first.substring(0, 1));
        if (nameList.elementAt(1).isNotEmpty) buffer.write(nameList.elementAt(1).substring(0, 1));
      } else {
        buffer.write(nameList.first.substring(0, 1));
      }
    } else {
      buffer.write('#');
    }

    return buffer.toString().toUpperCase();
  }

  static bool validUserName(String name) => isNotEmptyAfterTrim(name);

  static String cardFieldLabel(BuildContext context, dynamic field) {
    if (!StringUtils.isNullOrEmptyAfterTrim(field?.label)) {
      return field.label;
    }

    String labelKey = '';

    switch (field.type) {
      // case dbCompany:
      //   labelKey = 'lbl_company';
      //   break;
      // case dbDepartment:
      //   labelKey = 'lbl_department';
      //   break;
      // case dbDesignation:
      //   labelKey = 'lbl_designation';
      //   break;
      // case dbNotes:
      //   labelKey = 'lbl_notes';
      //   break;
      // case dbWebSites:
      //   labelKey = 'label_key_work';
      //   break;
      // case dbNickName:
      //   labelKey = 'lbl_nick_name';
      //   break;
      // case dbPhoneNumbers:
      //   labelKey = 'label_key_mobile';
      //   break;
      // case dbEmails:
      //   labelKey = 'label_key_home';
      //   break;
    }
    field.label = AppLocalizations.of(context).translate(labelKey);
    return field.label ?? '';
  }
}
