import 'package:dio/dio.dart';

class AppFailure {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppFailure(this.message, {this.originalError, this.stackTrace});

  factory AppFailure.fromObject(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;

    if (error is DioException) {
      return AppFailure.fromDioException(error, stackTrace);
    }

    // Default generic message for unexpected errors
    return AppFailure(
      'An unexpected error occurred. Please try again later.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  factory AppFailure.fromDioException(DioException error, [StackTrace? stackTrace]) {
    String message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          message = 'Session expired. Please log in again.';
        } else if (statusCode == 403) {
          message = 'You don\'t have permission to perform this action.';
        } else if (statusCode == 404) {
          message = 'The requested resource was not found.';
        } else if (statusCode != null && statusCode >= 500) {
          message = 'Server error. We\'re working on fixing it.';
        } else {
          message = 'Unexpected response from server ($statusCode).';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your settings.';
        break;
      default:
        message = 'Something went wrong while connecting to the server.';
    }

    return AppFailure(
      message,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => message;
}
