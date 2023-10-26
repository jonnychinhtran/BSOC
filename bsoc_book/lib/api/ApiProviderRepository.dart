import 'package:bsoc_book/utils/network/network_util.dart';

abstract class ApiProviderRepository {
  final NetworkUtil2 _client = NetworkUtil2();
  String domain;
  String accountID;
  String accessToken;
  NetworkUtil2 apiClient() => _client;
  ApiProviderRepository(
      {this.accountID = "", this.accessToken = "", this.domain = ""});
}
