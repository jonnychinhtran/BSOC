import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/allbook_model.dart';
import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:bsoc_book/view/rewards/rewards_detail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map? datauser;

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  List<AllBookModel> listbook = [];
  bool isLoading = true;
  String? token;

  Future<void> getUserDetail() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response =
          await Dio().get('http://103.77.166.202:9999/api/user/profile',
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200) {
        datauser = response.data;
        await prefs.setString('username', datauser!['username']);
        await prefs.setString('avatar', datauser!['avatar']);
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      // print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  Future<void> getAllBooks() async {
    String? token;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get('http://103.77.166.202/api/book/all-book',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['content'];
        setState(() {
          listbook = data.map((json) => AllBookModel.fromJson(json)).toList();
          isLoading = false;
        });
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  // Future<void> callback() async {
  //   if (connectivity == ConnectivityResult.none) {
  //     isLoading = true;
  //   } else {
  //     getUserDetail();
  //   }
  // }

  @override
  void initState() {
    InternetPopup().initialize(context: context);
    getAllBooks();
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InforPage()));
              }),
          title: Container(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/images/point.png'),
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: datauser?['pointForClaimBook'] == null
                        ? Text(
                            '0',
                          )
                        : Text(datauser!['pointForClaimBook'].toString()),
                  )
                ],
              )),
        ),
        body:
            // OfflineBuilder(
            //     connectivityBuilder: (
            //       BuildContext context,
            //       ConnectivityResult connectivity,
            //       Widget child,
            //     ) {
            //       final connected = connectivity != ConnectivityResult.none;
            //       return Stack(
            //         fit: StackFit.expand,
            //         children: [
            //           child,
            //           Positioned(
            //             height: 0.0,
            //             left: 0.0,
            //             right: 0.0,
            //             child: AnimatedContainer(
            //               duration: const Duration(milliseconds: 350),
            //               color: connected
            //                   ? const Color(0xFF00EE44)
            //                   : const Color(0xFFEE4400),
            //               child: AnimatedSwitcher(
            //                 duration: const Duration(milliseconds: 350),
            //                 child: connected
            //                     ? const Text('ONLINE')
            //                     : Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: const <Widget>[
            //                           Text('OFFLINE'),
            //                           SizedBox(width: 8.0),
            //                           SizedBox(
            //                             width: 12.0,
            //                             height: 12.0,
            //                             child: CircularProgressIndicator(
            //                               strokeWidth: 2.0,
            //                               valueColor: AlwaysStoppedAnimation<Color>(
            //                                   Colors.white),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //     child:
            isLoading
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : RefreshIndicator(
                    onRefresh: () async {
                      getAllBooks();
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: listbook.length,
                        itemBuilder: (BuildContext context, int index) {
                          final book = listbook[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RewardsDetail(
                                          userId: datauser!['id'].toString(),
                                          bookId: book.id.toString())));
                            },
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height * 0.20,
                                      width: size.width * 0.4,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: NetworkImage(
                                                book.image == null
                                                    ? "Đang tải..."
                                                    : 'http://103.77.166.202' +
                                                        book.image.toString(),
                                              ))),
                                    ),
                                    Container(
                                      width: 200,
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.bookName == null
                                                ? "Đang tải..."
                                                : book.bookName.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  margin: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Image.asset(
                                                      'assets/images/point.png'),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Text(
                                                    '1',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .orangeAccent
                                                            .shade700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
        // )
        );
  }
}
