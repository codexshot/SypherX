import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:moonbase_explore/utils/date_utils.dart';

import '../app_constants/app_text_style.dart';
import '../model/rich_editor_models.dart';

mixin TempoRichEditorUtils {
  RegExp get regExMatchForUrl => RegExp(r"(#)\w+| @\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");

  RegExp get regExMatchForTaggedUser => RegExp(
      r'''([@[__]){4}([a-zA-Z0-9]+)([__\]]){3}([(__]){3}(([A-Z\u00C0-\u00D6\u00D8-\u00DE])([a-z\u00DF-\u00F6\u00F8-\u00FF '&-]+) ([A-Za-z\u00C0-\u00D6\u00D8-\u00DE\u00DF-\u00F6\u00F8-\u00FF '&-]+))([__)]){3}''');

  String getUidForTaggedUser(String displayText) {
    return displayText.split('__]')[0].split('[__')[1];
  }

  String readableTextWithTaggedUser(String displayText) {
    return '@${displayText.split('__](__')[1].split('__)')[0]}';
  }

  List<InlineSpan> getSmartTextSpans(String text, String timestamp, {bool smartFeatureOn = true, TextStyle? textStyle}) {
    final parser = EmojiParser();

    List<InlineSpan> widgets = <InlineSpan>[];
    final resultMatches = _getResultMatchesForURL(text);

    if (smartFeatureOn) {
      for (var result in resultMatches) {
        if (result.isUrl) {
          widgets.add(LinkTextSpan(
            onHashTagPressed: (text) {},
            text: result.text,
            style: TStyles.chatTextStyle.copyWith(color: Colors.blue, decoration: TextDecoration.underline).merge(textStyle),
          ));
        } else {
          if (parser.hasEmoji(text)) {
            widgets.add(TextSpan(
              text: result.text,
              style: TStyles.chatTextStyle.copyWith(fontSize: 40).merge(textStyle),
            ));
          } else {
            _getTexts(result.text, widgets, textStyle: textStyle);
          }
        }
      }
      widgets.add(
        TextSpan(text: timestamp.displayTimeInHourSecond(), style: const TextStyle(color: Colors.transparent)),
      );
    } else {
      _getTexts(text, widgets, smartFeatureOn: false, textStyle: textStyle);
    }
    return widgets;
  }

  //getPlainText
  void _getTexts(final String text, List<InlineSpan> widgets, {bool smartFeatureOn = true, TextStyle? textStyle}) {
    final resultMatches = _getTaggedUserMatchsList(text);
    for (var result in resultMatches) {
      if (result.taggedUser) {
        String displayText = result.text;
        final uid = getUidForTaggedUser(displayText);
        final text = readableTextWithTaggedUser(displayText);
        if (smartFeatureOn) {
          widgets.add(TaggedUserTextSpan(
            onPressed: () {
              log(uid);
            },
            text: text,
            style: TStyles.chatTextStyle.copyWith(color: Colors.blue).merge(textStyle),
          ));
        } else {
          widgets.add(TextSpan(
            text: text,
            style: TStyles.chatTextStyle.merge(textStyle),
          ));
        }
      } else {
        widgets.add(TextSpan(
          text: result.text,
          style: TStyles.chatTextStyle.merge(textStyle),
        ));
      }
    }
  }

  //Returns the list of all the matches for URL
  List<ResultMatch> _getResultMatchesForURL(String text) {
    Iterable<Match> matches = regExMatchForUrl.allMatches(text);
    List<ResultMatch> resultMatches = <ResultMatch>[];
    int start = 0;
    for (Match match in matches) {
      if (match.group(0)!.isNotEmpty) {
        if (start != match.start) {
          ResultMatch result1 = ResultMatch();
          result1.isUrl = false;
          result1.text = text.substring(start, match.start);
          resultMatches.add(result1);
        }

        ResultMatch result2 = ResultMatch();
        result2.isUrl = true;
        result2.text = match.group(0)!;
        resultMatches.add(result2);
        start = match.end;
      }
    }
    if (start < text.length) {
      ResultMatch result1 = ResultMatch();
      result1.isUrl = false;
      result1.text = text.substring(start);
      resultMatches.add(result1);
    }
    return resultMatches;
  }

  //Get result matches for tagged user
  List<ResultMatch> _getTaggedUserMatchsList(String text) {
    int start = 0;
    final matches = regExMatchForTaggedUser.allMatches(text);
    List<ResultMatch> resultMatches = <ResultMatch>[];

    for (Match match in matches) {
      if (match.group(0)!.isNotEmpty) {
        if (start != match.start) {
          ResultMatch result1 = ResultMatch();
          result1.taggedUser = false;
          result1.isUrl = false;
          result1.text = text.substring(start, match.start);
          resultMatches.add(result1);
        }

        ResultMatch result2 = ResultMatch();
        result2.taggedUser = true;
        result2.isUrl = false;
        result2.text = match.group(0)!;
        resultMatches.add(result2);
        start = match.end;
      }
    }
    if (start < text.length) {
      ResultMatch result1 = ResultMatch();
      result1.taggedUser = false;
      result1.isUrl = false;
      result1.text = text.substring(start);
      resultMatches.add(result1);
    }

    return resultMatches;
  }

}
