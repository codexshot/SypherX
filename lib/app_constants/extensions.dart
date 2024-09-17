import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

extension Unit8ListToFile on Uint8List {
  static Future<File> bytesToImage(Uint8List imgBytes) async {
    final tmpdir = await getTemporaryDirectory();

    final generatedTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    File file = await File('${tmpdir.path}/${generatedTimeStamp}image.png').create();

    file.writeAsBytesSync((imgBytes));
    return file;
  }
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(12))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                overlayColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.1)),
              ),
              onPressed: () {
                onPressed();
              },
              child: Container(),
            ),
          )
        ],
      );

  Widget onUserTap(Function onPressed) => GestureDetector(
        onTap: () {
          onPressed();
        },
        child: this,
      );
}
