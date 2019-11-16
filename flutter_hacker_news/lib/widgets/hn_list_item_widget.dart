import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_author_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_comment_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_score_widget.dart';

import 'hn_text_widget.dart';
import 'hn_time_widget.dart';

class HNListItemWidget extends StatelessWidget {
  final HNItem item;

  HNListItemWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HNDetailWidget(item: item);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        HNTextWidget(item: item),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        HNCommentWidget(story: item),
                        SizedBox(
                          width: 5,
                        ),
                        HNScoreWidget(story: item),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
