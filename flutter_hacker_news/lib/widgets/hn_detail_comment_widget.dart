import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_sub_comment_widget.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils.dart';
import 'hn_author_widget.dart';
import 'hn_time_widget.dart';

class HNDetailCommentWidget extends StatelessWidget {
  final HNComment comment;

  HNDetailCommentWidget({
    Key key,
    @required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        children: <Widget>[
          Divider(),
          SizedBox(
            width: 5,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10),
            child: Html(
              useRichText: true,
              data: comment.text,
              onLinkTap: (link) {
                print("click link $link");
                launchURL(context, Uri.parse(link));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              HNTimeWidget(item: comment),
              SizedBox(
                width: 5,
              ),
              HNAuthorWidget(item: comment),
              SizedBox(
                width: 5,
              ),
              HNDetailSubCommentWidget(comment: comment),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
