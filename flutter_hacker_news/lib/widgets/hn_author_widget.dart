import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNAuthorWidget extends StatelessWidget {
  final HNTextItem item;

  HNAuthorWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.face,
            color: Colors.grey,
          ),
          Container(
            child: Text(
              item.by,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
