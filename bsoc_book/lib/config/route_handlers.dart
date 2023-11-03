import 'package:bsoc_book/app/view/app_view.dart';
import 'package:bsoc_book/app/view/index_view.dart';
import 'package:bsoc_book/app/view/login/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var indexHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const IndexView();
});

var appHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const AppView();
});

var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const LoginPage();
});
