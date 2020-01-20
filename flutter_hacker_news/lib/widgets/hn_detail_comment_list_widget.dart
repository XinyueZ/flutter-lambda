import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/blocs/hn_news_detail_bloc.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_comment_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HNDetailCommentListWidget extends StatefulWidget {
  @override
  _HNDetailCommentListWidgetState createState() =>
      _HNDetailCommentListWidgetState();
}

class _HNDetailCommentListWidgetState extends State<HNDetailCommentListWidget> {
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Provider.of<HNNewsDetailBloc>(context).fetchFirstLayerComments();
    _refreshCtrl.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final HNNewsDetailBloc model = Provider.of<HNNewsDetailBloc>(context);

    if (model.firstLayerComments == null)
      return HNLoadingWidget(
        count: 2,
      );

    return Expanded(
      child: Container(
        child: SmartRefresher(
          header: const MaterialClassicHeader(),
          enablePullDown: true,
          controller: _refreshCtrl,
          onRefresh: _onRefresh,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: model.firstLayerComments.isNotEmpty
                  ? model.firstLayerComments.length
                  : 1,
              itemBuilder: (BuildContext context, int index) {
                if (model.firstLayerComments.isEmpty)
                  return Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Text("No comments"),
                  );
                final HNComment comment = model.firstLayerComments[index];
                return HNDetailCommentWidget(comment: comment);
              }),
        ),
      ),
    );
  }
}
