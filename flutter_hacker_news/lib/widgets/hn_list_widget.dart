import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_list_model.dart';
import 'package:provider/provider.dart';

import 'hn_list_item_widget.dart';

class HNListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNListModel model = Provider.of<HNListModel>(context);

    return ListView.builder(
        itemCount: model.storyList == null ? 0 : model.storyList.length,
        itemBuilder: (BuildContext context, int index) =>
            HNListItemWidget(model.storyList[index]));
  }
}
