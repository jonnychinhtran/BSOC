import 'dart:async';
import 'dart:io';

import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/resource/values/app_strings.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/app_preferences.dart';
import 'package:flutter/material.dart';

import '../../config/routes.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView>
    with SingleTickerProviderStateMixin {
  final loginViewModel = LoginViewModel();
  var _iconAnimationController;
  var _iconAnimation;

  void handleTimeout() async {
    await AppPreferences().isPreferenceReady;
    AppPreferences().getLoggedIn().then((isLoggedIn) async {
      if (isLoggedIn) {
        var token = await AppPreferences().getAccessToken();
        AppDataGlobal().setAccessToken(accessToken: token);
        if ("" != token) {
          print("Is Logged In auto set accesstoken $token");
          AppDataGlobal().setDomain(inDomain: "http://103.77.166.202");
          NetworkUtil2().addHeaderData(
              key: HttpHeaders.authorizationHeader, data: "Bearer $token");
          try {
            await loginViewModel.loadAppData();
          } catch (e) {
            // ignore: use_build_context_synchronously
            Application.router
                .navigateTo(context, Routes.app, clearStack: true);

            return;
          }
          // ignore: use_build_context_synchronously
          Application.router.navigateTo(context, Routes.app, clearStack: true);
        }
      } else {
        // ignore: use_build_context_synchronously
        Application.router.navigateTo(context, Routes.app, clearStack: true);
      }
    });
  }

  startTimeout() async {
    return Timer(const Duration(seconds: 3), handleTimeout);
  }

  @override
  void initState() {
    AppDataGlobal().initDomainApi(domain: "http://103.77.166.202");
    super.initState();

    _iconAnimationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    _iconAnimation = CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.fastOutSlowIn);
    _iconAnimation.addListener(() => setState(() {}));

    _iconAnimationController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: _iconAnimation.value * 120,
                    height: _iconAnimation.value * 120,
                    child: Image.asset(
                      "assets/images/logo-b4usolution.png",
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }
}
