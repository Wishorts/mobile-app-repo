import 'package:get/get.dart';
import 'package:mobile_app/backend/http/http_client.dart';
import 'package:mobile_app/data/api_response_model.dart';

class AuthController extends GetxController {
  final HttpClient apiClient = HttpClient();
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = false;
    loading.value = false;
    errorMessage.value = '';
  }

  Future<void> login(String email, String password) async {
    loading(true);
    errorMessage.value = '';

    final payload = {"email": email, "password": password};

    try {
      final ApiResponse response = await apiClient.post("/auth/login", payload);

      if (response.isSuccess) {
        errorMessage("");
        loading(false);
        isLoggedIn(true);
      } else {
        isLoggedIn(false);
        loading(false);
        errorMessage(response.errorMessage);
      }
    } catch (e) {
      isLoggedIn(false);
      loading(false);
      errorMessage(e.toString());
    }
    loading(false);
  }
}
