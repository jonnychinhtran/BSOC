import 'dart:io';

import 'package:bsoc_book/app/models/user_model.dart';

abstract class IInfoRepo {
  Future<UserModel?> getUser();
  // Future<bool> updateUser(UserModel model);
  Future<UserModel?> updateInfo(
      {required String userId,
      required String username,
      required String email,
      required String phone,
      required String fullname});
}
