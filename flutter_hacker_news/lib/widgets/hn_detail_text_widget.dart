import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../utils.dart';

class HNDetailTextWidget extends StatelessWidget {
  final HNItem item;

  HNDetailTextWidget({
    Key key,
    @required this.item,
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
            text: item.text,
            style: TextStyle(fontSize: 20),
            linkStyle:
                TextStyle(color: Colors.lightBlue, fontStyle: FontStyle.italic),
          ),
        ),
      );
}
