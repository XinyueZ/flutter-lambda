import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../config.dart';
import '../utils.dart';

class ImageAppPagerViewModel {
  Future<List<Widget>> getAboutList(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    final String version = "$versionName ($versionCode)";

    return [
      Padding(
        padding: EdgeInsets.all(15),
        child:
            openWebLinkText(context, "API provider", Uri.parse(API_PROVIDER)),
      ),
      openWebLinkText(context, "Source on Github", Uri.parse(PROJECT_LOCATION)),
      Padding(
        padding: EdgeInsets.all(15),
        child: Text("Version: $version"),
      ),
    ];
  }
}
