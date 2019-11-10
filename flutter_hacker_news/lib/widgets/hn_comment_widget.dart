import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNCommentWidget extends StatelessWidget {
  final HNStory _story;

  HNCommentWidget(this._story);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.comment,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            _story.descendants.toString(),
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
