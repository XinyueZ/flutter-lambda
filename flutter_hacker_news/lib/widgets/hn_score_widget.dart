import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNScoreWidget extends StatelessWidget {
  final HNStory _story;

  HNScoreWidget(this._story);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.score,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            _story.score.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
