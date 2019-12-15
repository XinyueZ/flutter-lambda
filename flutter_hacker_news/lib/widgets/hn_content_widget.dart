import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_app_about_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_list_view_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_share_bloc.dart';
import 'package:flutter_hacker_news/widgets/hn_app_about_widget.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../config.dart';
import 'hn_list_widget.dart';

class HNContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNShareBloc model = HNShareBloc();
    model.appSharing();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<HNListBloc>.value(value: HNListBloc()),
        ],
        child: Material(
            child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 10,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset('assets/logo/hn_flutter.png'),
                onPressed: () {},
              );
            }),
            title: Text(
              APP_NAME,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: APP_PRIMARY_COLOR,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChangeNotifierProvider<HNAppAboutBloc>.value(
                            value: HNAppAboutBloc(context),
                            child: HNAppAboutWidget());
                      });
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(model.shareApp, subject: model.subject);
                },
              )
            ],
          ),
          body: Builder(builder: (BuildContext context) {
            return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult conn, Widget child) {
                final bool connected = conn != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    child,
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      height: 32.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color:
                            connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                        child: connected
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "ONLINE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "OFFLINE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )
                  ],
                );
              },
              child: HNListWidget(),
            );
          }),
        )));
  }
}
