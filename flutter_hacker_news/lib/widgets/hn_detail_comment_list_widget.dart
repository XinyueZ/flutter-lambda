import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
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
    _refreshCtrl.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final HNDetailViewModel model = Provider.of<HNDetailViewModel>(context);

    if (model.firstLayerComments == null)
      return HNLoadingWidget(
        count: 2,
      );

    return Expanded(
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
    );
  }
}
