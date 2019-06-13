import 'package:flutter/material.dart';

import 'about/about_app.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          margin: EdgeInsets.only(top: 25.0, right: 15.0),
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
          )),
    );
  }
}
