import 'dart:io';

import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IInfoRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:logging/logging.dart';

class InfoApiRepository extends ApiProviderRepository implements IInfoRepo {
  final logger = Logger("InfoApiRepository");

  @override
  Future<UserModel?> getUser() async {
    return NetworkUtil2()
        .get(url: NetworkEndpoints.GET_USER_INFO_API)
        .then((dynamic response) {
      UserModel userModel = UserModel.fromJson(response);
      print("User Info: $response");
      return userModel;
    });
  }

  @override
  Future<UserModel?> updateInfo(
          {File? image,
          int? userId,
          String? username,
          String? email,
          String? phone,
          String? fullname}) =>
      NetworkUtil2().post(url: NetworkEndpoints.UPDATE_PROFILE_API, data: {
        'image': image,
        'userId': userId,
        'username': username,
        'email': email,
        'phone': phone,
        'fullname': fullname,
      }).then((dynamic response) {
        print("Update Info: $response");
        UserModel businessModel = UserModel.fromJson(response);
        return businessModel;
      });
}
