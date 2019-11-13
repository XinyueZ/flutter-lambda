import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

class HNSubCommentWidget extends StatelessWidget {
  final HNComment comment;

  HNSubCommentWidget({
    Key key,
    @required this.comment,
  });

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
            comment.kids.length.toString(),
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
