class ApiEndPoints {
  static const String baseUrl =
      "http://ec2-54-172-194-31.compute-1.amazonaws.com";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  //AUTH
  final String registerUser = '/api/auth/signup';
  final String loginUser = '/api/auth/signin';

  //USER INFOR
  final String users = '/api/user/{id}';
  final String upDate = '/api/user/update';
  final String updateStatus = '/api/user/update-status';
  final String changePass = '/api/user/changepass';

  //BOOK PRODUCT

}
