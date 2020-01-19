import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_app_about_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_top_stories_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_share_bloc.dart';
import 'package:flutter_hacker_news/widgets/hn_app_about_widget.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../config.dart';
import 'hn_job_list_widget.dart';
import 'hn_news_list_widget.dart';

class HNJobsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNShareBloc model = HNShareBloc();
    model.appSharing();

    return Material(
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
      body: HNJobListWidget(),
    ));
  }
}
