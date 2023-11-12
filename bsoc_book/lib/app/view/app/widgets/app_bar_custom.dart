import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view/infor/infor_page.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view_model/app_view_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/utils/resource_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_flutter/social_media_flutter.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  const AppBarCustom(
      {super.key,
      required this.homeViewModel,
      required this.parentViewState,
      required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarCustomState extends State<AppBarCustom> {
  HomeViewModel? _homeViewModel;
  final AppViewModel _appViewModel = AppViewModel();
  final UserViewModel _userViewModel = UserViewModel();
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<Widget> _pages = [];
  // void _openEndDrawer() {
  //   widget.scaffoldKey.currentState!.openDrawer();
  // }

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void initState() {
    _pages.add(InfoPageView(
      appViewModel: _appViewModel,
      homeViewModel: widget.homeViewModel,
      userViewModel: _userViewModel,
    ));

    _homeViewModel = widget.homeViewModel;

    super.initState();
  }

  void jumpPageInfo() {
    FocusScope.of(context).unfocus();
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: ResourceValues.kElevationAppbar,
        leadingWidth: 0,
        leading: null,
        centerTitle: false,
        title: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoPageView(
                                    appViewModel: _appViewModel,
                                    homeViewModel: widget.homeViewModel,
                                    userViewModel: _userViewModel,
                                  )));
                    },
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        goHome();
                      },
                      child: const SizedBox(
                        child: Text(
                          'B4U BSOC',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                PopupMenuButton<int>(
                    color: Color.fromARGB(255, 255, 255, 255),
                    itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            value: 0,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: SocialIconsFlutter.facebook_box,
                              link:
                                  'https://www.facebook.com/groups/376149517873940',
                              iconColor: Color.fromARGB(255, 0, 170, 255),
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: SocialIconsFlutter.linkedin_box,
                              link:
                                  'https://www.linkedin.com/in/b4usolution-b16383128/',
                              iconColor: Colors.blueGrey,
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: SocialIconsFlutter.youtube,
                              link:
                                  'https://www.youtube.com/channel/UC1UDTdvGiei6Lc4ei7VzL_A',
                              iconColor: Colors.red,
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 3,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: SocialIconsFlutter.twitter,
                              iconColor: Colors.lightBlue,
                              link: 'https://twitter.com/b4usolution',
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 4,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: Icons.people,
                              iconColor: Colors.lightBlue,
                              link: 'https://www.slideshare.net/b4usolution/',
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ]),
              ],
            ),
          ],
        ));
  }
}
