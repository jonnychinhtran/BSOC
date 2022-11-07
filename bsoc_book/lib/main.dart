import 'package:bsoc_book/view/login_page.dart';
import 'package:bsoc_book/view/index_page.dart';
import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuAside(),
      appBar: AppBar(
        title: const Text('Demo App'),
      ),
      body: IndexPage(),
    );
  }
}
