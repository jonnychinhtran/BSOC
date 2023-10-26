import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pax_pos/app/models/app/device_status_model.dart';
import 'package:pax_pos/app/models/app/printer_status_model.dart';
import 'package:pax_pos/app/models/category_model.dart';
import 'package:pax_pos/app/models/checkin/business_model.dart';
import 'package:pax_pos/app/models/checkin/checkin_model.dart';
import 'package:pax_pos/app/models/key_storage_model.dart';
import 'package:pax_pos/app/models/payment/payment_info_model.dart';
import 'package:pax_pos/app/models/print_model.dart';
import 'package:pax_pos/app/models/staff_model.dart';
import 'package:pax_pos/app/models/tip_model.dart';
import 'package:pax_pos/app/network/network_endpoints.dart';
import 'package:pax_pos/app/repositories/payment/models/PaymentStatusModel.dart';
import 'package:pax_pos/app/view_models/home_view_model.dart';
import 'package:pax_pos/extensions/pax/models/response/pax_device_info.dart';
import 'package:pax_pos/extensions/pax/pax.dart';
import 'package:pax_pos/utils/network/network_util2.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../app/models/subject_template_model.dart';
import 'app_preferences.dart';

class AppDataGlobal {
  //-------------------------------------------------------------  Constants ------------------------------------------------------------

  //-------------------------------------------------------------------- Variables -------------------------------------------------------------------
  LogzIoApiAppender? logzIoApiSender;
  String accountID = "";
  String domain = "";
  String _accessToken = "";

  String? currentOrderId;
  bool _showPopupSettingPaxInfo = false;
  bool _showPopupSettingCloverInfo = false;
  bool _isPosCalendar = false;
  bool _isPaxStatus = false;

  List<StaffModel> _listStaffModel = [];
  List<CategoryModel> _listCategoryModel = [];
  List<SubjectTemplateModel> _listTemplateModel = [];
  BusinessModel? _businessModel;

  String _currentPairingCode = "";
  bool isFillCreditCard = false;

  int _incomePrintId = 0;

  HomeViewModel? _homeViewModel;
  KeyStorageModel? _keyStorageModel;
  PaymentStatusModel? _paymentStatusModel;
  TipModel? _tipModel;
  String _scannerData = "";
  String _signature = "";
  String _paxMode = "";

  HomeViewModel? get homeViewModel => _homeViewModel;
  KeyStorageModel? get keyStorageModel => _keyStorageModel;
  PaymentStatusModel? get getPaymentStatus => _paymentStatusModel;
  PaymentInfoModel? selectedPayment;
  TipModel? get tipModel => _tipModel;
  CheckInModel? checkinModel;
  PaxDeviceInfo? _paxDeviceInfo;
  PrinterStatusModel? _printerStatusModel;

  bool get isPaxStatus => _isPaxStatus;

  List<StaffModel> get listStaffModel => _listStaffModel;
  List<CategoryModel> get listCategoryModel => _listCategoryModel;
  List<SubjectTemplateModel> get listTemplate => _listTemplateModel;
  BusinessModel? get businessModel => _businessModel;
  String get scannerData => _scannerData;
  String get signature => _signature;
  String get paxMode => _paxMode;
  PaxDeviceInfo? get paxDeviceInfo => _paxDeviceInfo;
  PrinterStatusModel? get printerStatusModel => _printerStatusModel;
  //-------------------------------------------------------------------- Stream -------------------------------------------------------------------

  BehaviorSubject<bool> hasRefreshCheckInModelSelected =
      BehaviorSubject<bool>();

  BehaviorSubject<bool> hasRefreshListStaffModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListCategorySubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListServiceModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListItemModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListPrinterModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListStaffByCheckoutModel =
      BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshListTemplateModel = BehaviorSubject<bool>();

  BehaviorSubject<bool> hasRefreshBusinessModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshPaxTerminalModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshCloverTerminalModel = BehaviorSubject<bool>();

