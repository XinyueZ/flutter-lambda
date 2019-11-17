import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/utils.dart';
import 'package:package_info/package_info.dart';

import '../config.dart';

class HNAppAboutBloc extends ChangeNotifier {
  List<Widget> aboutList;

  HNAppAboutBloc(BuildContext context) {
    _getAboutList(context);
  }

  _getAboutList(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    final String version = "$versionName ($versionCode)";

    aboutList = [
      openWebLinkText(context, "API provider", Uri.parse(API_PROVIDER)),
      openWebLinkText(context, "Source on Github", Uri.parse(APP_OPEN_SOURCE)),
      FlatButton(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text("Version: $version"),
        ),
        onPressed: null,
      )
    ];

    notifyListeners();
  }
}
