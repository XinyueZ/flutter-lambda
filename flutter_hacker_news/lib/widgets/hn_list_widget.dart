import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_list_view_model.dart';
import 'package:flutter_hacker_news/widgets/hn_circle_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'hn_list_item_widget.dart';

class HNListWidget extends StatefulWidget {
  @override
  _HNListWidgetState createState() => _HNListWidgetState();
}

class _HNListWidgetState extends State<HNListWidget> {
  ScrollController _listViewCtrl =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _listViewCtrl.addListener(() {
      final bool isEnd =
          _listViewCtrl.offset == _listViewCtrl.position.maxScrollExtent;
      if (isEnd) {
        Provider.of<HNListViewModel>(context).fetchNext();
      }
    });

    super.initState();
  }

  void _onRefresh() async {
    await Provider.of<HNListViewModel>(context).fetchInit();
    _refreshCtrl.refreshCompleted();
  }

  @override
  void dispose() {
    _listViewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HNListViewModel model = Provider.of<HNListViewModel>(context);

    return SmartRefresher(
      header: const MaterialClassicHeader(),
      enablePullDown: true,
      controller: _refreshCtrl,
      onRefresh: _onRefresh,
      child: ListView.builder(
          controller: _listViewCtrl,
          itemExtent: 200.0,
          itemCount: model.storyCount + 1,
          //+1 for loading indicator
          itemBuilder: (BuildContext context, int index) {
            if (index == model.storyCount) {
              return HNCircleLoadingWidget();
            } else {
              return HNListItemWidget(item: model.getStory(index));
            }
          }),
    );
  }
}