  PublishSubject<bool> hasRefreshPaymentStatusModel = PublishSubject<bool>();
  PublishSubject<bool> hasRefreshChallengeResponseModel =
      PublishSubject<bool>();

  BehaviorSubject<bool> hasRefreshShowPopupSettingPaxInfo =
      BehaviorSubject<bool>();

  BehaviorSubject<bool> hasRefreshKeyStorage = BehaviorSubject<bool>();

  BehaviorSubject<bool> hasHomeViewModel = BehaviorSubject<bool>();

  BehaviorSubject<bool> hasRefreshListCheckin = BehaviorSubject<bool>();

  BehaviorSubject<bool> hasRefreshIncomePrintId = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasRefreshTipModel = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasScannerData = BehaviorSubject<bool>();
  //staff
  BehaviorSubject<bool> hasRefreshListStaffSubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> hasPaxStatusSubject = BehaviorSubject<bool>();
  BehaviorSubject<PrinterStatusModel> hasPrinterStatusSubject =
      BehaviorSubject<PrinterStatusModel>();

  Stream<bool> get listStaffStream => hasRefreshListStaffSubject.stream;
  Stream<bool> get listCategoryModelStream =>
      hasRefreshListCategorySubject.stream;
  Stream<bool> get paxStatusStream => hasPaxStatusSubject.stream;
  Stream<PrinterStatusModel> get printerStatusStream =>
      hasPrinterStatusSubject.stream;

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

  bool get showPopupSettingPaxInfo => _showPopupSettingPaxInfo;

  bool get showPopupSettingCloverInfo => _showPopupSettingCloverInfo;

  int passCodeExpired = 0;

  bool get isPosCalendar => _isPosCalendar;
  String get currentPairingCode => _currentPairingCode;

  int get incomePrintId => _incomePrintId;

  // List<PrinterModel> get listPrinter => _listPrinterModel;

//--------------------------------------------------- Public  Methods -------------------------------------------------------------

  Future<void> userLogout() async {
    AppPreferences().setLoggedIn(isLoggedIn: false);
    AppPreferences().setAccessToken(token: "");

    if (AppDataGlobal().logzIoApiSender != null) {
      logzIoApiSender!.dispose();
    }
  }

  void setPaxStatus({required bool paxStatus}) {
    if (_isPaxStatus != paxStatus) {
      _isPaxStatus = paxStatus;
      hasPaxStatusSubject.add(paxStatus);
    }
  }

  void setPrinterStatus({required PrinterStatusModel printerStatus}) {
    _printerStatusModel = printerStatus;
    hasPrinterStatusSubject.add(printerStatus);
  }

  void setPaxDeviceInfo({required PaxDeviceInfo paxDeviceInfo}) {
    _paxDeviceInfo = paxDeviceInfo;
  }

  void setPaxModeInfo({required String paxMode}) {
    _paxMode = paxMode;
  }

  void setSignatureData({required String value}) {
    _signature = value;
  }

  void setPaymentStatus({required PaymentStatusModel? statusModel}) {
    _paymentStatusModel = statusModel;
    hasRefreshPaymentStatusModel.add(true);
  }

  void setKeyStorage({required KeyStorageModel keyStorageModel}) {
    _keyStorageModel = keyStorageModel;
    hasRefreshKeyStorage.add(true);
  }

  void setListStaff({required List<StaffModel> listStaff}) {
    if (_listStaffModel.isNotEmpty) {
      _listStaffModel.clear();
    }
    for (int i = 0; i < listStaff.length; i++) {
      if (i != 0) {
        _listStaffModel.add(listStaff[i]);
      }
    }
    hasRefreshListStaffSubject.add(true);
  }

  void setListCategory({required List<CategoryModel> listCategory}) {
    if (_listCategoryModel.isNotEmpty) {
      _listCategoryModel.clear();
    }
    _listCategoryModel = listCategory;
    hasRefreshListCategorySubject.add(true);
  }

