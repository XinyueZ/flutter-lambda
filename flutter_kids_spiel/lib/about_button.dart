import 'dart:ui';

import 'package:flutter/material.dart';

import 'about/about_app.dart';

class AboutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: MediaQueryData.fromWindow(window).padding.top, right: 15.0),
        child: IconButton(
          iconSize: 35,
          icon: Icon(
            Icons.info,
            color: Colors.pinkAccent,
          ),
          onPressed: () async {
            final about = await AboutApp().getAbout(context);
            showDialog(
              context: context,
              builder: (BuildContext context) => about,
            );
          },
        ));
  }
}
