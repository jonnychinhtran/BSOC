import 'dart:io';

import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/repositories/IInfoRepo.dart';
import 'package:bsoc_book/app/repositories/IUserRepo.dart';
import 'package:bsoc_book/app/repositories/api/InfoApiRepository.dart';
import 'package:bsoc_book/app/repositories/api/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class UserViewModel {
  late IInfoRepo _infoRepo;
  late IUserRepo _userRepo;

  UserViewModel() {
    _infoRepo = InfoApiRepository();
    _userRepo = UserApiRepository();
  }

  UserModel? _userModel;

  UserModel? get userlModel => _userModel;

  PostReponseModel? _postReponseModel;

  PostReponseModel? get postModel => _postReponseModel;

  final BehaviorSubject<UserModel?> _userInfoModelSubject =
      BehaviorSubject<UserModel?>();
  Stream<UserModel?> get userInfoModelSubjectStream =>
      _userInfoModelSubject.stream;

  clearCache() {
    _userModel = null;
    _userInfoModelSubject.add(null);
  }

  void setPostModel({PostReponseModel? postModel}) {
    _postReponseModel = postModel;
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
      required String fullname}) {
    return _userRepo
        .updateInfo(
            userId: userId,
            username: username,
            email: email,
            phone: phone,
            fullname: fullname)
        .then((value) {
      // setPostModel(postModel: value);
      return value;
    });
  }

  Future<PostReponseModel?> deleteUser() {
    return _userRepo.deleteUser().then((value) {
      setPostModel(postModel: value);
      return value;
    });
  }

  void dispose() {
    _userInfoModelSubject.close();
  }
}
