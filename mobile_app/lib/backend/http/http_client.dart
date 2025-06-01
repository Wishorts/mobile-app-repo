import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/data/api_response_model.dart';
import 'package:mobile_app/getX/auth/auth_controller.dart';
import 'package:path/path.dart';

import 'package:mobile_app/shared/utils/exceptions.dart';
import 'package:mobile_app/shared/utils/logger.dart';

class HttpClient {
  final AuthController authController = Get.find<AuthController>();
  String baseUrl = 'http://192.168.0.105:3000/api/v1';
  String authToken = '';

  void getAuthToken() {
    final String? token = authController.accessToken;
    authToken = token ?? '';
  }

  // Default headers
  Map<String, String> getHeaders() {
    getAuthToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    };
  }

  Map<String, String> mergeHeaders(Map<String, String>? customHeaders) {
    return {...getHeaders(), if (customHeaders != null) ...customHeaders};
  }

  Future<ApiResponse> get<T>(
    String endpoint,
    String params, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint?$params');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint?$params'),
      headers: mergeHeaders(headers),
    );

    AppLogger.logInfo("Response JSON", response.body);

    return _handleResponse(response);
  }

  Future<ApiResponse> post<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> put<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> patch<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> postWithMultipart<T>(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    Uri uri = Uri.parse(url);

    AppLogger.logInfo("Request URL", url);

    var request = http.MultipartRequest('POST', uri);

    if (data.containsKey('file') && data['file'] is File) {
      File file = data['file'];
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: basename(file.path),
      );

      request.files.add(multipartFile);
    }

    data.forEach((key, value) {
      if (key != 'file') {
        request.fields[key] = value.toString();
      }
    });

    request.headers.addAll(mergeHeaders(headers));

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  ApiResponse _handleResponse<T>(http.Response response) {
    AppLogger.logInfo("HttpService Response ${response.statusCode}", "");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic responseData = json.decode(response.body);
      return ApiResponse(
        isSuccess: true,
        data: responseData,
        errorMessage: null,
      );
    } else if (response.statusCode == 404) {
      throw NoDataToShowException("No data to show");
    } else {
      final dynamic responseData = json.decode(response.body);
      if (response.statusCode >= 500) {
        throw InternalErrorException(responseData['message']);
      } else if (response.statusCode == 401) {
        throw InvalidCredentialsException(responseData['message']);
      } else {
        throw Exception(responseData['message']);
      }
    }
  }
}

/*  


  // Temp Change to be removed aftr versioning is sorted
  Future<T> getV2<T>(
    String endpoint,
    String params, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    String base = baseUrl.replaceAll('v1', 'v2');
    AppLogger.logInfo("Request URL", '$base/$endpoint?$params');

    final response = await http.get(
      Uri.parse('$base/$endpoint?$params'),
      headers: mergeHeaders(headers),
    );

    AppLogger.logInfo("Response JSON", response.body);

    return _handleResponse(response);
  }

  Future<T> postV2<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    String base = baseUrl.replaceAll('v1', 'v2');
    AppLogger.logInfo("Request URL", '$base/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.post(
      Uri.parse('$base/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<T> patchV2<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    String base = baseUrl.replaceAll('v1', 'v2');
    AppLogger.logInfo("Request URL", '$base/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.patch(
      Uri.parse('$base/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<T> putV2<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    String base = baseUrl.replaceAll('v1', 'v2');
    AppLogger.logInfo("Request URL", '$base/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.put(
      Uri.parse('$base/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }
 */
