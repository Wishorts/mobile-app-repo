import 'package:flutter/material.dart';
import 'package:mobile_app/components/custom_appbar.dart';
import 'package:mobile_app/getX/auth/auth_controller.dart';
import 'package:mobile_app/shared/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppbar(
        title: "INfacts",
        onLeadingAction: () {},
        actions: [],
        leadingIcon: Icon(Icons.menu, color: AppColors.textPrimary),
        centerTitle: true,
        appbarColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Home Screen is here!"),
            IconButton(
              onPressed: () async {
                await AuthController().logout();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
