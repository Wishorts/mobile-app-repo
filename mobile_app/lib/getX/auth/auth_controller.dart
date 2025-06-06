import 'package:get/get.dart';
import 'package:mobile_app/backend/http/http_client.dart';
import 'package:mobile_app/components/snackbars.dart';
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

  Future<bool> login(String email, String password) async {
    loading(true);
    errorMessage.value = '';

    final payload = {"email": email, "password": password};

    try {
      final ApiResponse response = await apiClient.post("/auth/login", payload);

      if (response.isSuccess && response.data != null) {
        errorMessage("");

        String authtoken = response.data['access_token'];
        String refreshtoken = response.data['refresh_token'];

        final UserModel user = UserModel.fromJson(response.data['user']);

        currentUser(user);

        await SharedPreferencesService.saveAuthTokenToPrefs(authtoken);
        await SharedPreferencesService.saveRefreshTokenToPrefs(refreshtoken);

        authToken(authtoken);
        refreshToken(refreshtoken);

        loading(false);
        isLoggedIn(true);
        return true;
      } else {
        isLoggedIn(false);
        loading(false);
        errorMessage(response.errorMessage);
        snackbar.getErrorSnackBar(
          response.errorMessage ?? "An error occurred during login",
        );
        return false;
      }
    } catch (e) {
      isLoggedIn(false);
      loading(false);
      errorMessage("An error occurred during login. Please try again.");
      snackbar.getErrorSnackBar(
        "An error occurred during login. Please try again.",
      );
      AppLogger.logError("Login Error", e.toString());
      return false;
    }
  }

  Future<bool> register({
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
        snackbar.getSuccessSnackBar("Registration Successful!");
        return true;
      } else {
        loading(false);
        errorMessage(response.errorMessage);
        snackbar.getErrorSnackBar(
          response.errorMessage ?? "An error occurred during registration",
        );
        return false;
      }
    } catch (e) {
      loading(false);
      errorMessage("An error occurred during registration. Please try again.");
      snackbar.getErrorSnackBar(
        "An error occurred during registration. Please try again.",
      );
      AppLogger.logError("Register Error", e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    loading(true);
    errorMessage.value = '';

    try {
      await SharedPreferencesService.clearAllPrefs();
      dispose();
      loading(false);
      Get.offAll(() => LoginPage());
    } catch (e) {
      loading(false);
      errorMessage("An error occurred during logout. Please try again.");
      snackbar.getErrorSnackBar(
        "An error occurred during logout. Please try again.",
      );
      AppLogger.logError("Logout Error", e.toString());
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
      AppLogger.logError("Refresh Token Error", e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    isLoggedIn(false);
    authToken('');
    refreshToken('');
    currentUser(UserModel.empty());
    super.dispose();
  }
}
