import 'package:bsoc_book/app/models/user_model.dart';

abstract class IUserRepo {
  Future<UserModel> getUser();
  Future<bool> updateUser(UserModel model);
  Future<bool> deleteUser();
  Future<bool> login({required String username, required String password});
  Future<void> logout();
}
