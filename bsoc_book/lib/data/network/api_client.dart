class ApiEndPoints {
  static final String baseUrl =
      "http://ec2-54-172-194-31.compute-1.amazonaws.com";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  //AUTH
  final String registerUser = '/api/auth/register';
  final String loginUser = '/api/auth/login';

  //USER INFOR
  final String getUsers = '/api/user/{id}';
  final String upateUser = '/api/user/update';
  final String resetPass = '/api/user/resetpass';
  final String updateStatus = '/api/user/update-status';
  final String changePass = '/api/user/changepass';

  //BOOK PRODUCT
  final String createBook = '/api/book/create';
}
