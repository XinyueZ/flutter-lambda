import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_detail_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class HNDetailTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNDetailBloc model = Provider.of<HNDetailBloc>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10),
          child: Html(
            defaultTextStyle: const TextStyle(fontSize: 20),
            useRichText: true,
            data: model.currentHackerNews.text,
            onLinkTap: (link) {
              print("click link $link");
              launchURL(context, Uri.parse(link));
            },
          ),
        ),
      ),
    );
  }
}
