
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextSpan extends TextSpan {
  final Function(String)? onHashTagPressed;
  LinkTextSpan({required TextStyle style, required String text, this.onHashTagPressed})
      : super(
            style: style,
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (onHashTagPressed != null && (text.substring(0, 1).contains("#") || text.substring(0, 1).contains("#"))) {
                  onHashTagPressed(text);
                } else {
                  await launchUrl(Uri.parse(text));
                }
              });
}

class TaggedUserTextSpan extends TextSpan {
  final Function()? onPressed;
  TaggedUserTextSpan({required TextStyle style, required String text, this.onPressed})
      : super(
            style: style,
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (onPressed != null) {
                  onPressed();
                } else {
                }
              });
}

class ResultMatch {
  late bool isUrl;
  late String text;
  late bool taggedUser;
}
