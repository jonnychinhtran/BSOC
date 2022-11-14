class ApiEndPoints {
  static final String baseUrl = "http://103.77.166.202";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  //AUTH
  final String registerUser = '/api/auth/register';
  final String loginUser = '/api/auth/login';
  final String getRoleUser = '/api/auth/all-role';

  //USER INFOR
  final String getUsers = '/api/user/{id}';
  final String inforUser = '/api/user/infor';
  final String upateUser = '/api/user/update';
  final String resetPass = '/api/user/resetpass';
  final String updateStatus = '/api/user/update-status';
  final String changePass = '/api/user/changepass';

  //BOOK
  final String getAllBook = '/api/book/all-book';
  final String createBook = '/api/book/create';
  final String getItemBook = '/api/book/2';

  //CHAPTER BOOK
  final String createChapter = '/api/chapter';
  final String downloadChapter = '/api/chapter/download/{chapterId}';
}
