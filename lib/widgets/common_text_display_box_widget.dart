import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/app_text_style.dart';
import '../utils/rich_editor_utils.dart';
import 'common_text.dart';


class TempoTextDisplayBoxWidget extends StatefulWidget {
  const TempoTextDisplayBoxWidget({super.key, required this.text, this.style, this.maximumLinesToCheck = 3});

  final String text;
  final TextStyle? style;
  final int maximumLinesToCheck;

  @override
  State<TempoTextDisplayBoxWidget> createState() => _TempoTextDisplayBoxWidgetState();
}

class _TempoTextDisplayBoxWidgetState extends State<TempoTextDisplayBoxWidget> with TempoRichEditorUtils {
  int maxLines = 0;

  @override
  void initState() {
    super.initState();
    maxLines = widget.maximumLinesToCheck;
  }

  Widget _smartTextSubject(String text) {
    return RichText(
      maxLines: maxLines,
      text: TextSpan(
        children: getSmartTextSpans(
          text,
          '',
          textStyle: const TextStyle(
            color: secondaryColor,
            fontWeight: FontWeight.normal,
            fontSize: 12,
            height: 1.2,
            fontFamily: TStyles.tempoDefaultFontFamily,
            letterSpacing: 0.15,
          ).merge(widget.style),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        TextSpan textSpan = TextSpan(text: widget.text);
        final TextPainter textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.maximumLinesToCheck,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _smartTextSubject(widget.text),
              const SizedBox(height: 2),
              TText(
                maxLines == widget.maximumLinesToCheck ? 'Read More' : 'Read less',
                variant: TypographyVariant.h2,
                style: const TextStyle(color: primaryDarkColor, fontSize: 12),
              ).onUserTap(() {
                setState(() {
                  if (maxLines == widget.maximumLinesToCheck) {
                    maxLines = 100;
                  } else {
                    maxLines = widget.maximumLinesToCheck;
                  }
                });
              }),
            ],
          );
        } else {
          return _smartTextSubject(widget.text);
        }
      },
    );
  }
}
