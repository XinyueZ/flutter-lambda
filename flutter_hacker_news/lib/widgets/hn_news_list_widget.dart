import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_top_stories_bloc.dart';
import 'package:flutter_hacker_news/widgets/hn_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'hn_list_news_item_widget.dart';

class HNNewsListWidget extends StatefulWidget {
  @override
  _HNNewsListWidgetState createState() => _HNNewsListWidgetState();
}

class _HNNewsListWidgetState extends State<HNNewsListWidget> {
  ScrollController _listViewCtrl =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _listViewCtrl.addListener(() {
      final bool isEnd =
          _listViewCtrl.offset == _listViewCtrl.position.maxScrollExtent;
      if (isEnd) {
        Provider.of<HNTopStoriesBloc>(context).fetchNext();
      }
    });

    super.initState();
  }

  void _onRefresh() async {
    await Provider.of<HNTopStoriesBloc>(context).fetchInit();
    _refreshCtrl.refreshCompleted();
  }

  @override
  void dispose() {
    _listViewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HNTopStoriesBloc model = Provider.of<HNTopStoriesBloc>(context);

    return SmartRefresher(
      header: const MaterialClassicHeader(),
      enablePullDown: true,
      controller: _refreshCtrl,
      onRefresh: _onRefresh,
      child: ListView.builder(
          controller: _listViewCtrl,
          itemExtent: 150.0,
          itemCount: model.storyCount + 1,
          //+1 for loading indicator
          itemBuilder: (BuildContext context, int index) {
            if (index == model.storyCount) {
              return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Card(child: HNLoadingWidget()));
            } else {
              return HNListNewsItemWidget(item: model.getStory(index));
            }
          }),
    );
  }
}
