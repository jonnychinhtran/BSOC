import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user/home/home_page.dart';
import 'widgets/menu_aside.dart';
import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';

class MainIndexPage extends StatefulWidget {
  const MainIndexPage({Key? key}) : super(key: key);

  @override
  State<MainIndexPage> createState() => _MainIndexPageState();
}

class _MainIndexPageState extends State<MainIndexPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Scaffold(
      drawer: const MenuAside(),
      appBar: AppBar(
        title: const Text('BSOC App'),
      ),
      body: const HomePage(),
    );
  }
}
