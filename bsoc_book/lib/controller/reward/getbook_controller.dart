import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/book_reward_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController extends GetxController {
  List<BookRewardModel> listbook = [];
  bool isLoading = true;
  final box = GetStorage();
  String? token;

  @override
  void onInit() {
    super.onInit();
    getAllBooks();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getAllBooks();
      }
    });
  }

  Future<void> getAllBooks() async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = box.read('isLoggedIn');
    if (isLoggedIn) {
      token = box.read('accessToken');
    }

    try {
      var response = await Dio().get(
        'http://103.77.166.202/api/book/all-book',
        options: isLoggedIn
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['content'];
        listbook = data.map((json) => BookRewardModel.fromJson(json)).toList();
        isLoading = false;
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        // Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
    update();
  }
}
