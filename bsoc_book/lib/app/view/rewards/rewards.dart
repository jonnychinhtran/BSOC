import 'dart:convert';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view/rewards/rewards_page_view.dart';
import 'package:bsoc_book/app/view_model/app_view_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as logg;

class RewardsPage extends StatefulWidget {
  const RewardsPage({
    super.key,
    required this.parentViewState,
    required this.userModel,
    required this.homeViewModel,
  });
  final RewardPageViewState parentViewState;
  final UserModel userModel;
  final HomeViewModel homeViewModel;

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late UserViewModel _userViewModel = UserViewModel();
  UserModel? _userModel;
  late HomeViewModel _homeViewModel;
  bool _loadingIsWaiting = false;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _userViewModel = UserViewModel();
    _userModel = widget.userModel;
    _homeViewModel.getListBook();

    _homeViewModel.bookModelSubjectStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });

    _userViewModel.userInfoModelSubjectStream.listen((event) {
      if (mounted) {
        setState(() {
          _userModel = event;
        });
      }
    });

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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InfoPageView(
                          appViewModel: AppViewModel(),
                          homeViewModel: HomeViewModel(),
                          userViewModel: UserViewModel(),
                        )),
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
                  child: Text(
                    _userModel!.pointForClaimBook == 0
                        ? '0'
                        : _userModel!.pointForClaimBook.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<bool>(
            stream: _homeViewModel.bookModelSubjectStream,
            builder: (context, snapshot) {
              final dataBook = _homeViewModel.checkListBook;
              if (dataBook != null && dataBook['list'] != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: dataBook['list'].length,
                  itemBuilder: (BuildContext context, int index) {
                    List<BookModel> book = dataBook['list'];
                    logg.log(jsonEncode(book));
                    return Card(
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
                                    AppDataGlobal().domain + book[index].image!,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              margin: EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book[index].bookName!,
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
                                          margin: EdgeInsets.only(right: 8.0),
                                          child: Image.asset(
                                              'assets/images/point.png'),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.orangeAccent.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  book[index].payment != true
                                      ? GestureDetector(
                                          onTap: () async {
                                            print(book[index].id);
                                            print(_userModel!.id);
                                            if (_userModel!
                                                    .pointForClaimBook! >=
                                                1) {
                                              if (book[index].payment != true) {
                                                var response = await Dio().post(
                                                    'http://103.77.166.202/api/payment/open-book/${_userModel!.id}/${book[index].id}',
                                                    options: Options(headers: {
                                                      'Authorization':
                                                          'Bearer ${AppDataGlobal().accessToken}'
                                                    }));
                                                if (response.statusCode ==
                                                    200) {
                                                  final jsondata =
                                                      response.data;
                                                  _homeViewModel.getListBook();
                                                  _userViewModel.getInfoPage();
                                                  WidgetHelper.showMessageSuccess(
                                                      context: context,
                                                      content:
                                                          "Đổi thưởng sách thành công!");
                                                } else {
                                                  WidgetHelper.showMessageError(
                                                      context: context,
                                                      content:
                                                          "Đổi thưởng sách thất bại. Thử lại!");
                                                }
                                              } else {
                                                WidgetHelper.showMessageInfo(
                                                    context: context,
                                                    content:
                                                        "Bạn đã đổi sách này rồi!");
                                              }
                                            } else {
                                              WidgetHelper.showMessageInfo(
                                                  context: context,
                                                  content:
                                                      "Bạn không đủ điểm để đổi sách!");
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Đổi sách',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            )),
                                          ))
                                      : Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Đã đổi sách',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                            ),
                                          )),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            }));
  }
}
