import 'package:bsoc_book/app/view/infor/infor_page.dart';
import 'package:bsoc_book/app/view_model/app_view_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';

class InfoPageView extends StatefulWidget {
  final AppViewModel appViewModel;
  final HomeViewModel homeViewModel;
  final UserViewModel userViewModel;
  const InfoPageView(
      {super.key,
      required this.appViewModel,
      required this.homeViewModel,
      required this.userViewModel});

  @override
  State<InfoPageView> createState() => InfoPageViewState();
}

class InfoPageViewState extends State<InfoPageView> {
  final UserViewModel _userViewModel = UserViewModel();
  final HomeViewModel _homeViewModel = HomeViewModel();
  final PageController _pageViewController = PageController();
  final List<Widget> _listPage = [];

  @override
  void initState() {
    _listPage.add(InfoPage(
      userViewModel: _userViewModel,
      parentViewState: this,
      homeViewModel: _homeViewModel,
    ));
    super.initState();
  }

  void jumpPageInfo() {
    FocusScope.of(context).unfocus();
    _pageViewController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: buildPages(),
      ),
    );
  }

  Widget buildPages() {
    return PageView.custom(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageViewController,
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _listPage[index];
        },
        childCount: _listPage.length,
        // This is default, can be omitted.
        addAutomaticKeepAlives: true,
      ),
    );
    //}
  }
}
