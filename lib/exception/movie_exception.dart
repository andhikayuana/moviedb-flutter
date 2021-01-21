import 'package:dio/dio.dart';

class MovieException implements Exception {
  String message;

  MovieException.fromDio(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        message = "Request to API server was canceled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.DEFAULT:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.RESPONSE:
        message = _handleError(dioError.response.statusCode);
        break;
      default:
        message = "Oops, something went wrong";
        break;
    }
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad Request";
        break;
      case 404:
        return "The requested resource was not found";
        break;
      case 500:
        return "Internal server error";
        break;
      default:
        return "Oops, somethign went wrong";
    }
  }
}
