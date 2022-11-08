import 'package:flutter/material.dart';

import 'user/home/home_page.dart';
import 'widgets/menu_aside.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuAside(),
      appBar: AppBar(
        title: const Text('Demo App'),
      ),
      body: HomePage(),
    );
  }
}
