import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_random_images/viewmodel/image_app_splash_view_model.dart';

import 'config.dart';
import 'image_app_splash.dart';
import 'service/gateway.dart';
import 'service/http_client_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appDisplayName,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: ImageAppSplash(ImageAppSplashViewModel(
          Service(HttpClientProvider()),
          () => InternetAddress.lookup(apiBase))),
    );
  }
}
