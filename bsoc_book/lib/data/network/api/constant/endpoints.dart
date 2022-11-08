class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl =
      "http://ec2-54-172-194-31.compute-1.amazonaws.com";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String signup = '/api/auth/signup';
  static const String signin = '/api/auth/signin';

  static const String users = '/api/user/{id}';
  static const String update = '/api/user/update';
  static const String updatestatus = '/api/user/update-status';
  static const String changepass = '/api/user/changepass';
}
