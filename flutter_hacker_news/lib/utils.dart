import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void launchURL(BuildContext context, Uri target) async {
  try {
    await launch(
      target.toString(),
      option: CustomTabsOption(
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
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

Widget openWebLinkText(BuildContext context, String text, Uri target) =>
    FlatButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: TextStyle(
                color: Colors.lightBlue, decoration: TextDecoration.underline)),
      ),
      onPressed: () => launchURL(context, target),
    );
