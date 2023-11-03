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

  Future<bool> login({required username, required password}) {
    return _userRepo
        .login(username: username, password: password)
        .then((value) {
      return value;
    });
  }

  Future<bool> loadAppData() async {
    _userRepo.getUser().then((value) {});

    return Future.value(true);
  }
}
