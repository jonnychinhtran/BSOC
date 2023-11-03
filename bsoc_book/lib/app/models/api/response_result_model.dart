import '../../network/network_config.dart';

class ResponseResultModel {
  String? status;
  String? message;
  dynamic data;
  dynamic error;

  ResponseResultModel({this.status, this.message, this.data, this.error});

  factory ResponseResultModel.fromJson(dynamic json) {
    return ResponseResultModel(
        status: json[NetworkConfig.API_KEY_RESPONSE_STATUS],
        error: json[NetworkConfig.API_KEY_RESPONSE_ERROR],
        message: json[NetworkConfig.API_KEY_RESPONSE_MESSAGE],
        data: json[NetworkConfig.API_KEY_RESPONSE_DATA]);
  }
}
