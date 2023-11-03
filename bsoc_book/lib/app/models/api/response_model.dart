import 'package:bsoc_book/app/models/api/response_result_model.dart';
import 'package:bsoc_book/app/models/login/login_response_model.dart';

import '../../network/network_config.dart';

class ResponseModel {
  int? statusCode;
  // dynamic message;
  // dynamic error;
  // dynamic resultRaw;
  LoginResponseModel? data;
  dynamic content;

  ResponseModel({this.statusCode, this.data, this.content});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        statusCode: json[NetworkConfig.API_KEY_RESPONSE_STATUS],
        // message: json[NetworkConfig.API_KEY_RESPONSE_MESSAGE],
        // resultRaw: (json[NetworkConfig.API_KEY_RESPONSE_RESULT] != null)
        //     ? json[NetworkConfig.API_KEY_RESPONSE_RESULT]
        //     : null,
        data: LoginResponseModel.fromJson(
            json[NetworkConfig.API_KEY_RESPONSE_DATA]));
    // data: (null != json[NetworkConfig.API_KEY_RESPONSE_RESULT])
    //     ? ResponseResultModel.fromJson(
    //         json[NetworkConfig.API_KEY_RESPONSE_RESULT])
    //     : null,
    // error: json[NetworkConfig.API_KEY_RESPONSE_ERROR]);
  }
}
