import 'dart:async';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/app_view_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:flutter/material.dart';

import 'app/widgets/app_bar_custom.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  Timer? checkConnection;
  int _currentPage = 0;
  bool _isShowAppBar = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [];
  final HomeViewModel _homeViewModel = HomeViewModel();
  final loginViewModel = LoginViewModel();
  final PageController _pageController = PageController(keepPage: true);
  final AppViewModel _appViewModel = AppViewModel();
  final HomeViewState _parentViewState = HomeViewState();

  @override
  void initState() {
    _pages.add(HomeView(
      appViewModel: _appViewModel,
      homeViewModel: _homeViewModel,
    ));

    super.initState();

    _appViewModel.isShowAppBarStream.listen((event) {
      _isShowAppBar = event;
      setState(() {});
    });
  }

  void _selectedTab(int index) {
    setState(() {
      if (index < _pages.length) {
        _currentPage = index;
      }
    });
  }

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void dispose() {
    checkConnection?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // drawer: SafeArea(
      //     child: Drawer(
      //   width: 300,
      //   backgroundColor: Colors.white,
      //   child: Stack(children: [
      //     Container(
      //       padding: const EdgeInsets.only(bottom: 50.0),
      //       child: SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const SizedBox(
      //               height: 10.0,
      //             ),
      //             Container(
      //               width: 300,
      //               padding: const EdgeInsets.symmetric(horizontal: 15),
      //               child: Column(children: [
      //                 SizedBox(
      //                   width: 100,
      //                   height: 70,
      //                   child: Image.asset(
      //                     'assets/images/logo-b4usolution.png',
      //                   ),
      //                 ),
      //               ]),
      //             )
      //           ],
      //         ),
      //       ),
      //     )
      //   ]),
      // )),
      appBar: _isShowAppBar
          ? AppBarCustom(
              homeViewModel: _homeViewModel,
              parentViewState: _parentViewState,
              scaffoldKey: _scaffoldKey,
            )
          : null,
      body: _getCurrentPage(),
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }

  Widget _getCurrentPage() {
    if (_pages.isNotEmpty) {
      return _pages[_currentPage];
    }
    return Container();
  }
}
