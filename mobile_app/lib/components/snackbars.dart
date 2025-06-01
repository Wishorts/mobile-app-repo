import 'package:flutter/material.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:mobile_app/shared/theme/text_styles.dart';
import 'package:mobile_app/shared/utils/constants/const_values.dart';

class DisplaySnackbar {
  late Color snackbarBackground;
  late BuildContext buildContext;
  late String content;

  Color get color => snackbarBackground;
  BuildContext get context => buildContext;
  String get message => content;

  void getSuccessSnackBar(BuildContext context, String message) {
    snackbarBackground = AppColors.successBackground;
    buildContext = context;
    content = message;
    showSnackBar();
  }

  void getErrorSnackBar(BuildContext context, String message) {
    snackbarBackground = AppColors.errorBackground;
    buildContext = context;
    content = message;
    showSnackBar();
  }

  void getWarningSnackBar(BuildContext context, String message) {
    snackbarBackground = AppColors.warningBackground;
    buildContext = context;
    content = message;
    showSnackBar();
  }

  void showSnackBar() {
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
