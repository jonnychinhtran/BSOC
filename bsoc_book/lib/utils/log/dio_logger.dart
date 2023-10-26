import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'log.dart';

class DioLogger {
  static void onSend(String tag, RequestOptions options) {
    Log.info(
        '$tag - Request Path : [${options.method}] ${options.baseUrl}${options.path}');
    Log.info('$tag - Request Data : ${options.data.toString()}');
  }

  static void onSuccess(String tag, Response response) {
    Log.info(
        '$tag - Response Path : [${response.requestOptions.method}] ${response.requestOptions.baseUrl}${response.requestOptions.path} Request Data : ${response.requestOptions.data.toString()}');
    Log.info('$tag - Response statusCode : ${response.statusCode}');
    Log.info('$tag - Response data : ${response.data.toString()}');
  }

  static void onError(String tag, DioError error) {
    if (null != error.response) {
      Log.info(
          '$tag - Error Path : [${error.response!.requestOptions.method}] ${error.response!.requestOptions.baseUrl}${error.response!.requestOptions.path} Request Data : ${error.response!.requestOptions.data.toString()}');
      Log.info('$tag - Error statusCode : ${error.response!.statusCode}');
      Log.info(
          '$tag - Error data : ${null != error.response!.data ? error.response!.data.toString() : ''}');
    }
    Log.info('$tag - Error Message : ${error.message}');
  }
}

class DioLogzLogger {
  static void onSend(String tag, RequestOptions options) {
    final log = Logger("NetworkUtil2 - onSend");
    log.info(
        'Request Path : [${options.method}] ${options.baseUrl}${options.path} Request Data : ${options.data.toString()}');
  }

  static void onSuccess(String tag, Response response) {
    final log = Logger("NetworkUtil2 - onSuccess");
    log.info(
        'Response Path : [${response.requestOptions.method}] ${response.requestOptions.baseUrl}${response.requestOptions.path} Request Data : ${response.requestOptions.data.toString()} Response statusCode : ${response.statusCode} Response data : ${response.data.toString()}');
  }

  static void onError(String tag, DioError error) {
    final log = Logger("NetworkUtil2 - onError");
    if (null != error.response) {
      log.info(
          'Error Path : [${error.response!.requestOptions.method}] ${error.response!.requestOptions.baseUrl}${error.response!.requestOptions.path} Request Data : ${error.response!.requestOptions.data.toString()} Error statusCode : ${error.response!.statusCode} Error data : ${null != error.response!.data ? error.response!.data.toString() : ''}');
    }
    log.info('Error Message : ${error.message}');
  }
}
