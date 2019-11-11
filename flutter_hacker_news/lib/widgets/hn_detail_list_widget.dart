import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import 'hn_author_widget.dart';
import 'hn_comment_widget.dart';
import 'hn_score_widget.dart';
import 'hn_text_widget.dart';
import 'hn_time_widget.dart';

class HNDetailListWidget extends StatelessWidget {
  final HNItem item;

  HNDetailListWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                HNTextWidget(item),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                HNCommentWidget(item),
                SizedBox(
                  width: 5,
                ),
                HNScoreWidget(item),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                HNTimeWidget(item),
                SizedBox(
                  width: 5,
                ),
                HNAuthorWidget(item),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      );
}
