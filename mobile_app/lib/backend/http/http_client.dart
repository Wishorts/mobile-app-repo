import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:mobile_app/shared/utils/exceptions.dart';
import 'package:mobile_app/shared/utils/logger.dart';


class HttpClient {
  String baseUrl;
  String authToken;

  HttpClient({required this.baseUrl, required this.authToken});

  // Default headers
  Map<String, String> getHeaders() {
    return {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $authToken'};
  }

  Map<String, String> mergeHeaders(Map<String, String>? customHeaders) {
    return {...getHeaders(), if (customHeaders != null) ...customHeaders};
  }

  // Temp Change to be removed aftr versioning is sorted
  Future<T> getV2<T>(String endpoint, String params, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    String base = baseUrl.replaceAll('v1', 'v2');
    AppLogger.logInfo("Request URL", '$base/$endpoint?$params');

    final response = await http.get(Uri.parse('$base/$endpoint?$params'), headers: mergeHeaders(headers));

    AppLogger.logInfo("Response JSON", response.body);

    return _handleResponse(response);
  }

  Future<T> postV2<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
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

  Future<T> patchV2<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
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

  Future<T> putV2<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
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

  Future<T> get<T>(String endpoint, String params, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint?$params');

    final response = await http.get(Uri.parse('$baseUrl/$endpoint?$params'), headers: mergeHeaders(headers));

    AppLogger.logInfo("Response JSON", response.body);

    return _handleResponse(response);
  }

  Future<T> post<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<T> put<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<T> patch<T>(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');
    AppLogger.logInfo("Request Body", jsonEncode(data));

    final response = await http.patch(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data),
      headers: mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<T> delete<T>(String endpoint, {Map<String, String>? headers}) async {
    AppLogger.logInfo("Request URL", '$baseUrl/$endpoint');

    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'), headers: mergeHeaders(headers));
    return _handleResponse(response);
  }

  Future<T> postWithMultipart<T>(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final url = '$baseUrl/$endpoint';
    Uri uri = Uri.parse(url);

    AppLogger.logInfo("Request URL", url);

    var request = http.MultipartRequest('POST', uri);

    if (data.containsKey('file') && data['file'] is File) {
      File file = data['file'];
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();
      var multipartFile = http.MultipartFile('file', fileStream, fileLength, filename: basename(file.path));

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

  T _handleResponse<T>(http.Response response) {
    AppLogger.logInfo("HttpService Response ${response.statusCode}", "");

    if (response.statusCode == 204) {
      dynamic responseData = {};
      responseData['status'] = true;
      return responseData;
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic responseData = json.decode(response.body);
      responseData['status'] = true;
      return responseData;
    } else if (response.statusCode == 404) {
      throw NoDataToShowException("No data to show");
    } else {
      final dynamic responseData = json.decode(response.body);
      if (responseData['message'] == "Internal server error") {
        throw InternalErrorException('Request failed with status: ${response.statusCode}');
      } else if (responseData['message'] == "invalid token") {
        throw InvalidCredentialsException('Request failed with status: ${response.statusCode}');
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    }
  }
}
