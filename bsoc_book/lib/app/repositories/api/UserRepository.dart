import 'dart:io';
import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/api/response_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/network/network_config.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IUserRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/app_preferences.dart';

class UserApiRepository extends ApiProviderRepository implements IUserRepo {
  UserApiRepository();

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

  @override
  Future<bool> deleteUser() {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  // @override
  // Future<UserModel> getUser() {
  //   // TODO: implement getUser
  //   throw UnimplementedError();
  // }

  @override
  Future<UserModel> getUser() => NetworkUtil2()
          .get(url: NetworkEndpoints.GET_USER_INFO_API)
          .then((dynamic response) {
        // final responseModel = ResponseModel.fromJson(response);
        // if (response != null) {
        final data = response;
        UserModel userModel = UserModel.fromJson(response);
        return userModel;
//         if (responseModel.status == NetworkConfig.STATUS_OK) {
//           final resultModel = responseModel.result;
//           if (resultModel!.status == NetworkConfig.STATUS_OK) {
//             final data = resultModel.data;
//             List<UserModel> list = [];
// //            list.add(StaffModel(name: 'Store', userId: -1, colorCode: null, imageUrl: null));
//             for (int i = 0; i < data.length; i++) {
//               UserModel staffModel = UserModel.fromJson(data[i]);
//               list.add(staffModel);
//             }

//             return list;
//           }
        // }

        // return null;
      });

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(UserModel model) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
