import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/Ping.dart';
import 'package:flutter_random_images/image_app_pager.dart';
import 'package:flutter_random_images/viewmodel/image_app_splash_view_model.dart';

import 'config.dart';

class ImageAppSplash extends StatefulWidget {
  final ImageAppSplashViewModel _viewModel;

  ImageAppSplash(this._viewModel);

  @override
  _ImageAppSplashState createState() => _ImageAppSplashState(_viewModel);
}

class _ImageAppSplashState extends State<ImageAppSplash> {
  final ImageAppSplashViewModel _viewModel;

  _ImageAppSplashState(this._viewModel);

  @override
  void initState() {
    Future<bool> successfullyFuture = _viewModel.ping();
    successfullyFuture.then((successfully) {
      switch (successfully) {
        case true:
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ImageAppPager(appDisplayName);
          }));
          break;
        case false:
          break;
      }
    });
    super.initState();
  }

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
