import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/viewmodel/image_app_splash_view_model.dart';

import 'config.dart';
import 'image_app_pager.dart';

class ImageAppSplash extends StatefulWidget {
  final ImageAppSplashViewModel _viewModel;

  ImageAppSplash(this._viewModel);

  @override
  _ImageAppSplashState createState() => _ImageAppSplashState(_viewModel);
}

class _ImageAppSplashState extends State<ImageAppSplash> {
  final ImageAppSplashViewModel _viewModel;
  String connStatus = "Initializing ✨";

  _ImageAppSplashState(this._viewModel);

  @override
  void initState() {
    Future<bool> pingFuture = _viewModel.ping();
    pingFuture.then((ping) {
      switch (ping) {
        case true:
          setState(() {
            connStatus = "Internet  ✅";
          });
          Future<bool> checkApiFuture = _viewModel.checkApiBase();
          checkApiFuture.then((checkApi) {
            switch (checkApi) {
              case true:
                setState(() {
                  connStatus = "API  ✅";
                });
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) {
                  return ImageAppPager(APP_DISPLAY_NAME);
                }));
                break;
              case false:
                setState(() {
                  connStatus = "API  ❌";
                });
                break;
            }
          });
          break;
        case false:
          setState(() {
            connStatus = "Internet  ❌";
          });
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset("asserts/launcher_icon/icon.png"),
                Text(APP_DISPLAY_NAME,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 25)),
                Text(connStatus,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 15)),
              ],
            )));
  }
}
