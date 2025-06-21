import 'package:flutter/material.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:mobile_app/shared/theme/text_styles.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    required this.onLeadingAction,
    required this.actions,
    this.appbarColor,
    this.titleColor,
    this.titleTextStyle,
    this.centerTitle = false,
    this.leadingIcon,
  });

  final String title;
  final void Function() onLeadingAction;
  final List<Widget>? actions;
  final Color? appbarColor;
  final Color? titleColor;
  final TextStyle? titleTextStyle;
  final bool centerTitle;
  final Icon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appbarColor,
      centerTitle: centerTitle,
      title: Text(
        title,
        style:
            titleTextStyle ??
            TextStyles.appbarStyle.copyWith(color: titleColor),
      ),
      leading: IconButton(
        onPressed: onLeadingAction,
        icon:
            leadingIcon ??
            Icon(
              Icons.arrow_back_ios,
              color: titleColor ?? AppColors.textPrimary,
              size: 20,
            ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
