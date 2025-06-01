import 'package:get/get.dart';
import 'package:mobile_app/backend/http/http_client.dart';
import 'package:mobile_app/data/api_response_model.dart';
import 'package:mobile_app/data/user_model.dart';
import 'package:mobile_app/service/shared_preferences_service.dart';

class AuthController extends GetxController {
  final HttpClient apiClient = HttpClient();
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<UserModel> currentUser = UserModel.empty().obs;
  RxString authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = false;
    loading.value = false;
    errorMessage.value = '';
  }

  String? get accessToken =>
      authToken.value.isNotEmpty ? authToken.value : null;

  Future<void> login(String email, String password) async {
    loading(true);
    errorMessage.value = '';

    final payload = {"email": email, "password": password};

    try {
      final ApiResponse response = await apiClient.post("/auth/login", payload);

      if (response.isSuccess && response.data != null) {
        errorMessage("");

        final UserModel user = UserModel.fromJson(response.data);

        currentUser(user);

        String authtoken = response.data.access_token;
        String refreshtoken = response.data.refresh_token;

        await SharedPreferencesService.saveAuthTokenToPrefs(authtoken);
        await SharedPreferencesService.saveRefreshTokenToPrefs(refreshtoken);

        authToken(authtoken);

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
