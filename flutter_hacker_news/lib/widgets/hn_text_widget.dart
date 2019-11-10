import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNTextWidget extends StatelessWidget {
  final HNItem _item;

  HNTextWidget(this._item);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_item.text,
              textAlign: TextAlign.left,
              style: TextStyle(
                height: 1.5,
                letterSpacing: 2.0,
                fontSize: 13.0,
              )),
        ),
      );
}
