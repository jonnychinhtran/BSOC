import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/topbook_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopBookController extends GetxController {
  RxList<TopbookModel> topbooks = RxList<TopbookModel>([]);
  RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    getTopBook();
    // Start listening for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getTopBook(); // Call getAllBooks again to refresh data
      }
    });
  }

  Future<void> getTopBook() async {
    String? token;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get(
        'http://103.77.166.202/api/book/top-book',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        print(response.data);
        List<dynamic> data = response.data;
        topbooks.assignAll(
            data.map((json) => TopbookModel.fromJson(json)).toList());
        isLoading.value = false;
      } else {
        throw Exception('Failed to get top books');
      }
    } on DioError catch (e) {
      throw Exception(e.toString());
    }
  }
}