  void setTip({required TipModel tipModel}) {
    _tipModel = tipModel;
    hasRefreshTipModel.add(true);
  }

  void setTemplateList({required List<SubjectTemplateModel> listTemplate}) {
    _listTemplateModel = listTemplate;
    hasRefreshListTemplateModel.add(true);
  }

  void setBusiness({required BusinessModel businessModel}) {
    _businessModel = businessModel;
    hasRefreshBusinessModel.add(true);
  }

  void setHomeViewModel({required HomeViewModel homeViewModel}) {
    _homeViewModel = homeViewModel;
  }

  void setAccessToken({required accessToken}) {
    _accessToken = accessToken;
  }

  void setDomain({required String inDomain}) {
    this.domain = inDomain;
  }

  void setScannerData({required String scannerData}) {
    _scannerData = scannerData;
    hasScannerData.add(true);
  }

  // void setPrinterList({required List<PrinterModel> listPrinter}) {
  //   _listPrinterModel = listPrinter;
  //   hasRefreshListPrinterModel.add(true);
  // }

  void initDomainApi({required String domain, @required clientID}) {
    AppDataGlobal().domain = domain;
    AppDataGlobal().accountID = clientID;
    print(
        "Set [$clientID] Base URl API ${domain + NetworkEndpoints.BASE_API + NetworkEndpoints.BASE_API_VERSION}");
    NetworkUtil2().setBaseUrl(
        baseUrl: domain +
            NetworkEndpoints.BASE_API +
            NetworkEndpoints.BASE_API_VERSION);
    NetworkUtil2()
        .setHeaderData(headerData: {NetworkEndpoints.G_KEY_HEADER: clientID});
    NetworkUtil2().baseOptions!.connectTimeout = 15000;
    NetworkUtil2().baseOptions!.receiveTimeout = 15000;
    // Set LOGGER
    if (kReleaseMode) {
      createLogger(gciID: clientID);
    }
  }

  createLogger({required String gciID}) async {
    // clear logz
    if (logzIoApiSender != null) {
      logzIoApiSender!.dispose();
    }
    Logger.root.level = Level.ALL;
    PackageInfo packageInfo =
        await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      return packageInfo;
    });
    // Sentry Client
    Sentry.configureScope((scope) {
      scope.setTag('gci_id', gciID);
      scope.setTag("os_version", Platform.operatingSystemVersion);
      scope.setTag("version", packageInfo.version);
      scope.setTag("build", packageInfo.buildNumber);
      return scope;
    });
    logzIoApiSender = LogzIoApiAppender(
      apiToken: "PqYUeqvgCuwbEaqanQSIMblacMwQSAbI",
      url: "https://listener.logz.io:8071/",
      labels: {
        "app": "gopos-on-pax",
        "version": packageInfo.version,
        "build": packageInfo.buildNumber,
        "os": Platform.operatingSystem,
        'os_version': Platform.operatingSystemVersion,
        "G-ClientID": gciID
      },
    )..attachToLogger(Logger.root);
  }

  void dispose() {
    hasRefreshCheckInModelSelected.close();
    hasRefreshListStaffModel.close();
    hasRefreshListServiceModel.close();
    hasRefreshListItemModel.close();
    hasRefreshListPrinterModel.close();
    hasRefreshPaymentStatusModel.close();
    hasRefreshBusinessModel.close();
    hasRefreshPaxTerminalModel.close();
    hasRefreshCloverTerminalModel.close();
    hasRefreshShowPopupSettingPaxInfo.close();
    hasRefreshKeyStorage.close();
    hasHomeViewModel.close();
    hasRefreshListCheckin.close();
    hasRefreshIncomePrintId.close();
    hasRefreshTipModel.close();
    hasScannerData.close();
    hasRefreshListStaffSubject.close();
    hasRefreshListCategorySubject.close();
    hasPaxStatusSubject.close();
    hasPrinterStatusSubject.close();
  }

  void setCurrentPairingCode({required currentPairingCode}) {
    _currentPairingCode = currentPairingCode;
  }
}
