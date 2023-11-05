import 'dart:async';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/view/user/home/components/item_book.dart';
import 'package:bsoc_book/app/view/user/home/components/item_top_book.dart';
import 'package:bsoc_book/app/view/user/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/controller/home/allbook_controller.dart';
import 'package:bsoc_book/controller/home/topbook_controller.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/allbook_model.dart';
import 'package:bsoc_book/data/model/books/topbook_model.dart';
import 'package:bsoc_book/app/view/banner/company_page.dart';
import 'package:bsoc_book/app/view/banner/job_page.dart';
import 'package:bsoc_book/app/view/infor/infor_page.dart';
import 'package:bsoc_book/app/view/quiz/practice.dart';
import 'package:bsoc_book/app/view/search/search_page.dart';
import 'package:bsoc_book/app/view/user/book/book_detail_page.dart';
import 'package:bsoc_book/app/view/wheel_spin/wheel_page.dart';
import 'package:bsoc_book/app/view/widgets/alert_dailog.dart';
import 'package:bsoc_book/app/view/widgets/menu_aside.dart';
import 'package:bsoc_book/app/view/widgets/updatedialog.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_flutter/social_media_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
  });
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel _homeViewModel;
  bool _loadingIsWaiting = false;
  // final AuthController authController = Get.find();

  // final getAllBooksController = Get.put(AllBooksController());

  // final getTopBookController = Get.put(TopBookController());

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    AppDataGlobal().setHomeViewModel(homeViewModel: _homeViewModel);
    _homeViewModel.getListBook();
    _homeViewModel.getListTopBook();
    _homeViewModel.listTopBookStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });
    _homeViewModel.bookModelSubjectStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await getAllBooksController.getAllBooks();
    //   // print('All book: ${getAllBooksController.getAllBooks()}');
    //   await getTopBookController.getTopBook();
    //   // print('Top book: ${getAllBooksController.getAllBooks()}');
    // });
    // final newVersion = NewVersion(
    //   iOSId: 'com.b4usolution.app.bsoc',
    //   androidId: 'com.b4usolution.b4u_bsoc',
    // );
    // checkNewVersion(newVersion);
    super.initState();
  }

  _onTapNextPage(BookModel bookModel) async {
    print('object $bookModel');
    setState(() {
      _loadingIsWaiting = true;
    });
    widget.homeViewModel.bookId = bookModel.id!;
    widget.homeViewModel.getBookDetailPage().then((value) {
      if (value != null) {
        BookModel bookModel = value;
        setState(() {
          _loadingIsWaiting = false;
        });
        if (bookModel.chapters.isNotEmpty) {
          widget.parentViewState.jumpPageBookDetailPage();
        }
      }
    });
  }

  // void showErrorDialog(BuildContext context, String error) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text('Error'),
  //       content: Text(error),
  //       actions: [
  //         TextButton(
  //           child: Text('OK'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void checkNewVersion(NewVersion newVersion) async {
  //   final status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     if (status.canUpdate) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return UpdateDialog(
  //             allowDismissal: true,
  //             description: status.releaseNotes!,
  //             version: status.storeVersion,
  //             appLink: status.appStoreLink,
  //           );
  //         },
  //       );
  //     }
  //     print(status.appStoreLink);
  //     print(status.storeVersion);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CompanyPage()));
                          },
                          child: Container(
                              width: 170,
                              child: Image.asset('assets/images/banner1.png',
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const JobPage()));
                          },
                          child: Container(
                              width: 170,
                              child: Image.asset('assets/images/banner3.jpg',
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  const Padding(
                    padding: EdgeInsets.only(left: 13.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Luyện thi "IELTS - TOEIC - IT - PSM1"',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/images/practice2.png'),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  const Padding(
                    padding: EdgeInsets.only(left: 13.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Vòng quay may mắn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/images/banner-wheel.jpg'),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Padding(
                    padding: EdgeInsets.only(left: 13.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TOP 5 SÁCH HAY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  StreamBuilder<bool>(
                      stream: _homeViewModel.listTopBookStream,
                      builder: (context, snapshot) {
                        final data = _homeViewModel.checkListTopBook;
                        print('DU LIEU TRANG HOME 1 $data');
                        if (data != null && data['list'] != null) {
                          return ItemTopBook(
                            topBookModel: data['list'],
                            onTapNextPage: (BookModel bookModel) {
                              _onTapNextPage(bookModel);
                            },
                          );
                        }
                        return Container();
                      }),
                  SizedBox(height: size.height * 0.04),
                  const Padding(
                    padding: EdgeInsets.only(left: 13.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'THƯ VIỆN SÁCH',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  StreamBuilder<bool>(
                      stream: _homeViewModel.bookModelSubjectStream,
                      builder: (context, snapshot) {
                        final dataBook = _homeViewModel.checkListBook;
                        print('DU LIEU TRANG HOME 2 $dataBook');
                        if (dataBook != null && dataBook['list'] != null) {
                          return ItemBook(
                            bookModel: dataBook['list'],
                            onTapNextPage: (BookModel bookModel) {
                              _onTapNextPage(bookModel);
                            },
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
            (true == _loadingIsWaiting)
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : Container(),
          ],
        ),
      )),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return WillPopScope(
//         onWillPop: () {
//           return Future.value(false);
//         },
//         child: Scaffold(
//             drawer: MenuAside(),
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               centerTitle: true,
//               title: const Text(
//                 'B4U BSOC',
//                 style: TextStyle(color: Colors.black),
//               ),
//               leading: IconButton(
//                 icon: Icon(Icons.person_outline_rounded),
//                 color: Colors.black,
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => InforPage()));
//                 },
//               ),
//               actions: [
//                 Theme(
//                     data: Theme.of(context).copyWith(
//                       dividerColor: Colors.white,
//                       iconTheme: IconThemeData(color: Colors.white),
//                       textTheme: TextTheme().apply(bodyColor: Colors.white),
//                     ),
//                     child: PopupMenuButton<int>(
//                         color: Colors.white,
//                         itemBuilder: (context) => [
//                               PopupMenuItem<int>(
//                                 value: 0,
//                                 child: SocialWidget(
//                                   placeholderText: 'B4U Solution',
//                                   iconData: SocialIconsFlutter.facebook_box,
//                                   link:
//                                       'https://www.facebook.com/groups/376149517873940',
//                                   iconColor: Color.fromARGB(255, 0, 170, 255),
//                                   placeholderStyle: TextStyle(
//                                       color: Colors.black, fontSize: 20),
//                                 ),
//                               ),
//                               PopupMenuItem<int>(
//                                 value: 1,
//                                 child: SocialWidget(
//                                   placeholderText: 'B4U Solution',
//                                   iconData: SocialIconsFlutter.linkedin_box,
//                                   link:
//                                       'https://www.linkedin.com/in/b4usolution-b16383128/',
//                                   iconColor: Colors.blueGrey,
//                                   placeholderStyle: TextStyle(
//                                       color: Colors.black, fontSize: 20),
//                                 ),
//                               ),
//                               PopupMenuItem<int>(
//                                 value: 2,
//                                 child: SocialWidget(
//                                   placeholderText: 'B4U Solution',
//                                   iconData: SocialIconsFlutter.youtube,
//                                   link:
//                                       'https://www.youtube.com/channel/UC1UDTdvGiei6Lc4ei7VzL_A',
//                                   iconColor: Colors.red,
//                                   placeholderStyle: TextStyle(
//                                       color: Colors.black, fontSize: 20),
//                                 ),
//                               ),
//                               PopupMenuItem<int>(
//                                 value: 3,
//                                 child: SocialWidget(
//                                   placeholderText: 'B4U Solution',
//                                   iconData: SocialIconsFlutter.twitter,
//                                   iconColor: Colors.lightBlue,
//                                   link: 'https://twitter.com/b4usolution',
//                                   placeholderStyle: TextStyle(
//                                       color: Colors.black, fontSize: 20),
//                                 ),
//                               ),
//                               PopupMenuItem<int>(
//                                 value: 4,
//                                 child: SocialWidget(
//                                   placeholderText: 'B4U Solution',
//                                   iconData: Icons.people,
//                                   iconColor: Colors.lightBlue,
//                                   link:
//                                       'https://www.slideshare.net/b4usolution/',
//                                   placeholderStyle: TextStyle(
//                                       color: Colors.black, fontSize: 20),
//                                 ),
//                               ),
//                             ])),
//               ],
//             ),
//             body: Obx(() {
//               if (getAllBooksController.isLoading.value &&
//                   getTopBookController.isLoading.value) {
//                 return Center(
//                     child: LoadingAnimationWidget.discreteCircle(
//                   color: Color.fromARGB(255, 138, 175, 52),
//                   secondRingColor: Colors.black,
//                   thirdRingColor: Colors.purple,
//                   size: 30,
//                 ));
//               } else {
//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     getAllBooksController.getAllBooks();
//                     getTopBookController.getTopBook();
//                   },
//                   child: Stack(
//                     children: [
//                       SafeArea(
//                         child: SingleChildScrollView(
//                           physics: ScrollPhysics(),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Container(
//                                   height: 40,
//                                   child: TextField(
//                                     showCursor: true,
//                                     readOnly: true,
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   SearchPage()));
//                                     },
//                                     decoration: InputDecoration(
//                                       hintText: "Tìm kiếm sách",
//                                       fillColor: Colors.grey[300],
//                                       filled: true,
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: 6, horizontal: 12),
//                                       prefixIcon: Icon(
//                                         Icons.search,
//                                         color: Colors.grey,
//                                       ),
//                                       focusedBorder: InputBorder.none,
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20.0)),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: size.height * 0.02),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   mainAxisSize: MainAxisSize.max,
                              //   children: [
                              //     Flexible(
                              //       child: GestureDetector(
                              //         onTap: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       CompanyPage()));
                              //         },
                              //         child: Container(
                              //             width: 170,
                              //             child: Image.asset(
                              //                 'assets/images/banner1.png',
                              //                 fit: BoxFit.fill)),
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: GestureDetector(
                              //         onTap: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       JobPage()));
                              //         },
                              //         child: Container(
                              //             width: 170,
                              //             child: Image.asset(
                              //                 'assets/images/banner3.jpg',
                              //                 fit: BoxFit.fill)),
                              //       ),
                              //     ),
                              //   ],
                              // ),
//                               SizedBox(height: size.height * 0.02),
//                               // Padding(
//                               //   padding: const EdgeInsets.all(16.0),
//                               //   child: GestureDetector(
//                               //     onTap: () {
//                               //       if (authController.isLoggedIn.value) {
//                               //         Navigator.push(
//                               //             context,
//                               //             MaterialPageRoute(
//                               //                 builder: (context) =>
//                               //                     WheelPage()));
//                               //       } else {
//                               //         showDialog(
//                               //           context: context,
//                               //           builder: (context) => AlertPageDialog(),
//                               //         );
//                               //       }
//                               //     },
//                               //     child:
//                               //         Image.asset('assets/images/wheel1.jpg'),
//                               //   ),
//                               // ),
                              // SizedBox(height: size.height * 0.01),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 13.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Luyện thi "IELTS - TOEIC - IT - PSM1"',
                              //       style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w700,
                              //           color: Colors.redAccent),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       if (authController.isLoggedIn.value) {
                              //         // Navigator.push(
                              //         //     context,
                              //         //     MaterialPageRoute(
                              //         //         builder: (context) =>
                              //         //             PracticePage()));
                              //       } else {
                              //         showDialog(
                              //           context: context,
                              //           builder: (context) => AlertPageDialog(),
                              //         );
                              //       }
                              //     },
                              //     child: Image.asset(
                              //         'assets/images/practice2.png'),
                              //   ),
                              // ),
                              // SizedBox(height: size.height * 0.04),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 13.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Vòng quay may mắn',
                              //       style: TextStyle(
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       if (authController.isLoggedIn.value) {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     WheelPage()));
                              //       } else {
                              //         showDialog(
                              //           context: context,
                              //           builder: (context) => AlertPageDialog(),
                              //         );
                              //       }
                              //     },
                              //     child: Image.asset(
                              //         'assets/images/banner-wheel.jpg'),
                              //   ),
                              // ),
                              // SizedBox(height: size.height * 0.04),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 13.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Top 5 sách hay',
                              //       style: TextStyle(
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //   ),
                              // ),
//                               Container(
//                                 height: 200,
//                                 margin: EdgeInsets.only(left: 10, right: 10),
//                                 child: ListView.builder(
//                                     shrinkWrap: true,
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                         getTopBookController.topbooks.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             final SharedPreferences? prefs =
//                                                 await _prefs;
//                                             await prefs?.setString(
//                                                 'idbook',
//                                                 getTopBookController
//                                                     .topbooks[index].id
//                                                     .toString());

//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         DetailBookPage(
//                                                             id: getTopBookController
//                                                                 .topbooks[index]
//                                                                 .id
//                                                                 .toString())));
//                                           },
//                                           child: SizedBox(
//                                             child: Image.network(
//                                                 getTopBookController
//                                                             .topbooks[index]
//                                                             .image ==
//                                                         null
//                                                     ? "Đang tải..."
//                                                     : 'http://103.77.166.202' +
//                                                         getTopBookController
//                                                             .topbooks[index]
//                                                             .image
//                                                             .toString()),
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                               ),
//                               SizedBox(height: size.height * 0.04),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 14.0),
//                                 child: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     'Thư viện sách',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: GridView.builder(
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount:
//                                         getAllBooksController.books.length,
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 2,
//                                             childAspectRatio: 2 / 3.3),
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       final book =
//                                           getAllBooksController.books[index];
//                                       return InkWell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     final SharedPreferences?
//                                                         prefs = await _prefs;
//                                                     await prefs?.setString(
//                                                         'idbook',
//                                                         book.id.toString());
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 DetailBookPage(
//                                                                     id: book.id
//                                                                         .toString())));
//                                                   },
//                                                   child: Container(
//                                                     height: size.height * 0.25,
//                                                     width: size.width * 0.4,
//                                                     decoration: BoxDecoration(
//                                                         image: DecorationImage(
//                                                             fit: BoxFit
//                                                                 .fitHeight,
//                                                             image: NetworkImage(
//                                                               book.image == null
//                                                                   ? "Đang tải..."
//                                                                   : 'http://103.77.166.202' +
//                                                                       book.image
//                                                                           .toString(),
//                                                             ))),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                     height: size.height * 0.02),
//                                                 Container(
//                                                   child: Text(
//                                                     book.bookName == null
//                                                         ? "Đang tải..."
//                                                         : book.bookName
//                                                             .toString(),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     maxLines: 2,
//                                                     style: const TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                     height: size.height * 0.01),
//                                                 Text(
//                                                   book.author == null
//                                                       ? "Đang tải..."
//                                                       : 'bởi :' +
//                                                           book.author
//                                                               .toString(),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                   style: const TextStyle(
//                                                       fontSize: 12),
//                                                 ),
//                                               ]),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.grey.shade800,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Center(
//                                       child: Column(
//                                     children: [
//                                       Text(
//                                         "© B4USOLUTION. All Rights Reserved.",
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                       ),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Privacy Policy Designed by B4USOLUTION",
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                       )
//                                     ],
//                                   )),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.all(8.0),
//                       //   child: TimeFrameIcon(),
//                       // ),
//                     ],
//                   ),
//                 );
//               }
//             })));
//   }
// }
