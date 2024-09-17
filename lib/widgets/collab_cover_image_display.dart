import 'dart:io';

import 'package:flutter/material.dart';


import 'TempoCacheImage.dart';

class CollabCoverImageDisplay extends StatelessWidget {
  const CollabCoverImageDisplay({super.key, this.localCoverImage, this.imageUrl});

  final String? localCoverImage;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const fit = BoxFit.cover;

    return imageUrl != null && imageUrl!.isNotEmpty
        ? TempoCacheImage(imageUrl: imageUrl!, fit: fit)
        : localCoverImage != null && localCoverImage!.isNotEmpty
            ? Image.file(File(localCoverImage!), fit: fit)
            : IconButton(onPressed: (){}, icon: Icon(Icons.person));
  }
}
