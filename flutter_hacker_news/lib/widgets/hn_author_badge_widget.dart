import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import '../config.dart';

class HNAuthorBadgeWidget extends StatelessWidget {
  final HNItem _item;

  HNAuthorBadgeWidget(this._item);

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Material(
          color: APP_ACCENT_COLOR,
          child: InkWell(
            splashColor: APP_PRIMARY_COLOR,
            child: SizedBox(
              width: 45,
              height: 45,
              child: Center(
                child: Text(_item.by[0].toUpperCase()),
              ),
            ),
            onTap: () {},
          ),
        ),
      );
}
