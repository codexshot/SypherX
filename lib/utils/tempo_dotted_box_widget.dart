import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';


class TempoDottedBoxWidget extends StatelessWidget {
  const TempoDottedBoxWidget({super.key, required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 1,
      radius: const Radius.circular(15),
      borderType: BorderType.RRect,
      child: child,
    ).ripple(onPressed);
  }
}
