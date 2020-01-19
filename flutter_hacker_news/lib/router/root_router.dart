import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/router/navigation_constants.dart';
import 'package:flutter_hacker_news/router/root_tab_navigation.dart';
import 'package:flutter_hacker_news/widgets/hn_news_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_splash_widget.dart';

Route<dynamic> generateRootRoute(RouteSettings settings) {
  switch (settings.name) {
    case ROOT_TO_SPLASH:
      return CupertinoPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => HNSplashWidget(),
      );
    case ROOT_TO_CONTENT:
      return CupertinoPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => RootTabNavigation(),
      );
    default:
      throw Exception("Unexpected route ${settings.name}");
  }
}
