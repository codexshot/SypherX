import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  late Map<String, String> _localizedValues;

  final RegExp _replaceArgRegex = RegExp(r'{}');


  Future load() async {
    String jsonStringValues = await rootBundle.loadString('lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value));
  }

  String translate(String key, {List<String>? args}) {
    String resources = _resolve(key);

    return _replaceArgs(resources, args);
  }

  String _resolve(String key) {
    final resource = _localizedValues[key];
    if (resource == null) {
      return key;
    }
    return resource;
  }

  String _replaceArgs(String resource, List<String>? args) {
    if (args == null || args.isEmpty) return resource;
    for (var argument in args) {
      resource = resource.replaceFirst(_replaceArgRegex, argument);
    }
    return resource;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode); // !Add Supported language here
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
