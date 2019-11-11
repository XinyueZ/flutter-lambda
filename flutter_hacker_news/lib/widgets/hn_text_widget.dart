import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNTextWidget extends StatelessWidget {
  final HNItem item;

  HNTextWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: Text(item.text,
              textAlign: TextAlign.left,
              style: const TextStyle(
                height: 1.5,
                letterSpacing: 2.0,
                fontSize: 13.0,
              )),
        ),
      );
}
