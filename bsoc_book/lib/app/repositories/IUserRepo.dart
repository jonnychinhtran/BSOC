import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';

abstract class IUserRepo {
  Future<UserModel?> getUser();
  Future<bool> updateInfo(
      {required String userId,
      required String username,
      required String email,
      required String phone,
      required String fullname});
  Future<PostReponseModel?> deleteUser();
  Future<bool> login({required String username, required String password});
  Future<PostReponseModel?> register(
      {required String username,
      required String email,
      required String phone,
      required String password});
  Future<PostReponseModel?> resetpass({
    required String email,
  });
}
