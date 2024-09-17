import 'dart:io';

import 'package:flutter/material.dart';

class TempoDisplayImageFromFile extends StatelessWidget {
  const TempoDisplayImageFromFile(this.localPath, {super.key});

  final String localPath;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(localPath),
      fit: BoxFit.cover,
      height: 600,
      width: 300,
    );
  }
}
