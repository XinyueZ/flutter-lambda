import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNAuthorWidget extends StatelessWidget {
  final HNItem item;

  HNAuthorWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.face,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            item.by,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
