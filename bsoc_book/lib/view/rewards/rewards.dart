import 'package:bsoc_book/controller/reward/getbook_controller.dart';
import 'package:bsoc_book/controller/reward/user_controller.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/allbook_model.dart';
import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:bsoc_book/view/rewards/rewards_detail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final UserController userController = Get.put(UserController());
  final BookController bookController = Get.put(BookController());

  @override
  void initState() {
    // InternetPopup().initialize(context: context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.getUserDetail();
      await bookController.getAllBooks();
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InforPage()),
              );
            },
          ),
          title: Container(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/point.png'),
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: GetBuilder<UserController>(
                    builder: (controller) => Text(
                      controller.datauser?['pointForClaimBook'] == null
                          ? '0'
                          : controller.datauser!['pointForClaimBook']
                              .toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: GetBuilder<BookController>(
          builder: (bookController) {
            return GetBuilder<UserController>(
              builder: (userController) {
                if (userController.isLoading.value ||
                    bookController.isLoading) {
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Color.fromARGB(255, 138, 175, 52),
                      secondRingColor: Colors.black,
                      thirdRingColor: Colors.purple,
                      size: 30,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: bookController.listbook.length,
                    itemBuilder: (BuildContext context, int index) {
                      final book = bookController.listbook[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RewardsDetail(
                                  userId:
                                      userController.datauser!['id'].toString(),
                                  bookId: book.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
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
                                        ),
                                      ),
                                    ),
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
                                                margin:
                                                    EdgeInsets.only(right: 8.0),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors
                                                        .orangeAccent.shade700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                }
              },
            );
          },
        ));
  }
}
