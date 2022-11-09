// import 'package:bsoc_book/data/interfaces/auth_interfaces.dart';
// import 'package:bsoc_book/data/model/user/user_model.dart';
// import 'package:bsoc_book/data/network/dio_client.dart';
// import 'package:dio/dio.dart';

// class AuthReposistory implements AuthInterface {
//   final Dio dio;

//   AuthReposistory({required this.dio});

//   @override
//   Future<UserModel> getListUser() async {
//     try {
//       final response = await dio.get(ApiConstant.users,
//           options: await HeaderNetworkConstant.getOptionsWithToken());
//       print("data user: ${response.data}");
//       return UserModel.fromJson(response.data);
//     } on DioError catch (e) {
//       print(e);
//       throw Future.error(e.response!.data.toString());
//     }
//   }

//   @override
//   Future postSignin(String username, String password) async {
//     try {
//       await dio.put(ApiConstant.signIn,
//           options: await HeaderNetworkConstant.getOptionsWithToken(),
//           queryParameters: ({'username': username, 'password': password}));
//     } catch (e) {
//       print(e);
//       return Future.error(e);
//     }
//   }

//   @override
//   Future postSignup(String username, String email, String password) async {
//     try {
//       await dio.put(ApiConstant.signUp,
//           options: await HeaderNetworkConstant.getOptionsWithToken(),
//           queryParameters: ({
//             'username': username,
//             'email': email,
//             'password': password
//           }));
//     } catch (e) {
//       print(e);
//       return Future.error(e);
//     }
//   }
// }
