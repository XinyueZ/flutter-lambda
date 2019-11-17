import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_detail_bloc.dart';
import 'package:flutter_hacker_news/widgets/hn_translation_widget.dart';
import 'package:provider/provider.dart';

import 'hn_author_widget.dart';
import 'hn_comment_widget.dart';
import 'hn_detail_text_widget.dart';
import 'hn_detail_url_widget.dart';
import 'hn_score_widget.dart';
import 'hn_time_widget.dart';

class HNDetailHeaderWidget extends StatefulWidget {
  @override
  _HNDetailHeaderWidgetState createState() => _HNDetailHeaderWidgetState();
}

class _HNDetailHeaderWidgetState extends State<HNDetailHeaderWidget> {
  bool _translate = false;

  @override
  Widget build(BuildContext context) {
    final HNDetailBloc model = Provider.of<HNDetailBloc>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _translate
                ? HNTranslationWidget(
                    origin: model.currentHackerNews.text,
                  )
                : HNDetailTextWidget(),
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
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.only(bottom: 0, left: 16),
                  icon: SizedBox(
                    child: Icon(
                      Icons.translate,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _translate = !_translate;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 5,
              height: 5,
            ),
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
