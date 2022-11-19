import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_flutter/social_media_flutter.dart';
import 'user/home/home_page.dart';
import 'widgets/menu_aside.dart';

class MainIndexPage extends StatefulWidget {
  const MainIndexPage({Key? key}) : super(key: key);

  @override
  State<MainIndexPage> createState() => _MainIndexPageState();
}

class _MainIndexPageState extends State<MainIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuAside(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: const Text('B4U BSOC'),
        actions: [
          Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.white),
              ),
              child: PopupMenuButton<int>(
                  color: Colors.white,
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
                      ]))
        ],
      ),
      body: const HomePage(),
    );
  }
}
