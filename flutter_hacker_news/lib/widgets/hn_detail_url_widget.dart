import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class HNDetailUrlWidget extends StatelessWidget {
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
          text: (model.currentHackerNews as HNStory).uri.toString(),
          linkStyle: TextStyle(color: Colors.lightBlue),
        ),
      ),
    );
  }
}
