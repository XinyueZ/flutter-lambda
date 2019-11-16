import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_detail_bloc.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'hn_detail_comment_list_widget.dart';
import 'hn_detail_header_widget.dart';

class HNDetailWidget extends StatelessWidget {
  final HNItem item;

  HNDetailWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<HNDetailBloc>.value(
        value: HNDetailBloc(item),
        child: Material(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: APP_PRIMARY_COLOR,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      color: APP_BACKGROUND_COLOR,
                      margin: const EdgeInsets.only(left: 10, right: 10),
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
