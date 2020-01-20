import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNScoreWidget extends StatelessWidget {
  final HNScore scoredItem;

  HNScoreWidget({
    Key key,
    @required this.scoredItem,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.score,
            color: Colors.grey,
          ),
          Container(
            child: Text(
              scoredItem.score.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
