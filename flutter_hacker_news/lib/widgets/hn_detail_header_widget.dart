import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_detail_bloc.dart';
import 'package:provider/provider.dart';

import 'hn_author_widget.dart';
import 'hn_comment_widget.dart';
import 'hn_detail_text_widget.dart';
import 'hn_detail_url_widget.dart';
import 'hn_score_widget.dart';
import 'hn_time_widget.dart';

class HNDetailHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNDetailBloc model = Provider.of<HNDetailBloc>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            HNDetailTextWidget(),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            HNDetailUrlWidget(),
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
            HNCommentWidget(story: model.currentHackerNews),
            SizedBox(
              width: 5,
            ),
            HNScoreWidget(story: model.currentHackerNews),
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
            HNTimeWidget(item: model.currentHackerNews),
            SizedBox(
              width: 5,
            ),
            HNAuthorWidget(item: model.currentHackerNews),
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
}
