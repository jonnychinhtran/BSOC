import 'dart:convert';

import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/repositories/IBookRepo.dart';
import 'package:bsoc_book/app/repositories/IUserRepo.dart';
import 'package:bsoc_book/app/repositories/api/BookApiRepository.dart';
import 'package:bsoc_book/app/repositories/api/UserRepository.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';

class LoginViewModel {
  late IUserRepo _userRepo;

  String username = "";
  String password = "";

  LoginViewModel() {
    _userRepo = UserApiRepository();
  }

  PostReponseModel? _postReponseModel;

  PostReponseModel? get postModel => _postReponseModel;

  void setPostModel({PostReponseModel? postModel}) {
    _postReponseModel = postModel;
  }

  Future<bool> login({required username, required password}) {
    return _userRepo
        .login(username: username, password: password)
        .then((value) {
      return value;
    });
  }

  Future<PostReponseModel?> registerUser(
      {required String username,
      required String email,
      required String phone,
      required String password}) {
    return _userRepo
        .register(
            username: username, email: email, phone: phone, password: password)
        .then((value) {
      setPostModel(postModel: value);
      return value;
    });
  }

  Future<PostReponseModel?> resetPassword({
    required String email,
  }) {
    return _userRepo.resetpass(email: email).then((value) {
      setPostModel(postModel: value);
      return value;
    });
  }

  Future<bool> loadAppData() async {
    print("-------------Load User Data ----------------");
    _userRepo.getUser().then((userModel) {
      if (null != userModel) {
        AppDataGlobal().setUser(userModel: userModel);
      }
    });

    return Future.value(true);
  }

  Future<bool> isTokenExpired(String token) async {
    // Giả sử token là JWT và bạn có thể kiểm tra thời gian hết hạn từ payload
    try {
      final payload = token.split('.')[1];
      final decodedPayload =
          utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final payloadMap = json.decode(decodedPayload);
      final exp = payloadMap['exp'];
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
      return currentTime > exp;
    } catch (e) {
      return true; // Nếu có lỗi, giả định token đã hết hạn
    }
  }
}
