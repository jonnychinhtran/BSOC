import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://ec2-54-172-194-31.compute-1.amazonaws.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );
}
