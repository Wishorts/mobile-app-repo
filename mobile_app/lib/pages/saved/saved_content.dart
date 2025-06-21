import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/components/custom_appbar.dart';
import 'package:mobile_app/getX/layout/layout_controller.dart';
import 'package:mobile_app/shared/theme/app_color.dart';

class SavedContentScreen extends StatelessWidget {
  SavedContentScreen({super.key});
  final LayoutController layoutController = Get.find<LayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppbar(
        title: "Bookmarks",
        onLeadingAction: () {
          layoutController.returnToHome();
        },
        actions: [],
        centerTitle: true,
        appbarColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: Column(children: [Text("Saved Content Screen is here!")]),
      ),
    );
  }
}
