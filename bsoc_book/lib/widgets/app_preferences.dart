import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  Future? _isPreferenceInstanceReady;
  // Factory Constructor
  // Final static instance of class initialized by private constructor
  static final AppPreferences _instance = AppPreferences._internal();
  static const String PREF_IS_LOGGED_IN = "IS_LOGGED_IN";
  static const String PREF_ACCESS_TOKEN = "ACCESS_TOKEN";
  static const String PREF_ACCOUNT_ID = "ACCOUNT_ID";
  static const String PREF_PASSWORD_SETTING = "PASSWORD_SETTING";
  static const String PREF_PRINTER_ADDRESS = "PRINTER_ADDRESS";
  static const String PREF_INFO_PRINTER_BLUETOOTH = "INFO_PRINTER_BLUETOOTH";
  static const String PREF_DOMAIN = "DOMAIN";

  static const String PREF_INFO_PAX_TERMINAL = "INFO_PAX_TERMINAL";
  static const String PREF_INFO_CLOVER_TERMINAL = "INFO_CLOVER_TERMINAL";
  static const String PREF_INFO_CLOVER_WINDOW_TERMINAL =
      "INFO_CLOVER_WINDOW_TERMINAL";
  static const String PREF_INFO_TERMINAL = "INFO_TERMINAL";
  static const String PREF_CLOVER_AUTH_TOKEN = 'CLOVER_AUTH_TOKEN';
  static const String PREF_INFO_DEVICE = 'INFO_DEVICE';
  static const String PREF_IS_USING_LOCAL_AUTH = "IS_LOCAL_AUTH";
  static const String PREF_PRINTER_TYPE = "PRINTER_TYPE";

  // Factory Constructor
  factory AppPreferences() => _instance;

// Private variable for SharedPreferences
  SharedPreferences? _preferences;
  // Constants for Preference-Value's data-type
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";
  static const String PREF_TYPE_LIST_STRING = "LIST_STRING";

  /// AppPreference Private Internal Constructor -> AppPreference
  /// @param->_
  /// @usage-> Initialize SharedPreference object and notify when operation is complete to future variable.
  AppPreferences._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future? get isPreferenceReady => _isPreferenceInstanceReady;

  Future<bool> getLoggedIn() async =>
      await _getPreference(prefName: PREF_IS_LOGGED_IN) ?? false;

  Future<dynamic> _getPreference({required prefName}) async =>
      _preferences?.get(prefName);

  void setLoggedIn({required bool isLoggedIn}) => _setPreference(
      prefName: PREF_IS_LOGGED_IN,
      prefValue: isLoggedIn,
      prefType: PREF_TYPE_BOOL);

  Future<String> getAccessToken() async {
    String token = await _getPreference(prefName: PREF_ACCESS_TOKEN) ?? "";
    return token;
  }

  void setDeviceInfo({required String device}) => _setPreference(
      prefName: PREF_INFO_DEVICE,
      prefValue: device,
      prefType: PREF_TYPE_STRING);

  Future<String> getDeviceInfo() async {
    String device = await _getPreference(prefName: PREF_INFO_DEVICE) ?? "";
    return device;
  }

  void setAccessToken({required String token}) {
    _setPreference(
        prefName: PREF_ACCESS_TOKEN,
        prefType: PREF_TYPE_STRING,
        prefValue: token);
  }

  Future<String> getAccountID() async {
    String accountID = await _getPreference(prefName: PREF_ACCOUNT_ID) ?? "";
    return accountID;
  }

  void setAccountID({required String accountID}) {
    _setPreference(
        prefName: PREF_ACCOUNT_ID,
        prefValue: accountID,
        prefType: PREF_TYPE_STRING);
  }

  void setDomain({required String domain}) {
    _setPreference(
        prefName: PREF_DOMAIN, prefValue: domain, prefType: PREF_TYPE_STRING);
  }

  void setMiniAppPreference({required String key, required String value}) {
    _setPreference(prefName: key, prefValue: value, prefType: PREF_TYPE_STRING);
  }

  void setPrinterType({required String value}) {
    _setPreference(
        prefName: PREF_PRINTER_TYPE,
        prefType: PREF_TYPE_STRING,
        prefValue: value);
  }

  void setPrinterAddress({required String value}) {
    _setPreference(
        prefName: PREF_PRINTER_ADDRESS,
        prefType: PREF_TYPE_STRING,
        prefValue: value);
  }

  Future<String> getMiniAppPreference({required String key}) async {
    return await _getPreference(prefName: key);
  }

  Future<String> getPrinterAddress() async {
    String printerAddress =
        await _getPreference(prefName: PREF_PRINTER_ADDRESS) ?? "";
    return printerAddress;
  }

  Future<bool> getIsLocalAuth() async {
    bool result =
        await _getPreference(prefName: PREF_IS_USING_LOCAL_AUTH) ?? false;
    return result;
  }

  Future<String> getPrinterType() async {
    //return pax/network/bluetooth
    return await _getPreference(prefName: PREF_PRINTER_TYPE) ?? "pax";
  }

  void _setPreference(
      {required String prefName,
      required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      // prefType is bool
      case PREF_TYPE_BOOL:
        {
          _preferences!.setBool(prefName, prefValue);
          break;
        }
      // prefType is int
      case PREF_TYPE_INTEGER:
        {
          _preferences!.setInt(prefName, prefValue);
          break;
        }
      // prefType is double
      case PREF_TYPE_DOUBLE:
        {
          _preferences!.setDouble(prefName, prefValue);
          break;
        }
      // prefType is String
      case PREF_TYPE_STRING:
        {
          _preferences!.setString(prefName, prefValue);
          break;
        }
      //prefType is List<String>
      case PREF_TYPE_LIST_STRING:
        {
          _preferences!.setStringList(prefName, prefValue);
          break;
        }
    }
  }
}
