import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/topbook_model.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopBookController extends GetxController {
  RxList<TopbookModel> topbooks = RxList<TopbookModel>([]);
  RxBool isLoading = RxBool(true);
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getTopBook();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getTopBook();
      }
    });
  }

  Future<void> getTopBook() async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = box.read('isLoggedIn');
    if (isLoggedIn) {
      token = prefs.getString('accessToken');
    }

    try {
      var response = await Dio().get(
        'http://103.77.166.202/api/book/top-book',
        options: isLoggedIn
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        print('Res top book: ${response.data}');
        List<dynamic> data = response.data;
        topbooks.assignAll(
            data.map((json) => TopbookModel.fromJson(json)).toList());
        isLoading.value = false;
      } else {
        throw Exception('Failed to get books');
      }
    } on DioError catch (e) {
      throw Exception(e.toString());
    }
  }
}
