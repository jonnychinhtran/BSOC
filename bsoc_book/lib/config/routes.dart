import 'package:bsoc_book/config/route_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String root = "/";
  static String appRouteLogin = "/login";
  static const String app = "/app";
  static String home = "/home";

  static const String appRouteNotFound = "/not-found";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: indexHandler);
    router.define(app, handler: appHandler);
    router.define(appRouteLogin, handler: loginHandler);
  }
}
