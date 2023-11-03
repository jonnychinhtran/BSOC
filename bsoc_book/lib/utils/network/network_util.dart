import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../http/http_exception.dart';
import '../../utils/log/dio_logger.dart';

/// Network Util Class -> A utility class for handling network operations . It is using DIO
class NetworkUtil2 {
  static const String TAG = 'APIProvider';
  //----------------------------------------------------------- Singleton-Instance ------------------------------------------------------------------
  // Singleton Instance
  static final NetworkUtil2 _instance = NetworkUtil2.internal();

  /// NetworkUtil Private Constructor -> NetworkUtil
  /// @param -> _
  /// @usage -> Returns the instance of NetworkUtil class
  NetworkUtil2.internal() {
    //dioOptions.baseUrl = NetworkUtil2._baseUrl;
    _baseOptions = BaseOptions();
    _dio = Dio(_baseOptions);

    // Update DIO Interceptors for new version
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      //DioLogger.onSend(TAG, options); //HoangCV cmt
      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onResponse: (response, handler) {
      //DioLogger.onSuccess(TAG, response); //HoangCV cmt
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onError: (DioError e, handler) {
      DioLogger.onError(TAG, e);
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    }));
  }

  /// NetworkUtil Factory Constructor -> NetworkUtil
  /// @dependency -> _
  /// @usage -> Return the instance of NetworkUtil class
  factory NetworkUtil2() => _instance;

  //------------------------------------------------------------- Variables ---------------------------------------------------------------------------
  // JsonDecoder object
  final JsonDecoder _decoder = const JsonDecoder();
  // Dio object
  late Dio _dio;
  // Base Options
  BaseOptions? _baseOptions;
  //------------------------------------------------------------- Class Methods -----------------------------------------------------------------------------
  void setBaseOption(BaseOptions baseOptions) {
    _baseOptions = baseOptions;
  }

  void setBaseUrl({required String baseUrl}) {
    if (_baseOptions == null) return;
    _baseOptions?.baseUrl = baseUrl;
  }

  void setHeaderData({required Map<String, dynamic> headerData}) {
    if (_baseOptions == null) return;
    _baseOptions?.headers = headerData;
  }

  void addHeaderData({required String key, dynamic data}) {
    if (_baseOptions == null) return;
    _baseOptions?.headers[key] = data;
  }

  BaseOptions? get baseOptions => _baseOptions;
  //------------------------------------------------------------- Methods -----------------------------------------------------------------------------

  Future<dynamic> get(
      {required String url,
      Map<String, dynamic>? inQueryParameters,
      Options? inOptions}) async {
    print("[Network_Util2] GET $url");
    Response response;
    if (null != inOptions) {
      response = await _dio.get(url,
          queryParameters: inQueryParameters, options: inOptions);
    } else {
      response = await _dio.get(url, queryParameters: inQueryParameters);
    }

    throwIfNoSuccess(response);
    // No error occurred
    // Get response body
    // Convert response body to JSON object
    return response.data;
  }

  Future<dynamic> post(
      {required String url,
      Map<String, dynamic>? inQueryParameters,
      dynamic data,
      Options? inOptions}) async {
    print("[Network_Util2] POST ${baseOptions?.baseUrl ?? ""}\\$url");
    //log(jsonEncode(data));
    Response response;

    if (null != inOptions) {
      //
      response = await _dio.post(url,
          queryParameters: inQueryParameters, data: data, options: inOptions);
    } else {
      //
      response =
          await _dio.post(url, queryParameters: inQueryParameters, data: data);
    }

    throwIfNoSuccess(response);
    // No error occurred
    // Get response body
    // Convert response body to JSON object
    return response.data;
  }

  //--------------- SUPPORT METHODS -------------------------------
  void throwIfNoSuccess(Response response) {
    print(response.toString());
    if (response.statusCode! < 200 || response.statusCode! > 299) {
      print("Network Util ERROR : ${response.realUri}");
      throw HttpException(response);
    }
  }
}
