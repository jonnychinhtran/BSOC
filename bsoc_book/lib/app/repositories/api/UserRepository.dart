import 'dart:convert';
import 'dart:io';
import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/models/api/response_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/network/network_config.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IUserRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as logg;
import 'package:path/path.dart';

class UserApiRepository extends ApiProviderRepository implements IUserRepo {
  UserApiRepository();
  //shared preferences
  // SharedPreferences? _sharedPreferences;

  // @override
  // Future<bool> login(
  //     {required String username, required String password}) async {
  //   final formData = {
  //     NetworkConfig.API_KEY_USER_NAME: username,
  //     NetworkConfig.API_KEY_USER_PASSWORD: password,
  //   };
  //   try {
  //     Dio dio = Dio();
  //     dio.options.headers = {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //     };

  //     var response = await dio.post(
  //       'http://103.77.166.202/api/auth/login',
  //       data: json.encode(formData),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseModel = ResponseModel.fromJson(response.data);
  //       if (responseModel.statusCode == NetworkConfig.STATUS_OK) {
  //         final resultModel = responseModel.data;
  //         //save token to shared preferences
  //         AppPreferences().setAccessToken(token: resultModel!.accessToken!);
  //         AppPreferences().setLoggedIn(isLoggedIn: true);
  //         AppDataGlobal().setAccessToken(accessToken: resultModel.accessToken);
  //         dio.options.headers[HttpHeaders.authorizationHeader] =
  //             "Bearer ${resultModel.accessToken}";
  //         return true;
  //       }
  //     }
  //     return false;
  //   } on DioError catch (e) {
  //     print('Login Error: ${e.response?.data}');
  //     return false;
  //   }
  // }

  @override
  Future<bool> login({required String username, required String password}) =>
      NetworkUtil2().post(url: NetworkEndpoints.POST_LOGIN_API, data: {
        NetworkConfig.API_KEY_USER_NAME: username,
        NetworkConfig.API_KEY_USER_PASSWORD: password,
      }).then((dynamic response) {
        final responseModel = ResponseModel.fromJson(response);
        if (responseModel.statusCode == NetworkConfig.STATUS_OK) {
          final resultModel = responseModel.data;
          AppPreferences().setAccessToken(token: resultModel!.accessToken!);
          AppPreferences().setLoggedIn(isLoggedIn: true);
          AppDataGlobal().setAccessToken(accessToken: resultModel.accessToken);
          NetworkUtil2().addHeaderData(
              key: HttpHeaders.authorizationHeader,
              data: "Bearer ${resultModel.accessToken}");
          return true;
        }
        return false;
      }).catchError((error) {
        print(error.toString());
        return false;
      });

  // @override
  // Future<UserModel> getUser() {
  //   // TODO: implement getUser
  //   throw UnimplementedError();
  // }

  @override
  Future<UserModel?> getUser() async {
    return NetworkUtil2()
        .get(url: NetworkEndpoints.GET_USER_INFO_API)
        .then((dynamic response) {
      final data = response;
      print("User Info: $data");
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    });
  }

  @override
  Future<PostReponseModel?> register(
      {required String? username,
      required String? email,
      required String? phone,
      required String? password}) async {
    final formData = {
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
    };
    try {
      Dio().options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var response = await Dio().post('http://103.77.166.202/api/auth/register',
          data: json.encode(formData));
      if (response.statusCode == 200) {
        final jsondata = response.data;
        print('THONG BAO ${response.data}');
        PostReponseModel postReponseModel = PostReponseModel.fromJson(jsondata);
        return postReponseModel;
      } else {
        throw Error();
      }
    } on DioError catch (e) {
      print('THONG BAO LOI ${e.response!.data}');
      final jsonerror = e.response!.data;
      PostReponseModel postReponseModel = PostReponseModel.fromJson(jsonerror);
      return postReponseModel;
    }
  }

  @override
  Future<PostReponseModel?> resetpass({
    required String? email,
  }) async {
    try {
      var response = await Dio()
          .post('http://103.77.166.202/api/user/resetpass', queryParameters: {
        "email": email,
      });
      if (response.statusCode == 200) {
        final json = response.data;
        PostReponseModel postReponseModel = PostReponseModel.fromJson(json);
        return postReponseModel;
      } else {}
      print("res: ${response.data}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<PostReponseModel?> deleteUser() async {
    try {
      var response = await Dio().post('http://103.77.166.202/api/user/delete',
          options: Options(headers: {
            'Authorization': 'Bearer ${AppDataGlobal().accessToken}',
          }));
      if (response.statusCode == 200) {
        final json = response.data;
        PostReponseModel postReponseModel = PostReponseModel.fromJson(json);
        return postReponseModel;
      } else {}
      print("res: ${response.data}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> updateInfo({
    required String userId,
    required String username,
    required String email,
    required String phone,
    required String fullname,
  }) async {
    String url = 'http://103/api/user/update';
    String token = AppDataGlobal().accessToken;
    String? imagePath = '';
    FormData formData = FormData.fromMap({
      'userId': userId,
      'username': username,
      'email': email,
      'phone': phone,
      'fullname': fullname,
    });

    if (imagePath != '') {
      String fileName = basename(imagePath);
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(imagePath, filename: fileName),
      ));
    }

    try {
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: 'multipart/form-data',
        ),
      );
      print('DONE: ${response}');
      return response.statusCode == 200;
    } on DioError catch (e) {
      print('Error: ${e.response}');
      return false;
    }
  }
}
