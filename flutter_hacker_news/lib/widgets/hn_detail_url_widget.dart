import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../utils.dart';

class HNDetailUrlWidget extends StatelessWidget {
  final HNStory story;

  HNDetailUrlWidget({
    Key key,
    @required this.story,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16),
          child: Linkify(
            onOpen: (link) async {
              print("click link $link");
              launchURL(context, Uri.parse(link.url));
            },
            text: story.uri.toString(),
            linkStyle: TextStyle(color: Colors.lightBlue),
          ),
        ),
      );
}
