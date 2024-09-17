
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

showLoader(BuildContext context) {
  OverlayLoadingProgress.start(context, widget: Lottie.asset('assets/lottie/image_process.json'));
}

hideLoader(BuildContext context) {
  OverlayLoadingProgress.stop();
}

showCompressLoader(BuildContext context) {
  OverlayLoadingProgress.start(context,
      widget:  Lottie.asset('assets/lottie/image_process.json'));
}
