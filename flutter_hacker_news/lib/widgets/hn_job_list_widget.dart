import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_jobs_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_top_stories_bloc.dart';
import 'package:flutter_hacker_news/widgets/hn_list_job_item_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'hn_list_news_item_widget.dart';

class HNJobListWidget extends StatefulWidget {
  @override
  _HNJobListWidgetState createState() => _HNJobListWidgetState();
}

class _HNJobListWidgetState extends State<HNJobListWidget> {
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Provider.of<HNJobsBloc>(context).fetchInit();
    _refreshCtrl.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final HNJobsBloc model = Provider.of<HNJobsBloc>(context);

    return SmartRefresher(
      header: const MaterialClassicHeader(),
      enablePullDown: true,
      controller: _refreshCtrl,
      onRefresh: _onRefresh,
      child: ListView.builder(
          itemExtent: 150.0,
          itemCount: model.jobsCount + 1,
          //+1 for loading indicator
          itemBuilder: (BuildContext context, int index) {
            if (model.jobList.isEmpty) {
              return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Card(child: HNLoadingWidget()));
            } else if (index == model.jobsCount) {
              return Align(
                  alignment: Alignment.center, child: Text("On the bottom"));
            } else {
              return HNListJobItemWidget(item: model.getJobs(index));
            }
          }),
    );
  }
}
