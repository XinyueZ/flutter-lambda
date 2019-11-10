import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import 'hn_author_badge_widget.dart';
import 'hn_text_widget.dart';

class HNListItemWidget extends StatelessWidget {
  final HNItem _item;

  HNListItemWidget(this._item);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
          height: 140,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  HNAuthorBadgeWidget(_item),
                  HNTextWidget(_item),
                ],
              ),
            ),
          ),
        ),
      );
}
