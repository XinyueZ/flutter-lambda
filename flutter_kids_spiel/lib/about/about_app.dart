import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:package_info/package_info.dart';

import '../config.dart';

class AboutApp {
  Future<Widget> getAbout(BuildContext context) async {
    final aboutList = await getInfoList(context);

    return AlertDialog(
      title: Text("About"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: aboutList,
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<List<Widget>> getInfoList(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    final String version = "$versionName+$versionCode";

    ///TODO Optimise below codes which contain double coded stuff.
    if (Platform.isIOS)
      return [
        Text("Kids Spiel, brings all togethet."),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Text("Version: $version"),
        ),
      ];

    return [
      Text("Kids Spiel, brings all togethet."),
      Padding(
        padding: EdgeInsets.all(15),
        child:
            _openWebLinkText(context, "API provider", Uri.parse(API_PROVIDER)),
      ),
      _openWebLinkText(
          context, "Source on Github", Uri.parse(PROJECT_LOCATION)),
      Padding(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Text("Version: $version"),
      ),
    ];
  }

  void _launchURL(BuildContext context, Uri target) async {
    try {
      await launch(
        target.toString(),
        option: CustomTabsOption(
          toolbarColor: Colors.black,
          //Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Widget _openWebLinkText(
          BuildContext context, String text, Uri target) =>
      InkWell(
          child: Text(
              text,
              style: TextStyle(
                  color: Colors.lightBlue,
                  decoration: TextDecoration.underline)),
          onTap: () => _launchURL(context, target));
}
