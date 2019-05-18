import 'package:flutter/material.dart';

import 'image_app_page.dart';

class ImageAppPager extends StatefulWidget {
  final String _title;

  ImageAppPager(this._title, {Key key}) : super(key: key);

  @override
  _ImageAppPagerState createState() => _ImageAppPagerState();
}

class _ImageAppPagerState extends State<ImageAppPager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: PageView.builder(
          itemBuilder: (BuildContext context, int index) =>
              ImageAppPage(index: index)),
    );
  }
}
