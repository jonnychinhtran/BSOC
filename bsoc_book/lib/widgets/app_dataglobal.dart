import 'dart:io';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app_preferences.dart';

class AppDataGlobal {
  //-------------------------------------------------------------  Constants ------------------------------------------------------------

  //-------------------------------------------------------------------- Variables -------------------------------------------------------------------
  String domain = "";
  String _accessToken = "";

  String? currentBookId;

  HomeViewModel? _homeViewModel;

  HomeViewModel? get homeViewModel => _homeViewModel;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  //-------------------------------------------------------------------- Stream -------------------------------------------------------------------
  BehaviorSubject<bool> hasHomeViewModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshUserModel = BehaviorSubject<bool>();

  //-------------------------------------------------------------------- Singleton ----------------------------------------------------------------------
  // Final static instance of class initialized by private constructor
  static final AppDataGlobal _instance = AppDataGlobal._internal();

  // Factory Constructor
  factory AppDataGlobal() => _instance;

  /// AppPreference Private Internal Constructor -> AppPreference
  AppDataGlobal._internal() {
    // Constructor AppDataGlobal
  }

//------------------------------------------------------- Getter Methods -----------------------------------------------------------

  String get accessToken => _accessToken;

//--------------------------------------------------- Public  Methods -------------------------------------------------------------

  Future<void> userLogout() async {
    AppPreferences().setLoggedIn(isLoggedIn: false);
    AppPreferences().setAccessToken(token: "");
  }

  void setDomain({required String inDomain}) {
    this.domain = inDomain;
  }

  void setHomeViewModel({required HomeViewModel homeViewModel}) {
    _homeViewModel = homeViewModel;
  }

  void setAccessToken({required accessToken}) {
    _accessToken = accessToken;
  }

  void setUser({required UserModel userModel}) {
    _userModel = userModel;
    hasRefreshUserModel.add(true);
  }

  void initDomainApi({required String domain}) {
    AppDataGlobal().domain = domain;
    print("Set Base URl API ${domain + NetworkEndpoints.BASE_API_VERSION}");
    NetworkUtil2()
        .setBaseUrl(baseUrl: domain + NetworkEndpoints.BASE_API_VERSION);
    NetworkUtil2().baseOptions!.connectTimeout = 15000;
    NetworkUtil2().baseOptions!.receiveTimeout = 15000;
  }

  void dispose() {
    hasHomeViewModel.close();
    hasRefreshUserModel.close();
  }
}
