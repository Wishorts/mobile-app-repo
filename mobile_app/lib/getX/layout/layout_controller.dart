import 'package:get/get.dart';

class LayoutController extends GetxController {
  RxBool loading = false.obs;
  RxString errorMessage = ''.obs;

  RxInt currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentPageIndex(0);
  }

  void changeCurrentPageIndex(int index) {
    currentPageIndex(index);
  }

  void returnToHome() {
    currentPageIndex(0);
  }
}
