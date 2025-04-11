class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class InternalErrorException implements Exception {
  final String message;
  InternalErrorException(this.message);

  @override
  String toString() => "InternalErrorException: $message";
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class NoDataToShowException implements Exception {
  final String message;
  NoDataToShowException(this.message);

  @override
  String toString() => 'NoDataToShowException: $message';
}

class InvalidImageException implements Exception {
  final String message;
  InvalidImageException(this.message);

  @override
  String toString() => 'InvalidImageException: $message';
}

class UnauthorizedUserException implements Exception {
  final String message;
  UnauthorizedUserException(this.message);

  @override
  String toString() => 'UnauthorizedUserException: $message';
}
