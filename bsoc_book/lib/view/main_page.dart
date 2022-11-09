import 'package:flutter/material.dart';
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
      drawer: const MenuAside(),
      appBar: AppBar(
        title: const Text('Demo App'),
      ),
      body: const HomePage(),
    );
  }
}
