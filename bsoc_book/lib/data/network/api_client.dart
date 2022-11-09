class ApiEndPoints {
  static final String baseUrl =
      "http://ec2-54-172-194-31.compute-1.amazonaws.com";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerUser = '/api/auth/signup';
  final String loginUser = '/api/auth/signin';
}


// import 'package:bsoc_book/data/storage/hive_storage.dart';
// import 'package:dio/dio.dart';

// class ApiConstant {
//   ApiConstant._();

//   // base url
//   static const String baseUrl =
//       "http://ec2-54-172-194-31.compute-1.amazonaws.com";

//   // receiveTimeout
//   static const int receiveTimeout = 10000;

//   // connectTimeout
//   static const int connectionTimeout = 10000;

//   static const String signUp = '/api/auth/signup';
//   static const String signIn = '/api/auth/signin';

//   static const String users = '/api/user/{id}';
//   static const String upDate = '/api/user/update';
//   static const String updateStatus = '/api/user/update-status';
//   static const String changePass = '/api/user/changepass';
// }

// class HeaderNetworkConstant {
//   static final BaseOptions baseOptions = BaseOptions(
//       baseUrl: ApiConstant.baseUrl,
//       connectTimeout: ApiConstant.connectionTimeout,
//       receiveTimeout: ApiConstant.receiveTimeout);

//   static Future<Options> getOptionsWithToken({
//     String accept = 'application/json',
//     int sendTimeout = 60000,
//     int receiveTimeout = 60000,
//   }) async {
//     final token = await HiveStorage.getToken();
//     return Options(
//         sendTimeout: sendTimeout,
//         receiveTimeout: receiveTimeout,
//         headers: {'accept': accept, 'Access-Token': token});
//   }
// }

