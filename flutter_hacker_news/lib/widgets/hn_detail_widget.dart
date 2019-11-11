import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_list_model.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'hn_detail_list_widget.dart';

class HNDetailWidget extends StatelessWidget {
  final HNItem item;

  HNDetailWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<HNListModel>.value(
        value: HNListModel(),
        child: Material(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: APP_PRIMARY_COLOR,
          ),
          body: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    color: APP_BACKGROUND_COLOR,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: HNDetailListWidget(
                      item: this.item,
                    ),
                  ),
                ],
              )),
        )),
      );
}
