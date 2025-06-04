import 'package:get/get.dart';
import 'package:mobile_app/backend/http/http_client.dart';
import 'package:mobile_app/data/api_response_model.dart';
import 'package:mobile_app/data/user_model.dart';
import 'package:mobile_app/pages/auth/login_page.dart';
import 'package:mobile_app/service/shared_preferences_service.dart';
import 'package:mobile_app/shared/utils/helpers.dart';
import 'package:mobile_app/shared/utils/logger.dart';

class AuthController extends GetxController {
  late final HttpClient apiClient;
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<UserModel> currentUser = UserModel.empty().obs;
  RxString authToken = ''.obs;
  RxString refreshToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    apiClient = HttpClient(authController: this);
    isLoggedIn.value = false;
    loading.value = false;
    errorMessage.value = '';
  }

  String? get accessToken =>
      authToken.value.isNotEmpty ? authToken.value : null;
  String? get refreshTokenValue =>
      refreshToken.value.isNotEmpty ? refreshToken.value : null;

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
        refreshToken(refreshtoken);

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
      AppLogger.logError("Register Error", e.toString());
    }
    loading(false);
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String dateOfBirth,
    required String password,
  }) async {
    loading(true);
    errorMessage.value = '';

    final payload = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile_number": mobile,
      "age": calculateAge(DateTime.parse(dateOfBirth)),
      "password": password,
    };

    try {
      final ApiResponse response = await apiClient.post(
        "/auth/register",
        payload,
      );

      if (response.isSuccess) {
        errorMessage("");
        loading(false);
        Get.offAll(
          () => LoginPage(),
        ); // Navigate to login page after successful registration
      } else {
        loading(false);
        errorMessage(response.errorMessage);
      }
    } catch (e) {
      loading(false);
      AppLogger.logError("Register Error", e.toString());
    }
  }

  Future<bool> getNewAccessToken() async {
    try {
      final ApiResponse response = await apiClient.post(
        "/refresh-access",
        null,
        cookies: {'refreshToken': refreshTokenValue ?? ''},
      );

      if (response.isSuccess && response.data != null) {
        authToken(response.data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
