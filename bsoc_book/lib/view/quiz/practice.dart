import 'package:bsoc_book/view/quiz/topic_practice.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PracticePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    callback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.indigo.shade900,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                    Icons.arrow_back), // Put icon of your preference.
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              );
            },
          ),
        ),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Container(
                  color: Colors.white70,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/wifi.png'),
                          Text(
                            'Không có kết nối Internet',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Vui lòng kiểm tra kết nối internet và thử lại',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            child: Stack(children: [
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg1.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.08),
                        Text(
                          'Favorites of the',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'B4U',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          'BSOC APP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/icon1.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          'CHOOSE THE WAY YOU PLAY:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        Container(
                          height: 150,
                          child: Card(
                            elevation: 0.0,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 75,
                                  onPressed: () {
                                    Get.to(TopicPracticePage());
                                  },
                                  icon: Ink.image(
                                      image:
                                          AssetImage('assets/images/btn1.png')),
                                ),
                                IconButton(
                                  iconSize: 75,
                                  onPressed: () {
                                    Get.to(TopicPracticePage());
                                  },
                                  icon: Ink.image(
                                      image:
                                          AssetImage('assets/images/btn2.png')),
                                ),
                                IconButton(
                                  iconSize: 80,
                                  onPressed: () {
                                    Get.to(TopicPracticePage());
                                  },
                                  icon: Ink.image(
                                      image:
                                          AssetImage('assets/images/btn3.png')),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }
}
