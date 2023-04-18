import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/view/rewards/rewards.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

List? listReponse;
Map? dataBook;

class RewardsDetail extends StatefulWidget {
  const RewardsDetail({super.key, required this.userId, required this.bookId});
  final String userId;
  final String bookId;
  @override
  State<RewardsDetail> createState() => _RewardsDetailState();
}

class _RewardsDetailState extends State<RewardsDetail> {
  bool isLoading = true;
  String? token;

  Future<void> getItemBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    try {
      var response = await Dio()
          .get('http://103.77.166.202/api/book/getBook/${widget.bookId}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200) {
        dataBook = response.data;
        listReponse = dataBook!['chapters'];
        print('ID REVIEW: ${dataBook!['id'].toString()} ');
        print(listReponse);
        setState(() {
          isLoading = false;
        });
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        // Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  @override
  void initState() {
    getItemBooks();
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
                    MaterialPageRoute(builder: (context) => RewardsPage()));
              })),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final connected = connectivity != ConnectivityResult.none;
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              Positioned(
                height: 0.0,
                left: 0.0,
                right: 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  color: connected
                      ? const Color(0xFF00EE44)
                      : const Color(0xFFEE4400),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: connected
                        ? const Text('ONLINE')
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('OFFLINE'),
                              SizedBox(width: 8.0),
                              SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        },
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                color: Color.fromARGB(255, 138, 175, 52),
                secondRingColor: Colors.black,
                thirdRingColor: Colors.purple,
                size: 30,
              ))
            : RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 195,
                                width: 150,
                                child: Material(
                                  child: Image.network(
                                    dataBook?['image'] == null
                                        ? "Đang tải..."
                                        : 'http://103.77.166.202' +
                                            dataBook?['image'],
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            SizedBox(height: size.height * 0.02),
                            Text(
                                dataBook?['bookName'] == null
                                    ? "Đang tải..."
                                    : dataBook?['bookName'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: size.height * 0.02),
                            Text(
                                dataBook?['description'] == null
                                    ? "Đang tải..."
                                    : dataBook?['description'],
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    )),
              ),
      ),
      floatingActionButton: SizedBox(
        height: 30.0,
        child: dataBook?['payment'] != true
            ? Center(
                child: Container(
                  width: 250,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? token;

                      final prefs = await SharedPreferences.getInstance();
                      token = prefs.getString('accessToken');

                      int? bookid = dataBook!['id'];

                      var response = await Dio().post(
                          'http://103.77.166.202:9999/api/payment/open-book/${widget.userId}/$bookid',
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}));
                      if (response.statusCode == 200) {
                        final jsondata = response.data;
                        getItemBooks();
                        print(jsondata);
                        Get.snackbar(
                            "Thành công", "Đổi thưởng sách thành công.");
                      } else {
                        Get.snackbar(
                            "Lỗi", "Đổi thưởng sách thất bại. Thử lại.");
                      }
                      print("res: ${response.data}");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      onSurface: Colors.amber, // Disable color
                    ),
                    child: const Text(
                      'Đổi thưởng',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: 250,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Color.fromARGB(255, 255, 255, 255),
                      onSurface:
                          Color.fromARGB(255, 145, 109, 0), // Disable color
                    ),
                    child: const Text(
                      'Đã đổi thưởng',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
