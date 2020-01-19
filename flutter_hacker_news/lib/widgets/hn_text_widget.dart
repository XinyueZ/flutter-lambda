import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils.dart';

class HNTextWidget extends StatelessWidget {
  final HNTextItem item;

  HNTextWidget({
    Key key,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: ButtonTheme.of(context).padding,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Html(
                defaultTextStyle: const TextStyle(
                  height: 1.5,
                  letterSpacing: 2.0,
                  fontSize: 15.0,
                ),
                useRichText: true,
                data: item.text,
                renderNewlines: true,
                onLinkTap: (link) {
                  debugPrint("click link $link");
                  launchURL(context, Uri.parse(link));
                },
              )
            ],
          ),
        ),
      );
}
