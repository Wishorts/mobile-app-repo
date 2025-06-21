import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/components/custom_appbar.dart';
import 'package:mobile_app/getX/layout/layout_controller.dart';
import 'package:mobile_app/shared/theme/app_color.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final LayoutController layoutController = Get.find<LayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppbar(
        title: "Account",
        onLeadingAction: () {
          layoutController.returnToHome();
        },
        actions: [],
        centerTitle: true,
        appbarColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Account Screen is here!"),
          ],
        ),
      ),
    );
  }
}
