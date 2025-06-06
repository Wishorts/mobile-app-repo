import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/data/api_response_model.dart';
import 'package:mobile_app/getX/auth/auth_controller.dart';
import 'package:mobile_app/shared/utils/exceptions.dart';
import 'package:path/path.dart';

import 'package:mobile_app/shared/utils/logger.dart';

class HttpClient {
  final AuthController authController;
  late final String baseURL;
  late final String rootURL;
  String authToken = '';

  HttpClient({required this.authController}) {
    baseURL = dotenv.env["BASE_URL"] ?? '';
    rootURL = '$baseURL/api/v1';
  }

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

  Future<ApiResponse> _retryOnAuthFailure(
    Future<ApiResponse> Function() requestFn,
  ) async {
    try {
      return await requestFn(); //first call
    } on UnauthorizedUserException {
      final authRefreshed = await authController.getNewAccessToken();
      if (authRefreshed) {
        // retry the same request
        return await requestFn();
      } else {
        rethrow; //logout if still fails
      }
    }
  }

  Future<ApiResponse> get<T>(
    String endpoint,
    String params, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _retryOnAuthFailure(() async {
      AppLogger.logInfo("Request URL", '$rootURL$endpoint?$params');

      final response = await http.get(
        Uri.parse('$rootURL$endpoint?$params'),
        headers: mergeHeaders(headers),
      );

      AppLogger.logInfo("Response JSON", response.body);

      return _handleResponse(response);
    });
  }

  Future<ApiResponse> post<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
    Map<String, String>? cookies,
  }) {
    return _retryOnAuthFailure(() async {
      AppLogger.logInfo("Request URL", '$rootURL$endpoint');

      final Map<String, String> allHeaders = mergeHeaders(headers);

      if (cookies != null && cookies.isNotEmpty) {
        final cookieString = cookies.entries
            .map((e) => '${e.key}=${e.value}')
            .join('; ');
        allHeaders['Cookie'] = cookieString;
      }

      final response = await http.post(
        Uri.parse('$rootURL$endpoint'),
        body: jsonEncode(data),
        headers: allHeaders,
      );

      return _handleResponse(response);
    });
  }

  Future<ApiResponse> put<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) {
    return _retryOnAuthFailure(() async {
      AppLogger.logInfo("Request URL", '$rootURL$endpoint');

      final response = await http.put(
        Uri.parse('$rootURL$endpoint'),
        body: jsonEncode(data),
        headers: mergeHeaders(headers),
      );
      return _handleResponse(response);
    });
  }

  Future<ApiResponse> patch<T>(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) {
    return _retryOnAuthFailure(() async {
      AppLogger.logInfo("Request URL", '$rootURL$endpoint');

      final response = await http.patch(
        Uri.parse('$rootURL$endpoint'),
        body: jsonEncode(data),
        headers: mergeHeaders(headers),
      );
      return _handleResponse(response);
    });
  }

  Future<ApiResponse> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
  }) {
    return _retryOnAuthFailure(() async {
      AppLogger.logInfo("Request URL", '$rootURL$endpoint');

      final response = await http.delete(
        Uri.parse('$rootURL$endpoint'),
        headers: mergeHeaders(headers),
      );
      return _handleResponse(response);
    });
  }

  Future<ApiResponse> postWithMultipart<T>(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final url = '$rootURL$endpoint';
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
    AppLogger.logInfo(
      "Response Stats:\n",
      "HttpService Response ${response.statusCode}\n",
    );

    final int statusCode = response.statusCode;
    final dynamic parsedData = json.decode(response.body);
    final String defaultError = "Some error occurred! Please try again!";
    final String? message =
        parsedData is Map<String, dynamic> ? parsedData['message'] : null;

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(
        isSuccess: true,
        data: parsedData['data'],
        errorMessage: null,
      );
    }

    if (statusCode == 401) {
      throw UnauthorizedUserException(
        message ?? "Access Token Expired or Invalid",
      );
    }

    String errorMsg;
    if (statusCode == 404) {
      errorMsg = message ?? "Data not found!";
    } else if (statusCode >= 400) {
      errorMsg = message ?? "Bad Request! Please try again!";
    } else {
      errorMsg = message ?? defaultError;
    }

    return ApiResponse(isSuccess: false, data: null, errorMessage: errorMsg);
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
    

    final response = await http.put(
      Uri.parse('$base/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }
 */
