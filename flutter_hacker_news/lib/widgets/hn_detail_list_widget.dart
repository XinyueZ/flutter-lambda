import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import 'hn_author_widget.dart';
import 'hn_comment_widget.dart';
import 'hn_detail_text_widget.dart';
import 'hn_detail_url_widget.dart';
import 'hn_score_widget.dart';
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
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              HNDetailTextWidget(item: item),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              HNDetailUrlWidget(story: item),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              HNCommentWidget(story: item),
              SizedBox(
                width: 5,
              ),
              HNScoreWidget(story: item),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              HNTimeWidget(item: item),
              SizedBox(
                width: 5,
              ),
              HNAuthorWidget(item: item),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
}
