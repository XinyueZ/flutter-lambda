import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNCommentWidget extends StatelessWidget {
  final HNStory story;

  HNCommentWidget({
    Key key,
    @required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.comment,
            color: Colors.grey,
          ),
          Container(
            child: Text(
              story.descendants.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
