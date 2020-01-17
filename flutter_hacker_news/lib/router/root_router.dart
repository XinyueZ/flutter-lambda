import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/widgets/hn_content_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_splash_widget.dart';

Route<dynamic> generateRootRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return CupertinoPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => HNSplashWidget(),
      );
    case "/content":
      return CupertinoPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => HNContentWidget(),
      );
    default:
      throw Exception("Unexpected route ${settings.name}");
  }
}
