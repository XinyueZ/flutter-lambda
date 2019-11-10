import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_author_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_comment_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_score_widget.dart';

import 'hn_author_badge_widget.dart';
import 'hn_text_widget.dart';
import 'hn_time_widget.dart';

class HNListItemWidget extends StatelessWidget {
  final HNItem _item;

  HNListItemWidget(this._item);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      HNAuthorBadgeWidget(_item),
                      HNTextWidget(_item),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      HNCommentWidget(_item),
                      SizedBox(
                        width: 5,
                      ),
                      HNScoreWidget(_item),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      HNTimeWidget(_item),
                      SizedBox(
                        width: 5,
                      ),
                      HNAuthorWidget(_item),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
