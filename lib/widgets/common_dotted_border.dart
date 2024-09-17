import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';

class TDottedBorder extends StatelessWidget {
  const TDottedBorder({super.key, required this.child, this.onTap});
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.30,
        // width: MediaQuery.of(context).size.width * 0.40,
        child: DottedBorder(
          padding: const EdgeInsets.all(5),
          color: secondaryColor,
          strokeWidth: 1,
          radius: const Radius.circular(15),
          borderType: BorderType.RRect,
          dashPattern: const [8, 4, 5],
          child: child,
        ),
      ),
    );
  }
}
