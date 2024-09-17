import 'dart:developer';

import 'package:flutter/material.dart';



const String languageCode = 'languageCode';
const String english = 'en';
const String hindi = 'hi';

//Add language here

const Map<String, String> languageList = {
  'en': 'English',
  'hi': 'Hindi',
  // Add another language here
};

Future<Locale> setLocale(String languageCode) async {
 //await SharedPrefrenceHelper().setLanguageCode(languageCode);
  return _locale(languageCode);
}

Future<String> getStringLocale() async {
  const String languageCode =  "en";
  // final String languageCode = await SharedPrefrenceHelper().getLanguageCode() ?? "en";
  return localeLanguage(languageCode);
}

String localeLanguage(String languageCode) {
  switch (languageCode) {
    case english:
      return english;
    case hindi:
      return hindi;

    //`Add another language here`
    default:
      return english;
  }
}

Future<Map> getListLocale() async {
  return languageList;
}

Future<Locale> getLocale() async {
  // final String languageCode = await SharedPrefrenceHelper().getLanguageCode() ?? "en";
  final String languageCode = "en";
  log(languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english);
    case hindi:
      return const Locale(hindi);

    //`Add another language here`
    default:
      return const Locale(english);
  }
}
