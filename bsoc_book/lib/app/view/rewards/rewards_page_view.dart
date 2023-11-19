import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/rewards/rewards.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class RewardPageView extends StatefulWidget {
  const RewardPageView({
    super.key,
    required this.userModel,
    required this.homeViewModel,
  });
  final UserModel userModel;
  final HomeViewModel homeViewModel;
  @override
  State<RewardPageView> createState() => RewardPageViewState();
}

class RewardPageViewState extends State<RewardPageView> {
  late HomeViewModel _homeViewModel;
  final PageController _pageViewController = PageController();
  final List<Widget> _listPage = [];

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;

    _listPage.add(RewardsPage(
      parentViewState: this,
      userModel: widget.userModel,
      homeViewModel: _homeViewModel,
    ));

    super.initState();
  }

  void jumpPageSubject() {
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
