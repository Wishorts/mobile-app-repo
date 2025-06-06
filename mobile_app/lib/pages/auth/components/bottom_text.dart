import 'package:flutter/material.dart';
import 'package:mobile_app/shared/theme/app_color.dart';

class BottomText extends StatelessWidget {
  const BottomText({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onPress,
  });

  final String text;
  final String buttonText;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(color: AppColors.textOnPrimary)),
        TextButton(
          onPressed: onPress,
          child: Text(
            buttonText,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
