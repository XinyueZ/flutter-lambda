import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageAppSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            alignment: Alignment(0.0, 0.0),
            padding: const EdgeInsets.all(0.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset("asserts/launcher_icon/icon.png"),
                Text("Lorem Picsum",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ],
            )));
  }
}
