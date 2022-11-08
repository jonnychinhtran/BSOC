import 'package:bsoc_book/data/network/dio_client.dart';
import 'constant/endpoints.dart';
import 'package:dio/dio.dart';

class UserApi {
  final DioClient dioClient;

  UserApi({required this.dioClient});

  Future<Response> signupUserApi(
      String username, String email, String password) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.signup,
        data: {'username': username, 'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signinUserApi(String username, String password) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.signin,
        data: {'username': username, 'password': password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> getUsersApi() async {
  //   try {
  //     final Response response = await dioClient.get(Endpoints.users);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<Response> updateUserApi(int id, String name, String job) async {
  //   try {
  //     final Response response = await dioClient.put(
  //       Endpoints.users + '/$id',
  //       data: {
  //         'name': name,
  //         'job': job,
  //       },
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

}
