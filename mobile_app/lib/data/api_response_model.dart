class ApiResponse {
  final dynamic data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResponse({this.data, this.errorMessage, required this.isSuccess});
}
