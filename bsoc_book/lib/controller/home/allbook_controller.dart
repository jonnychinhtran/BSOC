// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
// import 'package:bsoc_book/data/model/books/allbook_model.dart';
// import 'package:dio/dio.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AllBooksController extends GetxController {
//   RxList<AllBookModel> books = RxList<AllBookModel>([]);
//   RxBool isLoading = RxBool(true);
//   final box = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     getAllBooks();
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result != ConnectivityResult.none) {
//         getAllBooks();
//       }
//     });
//   }

//   Future<void> getAllBooks() async {
//     String? token;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = box.read('isLoggedIn');
//     if (isLoggedIn) {
//       token = prefs.getString('accessToken');
//     }

//     try {
//       var response = await Dio().get(
//         'http://103.77.166.202/api/book/all-book',
//         options: isLoggedIn
//             ? Options(headers: {'Authorization': 'Bearer $token'})
//             : null,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data['content'];
//         books.assignAll(
//             data.map((json) => AllBookModel.fromJson(json)).toList());
//         isLoading.value = false;
//       } else {
//         throw Exception('Failed to get books');
//       }
//     } on DioError catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
