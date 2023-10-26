/// App Strings Class -> Resource class for storing app level strings constants
class AppStrings {
  static const String APP_NAME = "Go POS";

  //--------------------------------------------------- Login -----------------------------------------------------------------------------------------

  static const String LOGIN_USER_NAME_LABEL = "User Name";
  static const String LOGIN_USER_PASSWORD_LABEL = "Password";

  static const String LOGIN_USER_NAME_HINT = "Enter user name";
  static const String LOGIN_USER_PASSWORD_HINT = "Enter password";

  static const String LOGIN_USER_NAME_ERROR_MSG =
      "User name must be at least 6 characters";
  static const String LOGIN_USER_PASSWORD_ERROR_MSG =
      "Password must be at least 8 characters";
  static const String LOGIN_USER_NAME_INVALID_MSG = "Invalid user name";
  static const String LOGIN_USER_PASSWORD_INVALID_MSG = "Invalid user password";

  static const String LOGIN_RESET_BUTTON_LABEL = "Reset";
  static const String LOGIN_LOGIN_BUTTON_LABEL = "Login";

  static const String LOGIN_SUCCESSFUL_LOGIN_MSG = "Successful login";
  static const String LOGIN_UNSUCCESSFUL_LOGIN_MSG = "Invalid credentials";

  static const String ITEM_MENU_HOME = "Home";
  static const String ITEM_MENU_CHECK_GIFTCODE = "Check Giftcode";
  static const String ITEM_MENU_BATCH_CLOSE = 'Batch Close';
  static const String ITEM_MENU_BATCH_HISTORY = 'Batches';
  static const String ITEM_MENU_INCOME = 'Income';
  static const String ITEM_MENU_STORE_INCOME = 'Store income';
  static const String ITEM_MENU_STAFF_INCOME = 'Staff income';
  static const String ITEM_MENU_PRINTER_SETTING = 'Printer Setting';
  static const String ITEM_MENU_LOGOUT = 'Logout';
  static const String ITEM_MENU_REFRESH = 'Refresh';

  static const String ITEM_NAVIGATION_QRCODE = "QR code";
  static const String ITEM_NAVIGATION_ORDER_HISTORY = "Order History";
  static const String ITEM_NAVIGATION_CHECKOUT = "Check out";
  static const String ITEM_NAVIGATION_QUICKPAY = "Quick pay";
}
