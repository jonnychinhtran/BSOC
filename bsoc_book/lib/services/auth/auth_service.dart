import 'dart:convert';
import 'package:bsoc_book/model/auth/register_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        addToScureStorage(authResponse['token']);
        return RegisterResponse.fromJson(authResponse);
      } else {
        return jsonDecode(res.data)['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  void addToScureStorage(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
  }

  Future<void> deleteAllScureStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
