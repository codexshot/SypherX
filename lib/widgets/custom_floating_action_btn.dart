import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: primaryColor,
      child: const Icon(Icons.arrow_forward_outlined,color: Colors.black,),
    );
  }
}
