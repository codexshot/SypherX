import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../app_constants/app_colors.dart';
import '../screen/create_guide/common_shimmer_box.dart';

class TempoCacheImage extends StatelessWidget {
  const TempoCacheImage({Key? key, required this.imageUrl, this.height, this.width, this.fit, this.errorWidget}) : super(key: key);

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => TShimmerBox(child: Container(height: height, width: width, color: greyShaded300)),
      errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  }
}
