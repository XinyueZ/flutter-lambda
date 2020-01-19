import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_news_detail_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_share_bloc.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../config.dart';
import 'hn_detail_comment_list_widget.dart';
import 'hn_detail_header_widget.dart';

class HNNewsDetailWidget extends StatelessWidget {
  final HNStory item;

  HNNewsDetailWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final HNShareBloc model = HNShareBloc();
    model.storySharing(item);

    return ChangeNotifierProvider<HNNewsDetailBloc>.value(
      value: HNNewsDetailBloc(item),
      child: Material(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: APP_PRIMARY_COLOR,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 10,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(model.shareStory, subject: model.subject);
              },
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    color: APP_BACKGROUND_COLOR,
                    child: HNDetailHeaderWidget(),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              HNDetailCommentListWidget(),
            ],
          ),
        ),
      )),
    );
  }
}
