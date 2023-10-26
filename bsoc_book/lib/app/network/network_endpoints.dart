class NetworkEndpoints {
  static const String DNS_SERVER = "";
  static const String BASE_URL = "https://gci2020.fast-boy.net";
  static const String BASE_API = "";
  static const String BASE_API_VERSION = "/v1" + BASE_MODULE;
  static const String BASE_MODULE = "/pos";
  static const String G_KEY_HEADER = "G-ClientID";

  static const String BASE_APP_GCI_MODULE = "/gocheckin";

  //User Form Login
  static const String POST_LOGIN_API = '/user/form/login';

  //checkin
  static const String POST_CHECK_IN_FORM_SUBMIT = '/checkin/form/submit';
  static const String GET_CHECK_IN_LIST = '/checkin/site/list';
  static const String GET_CHECK_IN_REPORT = '/checkin/site/report';
  static const String GET_LAST_CHECK_IN = '/checkin/site/check-update';
  static const String GET_CHECK_IN_INFO = '/checkin/site/info';

  //customer
  static const String GET_CUSTOMER_LIST = '/customer/site/list';
  static const String UPDATE_CUSTOMER_ORDER = '/customer/form/update';

  //category
  static const String GET_CATEGORY_LIST_ITEM = '/category/site/list-item';

  //staff
  static const String GET_STAFF_LIST = '/staff/site/list';

  //service
  static const String GET_SERVICE_LIST = '/service/site/list';

  //setting
  static const String GET_TIP = '/setting/site/get-tip';

  //check out
  static const String GET_ITEM_LIST = '/item/site/list';
  static const String GET_CHECK_OUT_HISTORY_LIST = '/checkout/history/list';
  static const String GET_CHECK_OUT_INFO = '/checkout/site/info';
  static const String GET_CHECKOUT_HISTORY_INFO = '/checkout/history/info';
  static const String GET_CHECKOUT_BATCH_CLOSE_SUMMARY =
      '/checkout/site/get-batch-close-summary';
  static const String POST_CHECKOUT_ADD_ITEM = '/checkout/item/add';
  static const String POST_CHECKOUT_REMOVE_ITEM = '/checkout/item/remove';
  static const String POST_CHECKOUT_EDIT_ITEM = '/checkout/item/update-item';
  static const String POST_CHECKOUT_DELETE_BY_STAFF =
      '/checkout/item/delete-by-staff';
  static const String POST_UPDATE_STAFF_ORDER = '/checkout/item/update-staff';
  static const String POST_UPDATE_STAFF_ORDER_DONE =
      '/checkout/form/update-staff';
  static const String POST_CHECKOUT_SUBMIT_ORDER = '/checkout/payment/submit';
  static const String POST_CHECKOUT_UPDATE_STATUS =
      '/checkout/form/update-status';
  static const String POST_CHECKOUT_UPDATE_ORDER_WITH_CREDIT_CARD_PAYMENT =
      '/checkout/form/update-order-with-credit-card-payment';
  static const String POST_CHECKOUT_DO_AUTH = '/checkout/form/do-auth';
  static const String POST_CHECKOUT_VOID_PAYMENT =
      '/checkout/form/void-payment';
  static const String POST_CHECKOUT_PAYMENT_ADD_ATTACHMENT =
      '/checkout/payment/add-attachment';
  static const String POST_CHECKOUT_REFUND_PAYMENT =
      '/checkout/form/refund-payment';
  static const String POST_CHECKOUT_ADJUST_TIP_PAYMENT =
      '/checkout/form/adjust-tip';
  static const String POST_CHECKOUT_CLOSE_OUT = '/checkout/form/closeout';
  static const String POST_CHECKOUT_UPDATE_IS_WAITING =
      '/checkout/form/update-is-wait';
  static const String POST_CHECKOUT_DISCOUNT_PROMOTION =
      '/checkout/discount/promotion';
  static const String POST_CHECKOUT_DISCOUNT_REDEEM =
      '/checkout/discount/redeem';
  static const String POST_CHECKOUT_UPDATE_TIP_DATA = '/checkout/tip/update';
  static const String POST_CHECKOUT_ITEM_ADJUST_PRICE =
      '/checkout/item/adjust-price';
  static const String POST_CHECKOUT_UPDATE_PAYMENT_DATA =
      '/checkout/form/update-payment-data';
  static const String POST_CHECKOUT_ITEM_ADD_COMBO = '/checkout/item/add-combo';
  static const String GET_CHECKOUT_RESEND_RATING =
      '/checkout/form/send-mercure';
  static const String POST_CUSTOMER_ACH_AVAILABLE = '/ach/form/check-customer';
  static const String POST_ACH_RESEND = '/ach/form/resend-transaction';
  static const String POST_ACH_VOID = '/ach/form/cancel-transaction';
  static const String POST_UPDATE_ORDER_SUCCESS_TO_SETTLED =
      '/checkout/form/update-success-to-settled';
  static const String POST_CALCULATE_TAX = '/checkout/form/calculate-tax';

  //gift card
  static const String GET_CHECK_GIFT_CARD = '/giftcard/site/check-gift-card';
  static const String POST_RESET_GIFT_CARD = '/checkout/item/reset-gift-card';

  //combo
  static const String GET_COMBO_SITE_INFO = '/combo/site/info';

  //business
  static const String GET_BUSINESS_INFO = '/business/site/get-info';
  static const String POST_BUSINESS_UPDATE_INFO = '/business/form/update';

  //payment terminal
  static const String GET_PAYMENT_TERMINAL_LIST =
      '/setting/payment-terminal/list';
  static const String POST_PAYMENT_TERMINAL_CREATE_PAX =
      '/setting/payment-terminal/create';

  //staff daily income
  static const String GET_STAFF_SITE_LIST_INCOME = '/staff/site/list-income';
  static const String GET_STAFF_DAILY_INCOME = '/staff/site/list-income-v1';

  //payroll
  static const String GET_PAYROLL_LIST = '/payroll/site/app-list-payroll';

  // Order

  static const String GET_ORDER_BY_ID = '/checkout/site/info';
  static const String GET_ORDER_BY_CHECKIN_ID =
      '/checkout/site/info-by-checkin';

  //unsubscribe contact
  static const String EMS_GCI = "http://ems.gci.fast-boy.net/api";
  static const String POST_UNSUBSCRIBE_CONTACT =
      EMS_GCI + "/unsubscribe-contact";

  //Batch history
  static const String GET_BATCH_HISTORY_LIST = '/history/site/batch-history';
  static const String GET_BATCH_HISTORY_LIST_V2 =
      '/history/site/batch-history-v2';
  static const String GET_OPEN_BATCH_HISTORY = '/history/site/open-batch';
  static const String GET_BATCH_OPEN_DETAIL = '/history/site/batch-open-detail';
  static const String GET_BATCH_DETAIL = '/history/site/batch-detail';

  //Get promotion discount, reward discount, giftcard discount
  static const String GET_PROMOTION_DISCOUNT =
      '/history/site/promotion-discount';
  static const String GET_REWARD_DISCOUNT = '/history/site/reward-discount';
  static const String GET_GIFTCARD_DISCOUNT = '/history/site/giftcard-discount';

  // static const String GET_SERVICE_FEE =
  //     '$BASE_URL/v1/gocheckin/settings/site/get-service-fee';

  //send email,sms
  static const String SEND_EMAIL_SMS = '/checkout/invoice/send';

  //income history
  static const String GET_INCOME_HISTORY = '/history/site/income-history';

  //Printers
  static const String GET_PRINTER_LIST = '/printer/site/list';
  static const String GET_PRINTER_DETAIL = '/printer/site/detail';
  static const String CREATE_PRINTER_INFO = '/printer/site/create';
  static const String UPDATE_PRINTER_INFO = '/printer/site/update';

  //Ticket template
  static const String GET_TICKET_TEMPLATE = '/ticket/site/template';

  //
  static const String GET_STAFF_LIST_BY_CHECKOUT =
      '/staff/site/list-by-checkout';

  //timekeeping
  static const String GET_TIMEKEEPING_LIST = '/timekeeping/site/list-staff';
  static const String POST_TIMEKEEPING_CHECK_IN =
      '/timekeeping/form/add-checkin-time';
  static const String POST_TIMEKEEPING_CHECK_OUT =
      '/timekeeping/form/add-checkout-time';

  //setting turn
  static const String GET_TURN_VALUE = '/setting/site/get-turn-value';
  static const String POST_TURN_UPDATE_VALUE =
      '/setting/form/update-turn-value';

  //key storage
  static const String GET_KEY_STORAGE = '/user/site/get-key-storage';
}
