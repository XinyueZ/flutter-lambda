import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sprintf/sprintf.dart';

import 'config.dart';

class ShareAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: MediaQueryData.fromWindow(window).padding.top, right: 15.0),
        child: IconButton(
          iconSize: 35,
          icon: Icon(
            Icons.share,
            color: Colors.pinkAccent,
          ),
          onPressed: () {
            Share.share(sprintf(APP_SHARE, [APP_STORE]));
          },
        ));
  }
}
