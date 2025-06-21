import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/getX/layout/layout_controller.dart';
import 'package:mobile_app/pages/account/account_screen.dart';
import 'package:mobile_app/pages/home/home_screen.dart';
import 'package:mobile_app/pages/saved/saved_content.dart';
import 'package:mobile_app/shared/theme/app_color.dart';

class AppLayout extends StatelessWidget {
  AppLayout({super.key});

  final LayoutController controller = Get.find<LayoutController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int index = controller.currentPageIndex.value;

      return SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              switch (index) {
                case 0:
                  return HomeScreen();
                case 1:
                  return SavedContentScreen();
                case 2:
                  return AccountScreen();
                default:
                  return HomeScreen();
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: controller.currentPageIndex.value,
            onTap: (value) => controller.changeCurrentPageIndex(value),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(color: AppColors.textPrimary),
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                tooltip: "Home",
              ),
              BottomNavigationBarItem(
                label: "Saved",
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                tooltip: "Saved",
              ),
              BottomNavigationBarItem(
                label: "Account",
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                tooltip: "Account",
              ),
            ],
          ),
        ),
      );
    });
  }
}
