import 'dart:convert';

import 'package:http/http.dart' as http;

class GapHttpRequest {
  Future<String> get(String url, {int timeOut = 30}) async {
    //HttpClient client = new HttpClient();
    // HTTP REQUEST
    return http
        .get(Uri.parse(url))
        .timeout(Duration(seconds: timeOut)) // Make HTTP-GET request
        .then((http.Response response) {
      // On response received
      // Get response status code
      final int statusCode = response.statusCode;

      // Check response status code for error condition
      if (statusCode < 200 || statusCode > 400 || json == null) {
        // Error occurred
        print("Network Util ERROR : $url");
        throw new Exception("Error while fetching data");
      } else {
        // No error occurred
        // Get response body
        final String res = response.body;
        // Convert response body to JSON object
        return res;
      }
    });
  }

  Future<String> post(String url, data, {int timeOut = 30}) async {
    //HttpClient client = new HttpClient();
    // HTTP REQUEST
    return http
        .post(Uri.parse(url), body: data)
        .timeout(Duration(seconds: timeOut)) // Make HTTP-GET request
        .then((http.Response response) {
      // On response received
      // Get response status code
      final int statusCode = response.statusCode;

      // Check response status code for error condition
      if (statusCode < 200 || statusCode > 400 || json == null) {
        // Error occurred
        print("Network Util ERROR : $url");
        throw new Exception("Error while fetching data");
      } else {
        // No error occurred
        // Get response body
        final String res = response.body;
        // Convert response body to JSON object
        return res;
      }
    });
  }
}
