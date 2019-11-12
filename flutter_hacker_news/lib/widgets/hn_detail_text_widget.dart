import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class HNDetailTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNDetailViewModel model = Provider.of<HNDetailViewModel>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16),
        child: Linkify(
          onOpen: (link) async {
            print("click link $link");
            launchURL(context, Uri.parse(link.url));
          },
          text: model.currentHackerNews.text,
          style: TextStyle(fontSize: 20),
          linkStyle:
              TextStyle(color: Colors.lightBlue, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
