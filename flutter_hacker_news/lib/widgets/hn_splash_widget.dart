import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hacker_news/blocs/hn_share_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_splash_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_translation_bloc.dart';
import 'package:flutter_hacker_news/config.dart';
import 'package:provider/provider.dart';

import 'hn_content_widget.dart';

class HNSplashWidget extends StatefulWidget {
  @override
  _HNSplashWidgetState createState() => _HNSplashWidgetState();
}

class _HNSplashWidgetState extends State<HNSplashWidget> {
  bool _showNext = false;

  void _gotoHNContent(BuildContext buildContext) {
    Navigator.of(buildContext).pushReplacement(MaterialPageRoute(builder: (_) {
      return HNContentWidget();
    }));
  }

  void _delayToShowNext() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _showNext = true;
      });
    });
  }

  _asyncPingInternetAndDownloadLanguage() async {
    () async {
      final HNSplashBloc splashModel =
          HNSplashBloc(() => InternetAddress.lookup("g.cn"));
      final bool pingSuccessfully = await splashModel.pingInternet();

      if (pingSuccessfully) {
        await HNTranslationBloc.initSupportedLanguage();
        _gotoHNContent(context);
      } else {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }();
  }

  @override
  void initState() {
    super.initState();
    _delayToShowNext();
    _asyncPingInternetAndDownloadLanguage();
  }

  @override
  Widget build(BuildContext context) => Material(
        color: APP_PRIMARY_COLOR,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 120,
                height: 120,
                child: Image.asset('assets/logo/hn_flutter.png')),
            SizedBox(
              height: 10,
            ),
            SizedBox(width: 100, height: 3, child: LinearProgressIndicator()),
            Align(
              alignment: Alignment.centerRight,
              child: _showNext
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _gotoHNContent(context);
                      },
                    )
                  : Container(),
            ),
          ],
        )),
      );
}
