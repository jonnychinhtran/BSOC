import 'dart:convert';
import 'package:bsoc_book/model/auth/register_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  String baseurl = 'http://ec2-54-172-194-31.compute-1.amazonaws.com';

  Future<RegisterResponse> registerUser(
      String username, String password) async {
    try {
      var res = await Dio().post(baseurl + '/api/auth/signup',
          data: {"username": username, "password": password});
      if (res.statusCode == 200) {
        print(res.data);
        Map<String, dynamic> authResponse = res.data;
        return RegisterResponse.fromJson(authResponse);
      } else {
        return jsonDecode(res.data)['error'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
