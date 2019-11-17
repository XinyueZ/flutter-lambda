import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_author_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_comment_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_score_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_translation_widget.dart';

import 'hn_text_widget.dart';
import 'hn_time_widget.dart';
import 'hn_translation_button_widget.dart';

class HNListItemWidget extends StatefulWidget {
  final HNItem item;

  HNListItemWidget({
    Key key,
    @required this.item,
  });

  @override
  _HNListItemWidgetState createState() => _HNListItemWidgetState();
}

class _HNListItemWidgetState extends State<HNListItemWidget> {
  bool _translate = false;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HNDetailWidget(item: widget.item);
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
                        _translate
                            ? HNTranslationWidget(
                                origin: widget.item.text,
                                margin: const EdgeInsets.only(left: 16.0),
                                textStyle: const TextStyle(
                                  height: 1.5,
                                  letterSpacing: 2.0,
                                  fontSize: 15.0,
                                ),
                              )
                            : HNTextWidget(item: widget.item),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        HNCommentWidget(story: widget.item),
                        SizedBox(
                          width: 5,
                        ),
                        HNScoreWidget(story: widget.item),
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
                        Expanded(
                          child: HNTranslationButtonWidget(
                            alignment: Alignment.topLeft,
                            onTranslationClicked: () {
                              setState(() {
                                _translate = !_translate;
                              });
                            },
                            padding: const EdgeInsets.only(bottom: 0, left: 16),
                          ),
                        ),
                        HNTimeWidget(item: widget.item),
                        SizedBox(
                          width: 5,
                        ),
                        HNAuthorWidget(item: widget.item),
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
