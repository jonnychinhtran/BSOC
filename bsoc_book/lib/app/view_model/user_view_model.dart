import 'dart:io';

import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/repositories/IInfoRepo.dart';
import 'package:bsoc_book/app/repositories/IUserRepo.dart';
import 'package:bsoc_book/app/repositories/api/InfoApiRepository.dart';
import 'package:rxdart/rxdart.dart';

class UserViewModel {
  late IInfoRepo _infoRepo;

  UserViewModel() {
    _infoRepo = InfoApiRepository();
  }

  UserModel? _userModel;

  UserModel? get userlModel => _userModel;

  final BehaviorSubject<UserModel?> _userInfoModelSubject =
      BehaviorSubject<UserModel?>();
  Stream<UserModel?> get userInfoModelSubjectStream =>
      _userInfoModelSubject.stream;

  clearCache() {
    _userModel = null;
  }

  void setUserInfoModel({UserModel? userModel}) {
    _userModel = userModel;
  }

  Future<UserModel?> getInfoPage() {
    return _infoRepo.getUser().then((userModel) {
      print("Get Info 33333: $userModel");
      setUserInfoModel(userModel: userModel);
      _userInfoModelSubject.add(userModel);
      return userModel;
    });
  }

  Future<bool> updateUser(
      {required String userId,
      required String username,
      required String email,
      required String phone,
      required String fullname}) async {
    try {
      return await _infoRepo
          .updateInfo(
              userId: userId,
              username: username,
              email: email,
              phone: phone,
              fullname: fullname)
          .then((value) {
        if (null != value) {
          _userModel = value;
          // _userInfoModelSubject.add(value);
          // _hasAddItemServiceOrderSubject.add(true);
          return true;
        }
        return false;
      });
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _userInfoModelSubject.close();
  }
}
