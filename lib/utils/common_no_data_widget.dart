import 'package:flutter/material.dart';
import '../app_constants/app_colors.dart';
import '../widgets/common_text.dart';


class TempoNoDataWidget extends StatelessWidget {
  const TempoNoDataWidget({Key? key, required this.text, this.backgroundColor})
      : super(key: key);

  final String text;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // SvgPicture.asset(noDataImage),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical:10,
                horizontal: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundColor ?? noDataDarkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TText(
              text,
              variant: TypographyVariant.h1,
              textAlign: TextAlign.center,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
