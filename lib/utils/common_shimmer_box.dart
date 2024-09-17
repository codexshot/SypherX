import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../app_constants/app_colors.dart';

class TShimmerBox extends StatelessWidget {
  const TShimmerBox({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      loop: 2,
      enabled: true,
      baseColor: greyShaded300,
      highlightColor: greyColor,
      child: child,
    );
  }
}
