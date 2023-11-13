class NetworkEndpoints {
  static const String DNS_SERVER = "";
  static const String BASE_URL = "http://103.77.166.202";
  // static const String BASE_API = "";
  static const String BASE_API_VERSION = "/api";
  // static const String BASE_API_VERSION = "/v1" + BASE_MODULE;
  // static const String BASE_MODULE = "/pos";
  // static const String G_KEY_HEADER = "";
  // static const String BASE_APP_GCI_MODULE = "";

  //User Form
  static const String POST_REGISTER_API = '/auth/register';
  static const String POST_LOGIN_API = '/auth/login';
  static const String POST_CHANGE_PASSWORD_API = '/user/changepass';
  static const String POST_FORGOT_PASSWORD_API = '/user/resetpass';
  static const String UPDATE_PROFILE_API = '/user/update';
  static const String POST_DELETE_PROFILE_API = '/user/delete';

  //User Get
  static const String GET_USER_INFO_API = '/user/profile';
  static const String GET_VOUCHER_API = '/user/voucher';

  //Book Store
  static const String GET_BOOK_STORE_API = '/book/all-book';
  static const String GET_BOOK_DETAIL_API = '/book/getBook';
  static const String GET_TOP_BOOK_API = '/book/top-book';
  static const String GET_COMMENT_BOOK_API = '/book/list-comment';
  static const String POST_COMMENT_BOOK_API = '/book/comment';

  //Chapter Book
  static const String GET_CHAPTER_BOOKMARK_API = '/chapter/list-bookmark';
  static const String POST_ADD_CHAPTER_BOOKMARK_API = '/chapter/add-bookmark';
  static const String GET_DOWNLOAD_CHAPTER_API = '/chapter/download';
  static const String GET_DELETE_CHAPTER_BOOKMARK_API =
      '/chapter/delete-bookmark';

  //Wheel Spin List
  static const String GET_WHEEL_SPIN_LIST_API = '/spin/list';

  //Reward
  static const String GET_REWARD_API = '/payment/open-book';

  //Quiz
  static const String GET_QUIZ_SUBJECT_API = '/quiz/list-subject';
  static const String GET_QUIZ_QUESTION_API = '/quiz/list-question';
  static const String POST_CHECK_RESULT_API = '/quiz/check-result';
  static const String GET_SUBJECT_INFO_API = '/quiz/subject-info';
}
