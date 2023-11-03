import 'package:bsoc_book/app/view/user/home/home_page.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.homeViewModel});
  final HomeViewModel homeViewModel;

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late HomeViewModel _homeViewModel;
  final loginViewModel = LoginViewModel();
  final PageController _pageViewController = PageController();
  final List<Widget> _listPage = [];

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;

    _listPage.add(HomePage(
      parentViewState: this,
      homeViewModel: _homeViewModel,
    ));

    super.initState();
  }

  void nextPage({String customerPhone = ""}) {
    // setShowBottomBar(false);
    FocusScope.of(context).unfocus();
    _pageViewController.nextPage(
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  void previousPage() {
    if (_pageViewController.page == 1) {
      // setShowBottomBar(true);
    } else {
      // setShowBottomBar(false);
    }
    FocusScope.of(context).unfocus();
    _pageViewController.previousPage(
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  void animatePageHome() {
    // setShowBottomBar(true);
    FocusScope.of(context).unfocus();
    _pageViewController.animateToPage(0,
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  void jumpPageHome() {
    // setShowBottomBar(true);
    // setCurrentBottomBar(0);
    // _checkOutViewModel.clearData();
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
        // bottomNavigationBar: _isShowBottomBar
        //     ? BottomNavigationBarCustom(
        //         homeViewModel: _homeViewModel,
        //         homeViewState: this,
        //       )
        //     : null,
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
