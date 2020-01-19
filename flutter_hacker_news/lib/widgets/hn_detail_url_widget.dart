import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_news_detail_bloc.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class HNDetailUrlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNNewsDetailBloc model = Provider.of<HNNewsDetailBloc>(context);
    final Uri uri = (model.currentHackerNews as HNStory).uri;
    return Expanded(
      child: Container(
        child: openWebLinkText(context, uri.toString(), uri),
      ),
    );
  }
}
