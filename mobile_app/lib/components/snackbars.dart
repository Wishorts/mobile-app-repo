import 'package:flutter/material.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:mobile_app/shared/theme/text_styles.dart';
import 'package:mobile_app/shared/utils/constants/const_values.dart';
import 'package:mobile_app/shared/utils/global_context.dart';

class DisplaySnackbar {
  late Color snackbarBackground;
  late String content;

  Color get color => snackbarBackground;
  String get message => content;

  void getSuccessSnackBar(String message) {
    snackbarBackground = AppColors.successBackground;
    content = message;
    showSnackBar();
  }

  void getErrorSnackBar(String message) {
    snackbarBackground = AppColors.errorBackground;
    content = message;
    showSnackBar();
  }

  void getWarningSnackBar(String message) {
    snackbarBackground = AppColors.warningBackground;
    content = message;
    showSnackBar();
  }

  void showSnackBar() {
    if (!GlobalContext.hasContext) return;

    final context = GlobalContext.context!;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            color: color,
          ),
          padding: const EdgeInsets.all(5),
          child: Text(
            message,
            style: TextStyles.snackbarText,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

final DisplaySnackbar snackbar = DisplaySnackbar();
