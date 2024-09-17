import 'package:flutter/material.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import '../app_constants/app_colors.dart';

class QuizButton extends StatelessWidget {
  final VoidCallback onPressed;
  const QuizButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const TText(
          "Add Quiz",
          variant: TypographyVariant.button,
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
