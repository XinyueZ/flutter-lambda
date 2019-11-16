import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils.dart';

class HNTextWidget extends StatelessWidget {
  final HNItem item;

  HNTextWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 8),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Html(
                defaultTextStyle: const TextStyle(
                  height: 1.5,
                  letterSpacing: 2.0,
                  fontSize: 13.0,
                ),
                useRichText: true,
                data: item.text,
                renderNewlines: true,
                onLinkTap: (link) {
                  print("click link $link");
                  launchURL(context, Uri.parse(link));
                },
              )
            ],
          ),
        ),
      );
}
