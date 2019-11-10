import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_list_model.dart';
import 'package:flutter_hacker_news/widgets/hn_circle_loading_widget.dart';
import 'package:provider/provider.dart';

import 'hn_list_item_widget.dart';

class HNListWidget extends StatefulWidget {
  @override
  _HNListWidgetState createState() => _HNListWidgetState();
}

class _HNListWidgetState extends State<HNListWidget> {
  ScrollController _listViewCtrl =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    _listViewCtrl.addListener(() {
      var isEnd =
          _listViewCtrl.offset == _listViewCtrl.position.maxScrollExtent;
      if (isEnd) {
        Provider.of<HNListModel>(context).fetchNext();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _listViewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HNListModel model = Provider.of<HNListModel>(context);

    return ListView.builder(
        controller: _listViewCtrl,
        itemExtent: 150.0,
        itemCount: model.storyCount + 1,
        //+1 for loading indicator
        itemBuilder: (BuildContext context, int index) {
          if (index == model.storyCount) {
            return HNCircleLoadingWidget();
          } else {
            return HNListItemWidget(model.getStory(index));
          }
        });
  }
}
