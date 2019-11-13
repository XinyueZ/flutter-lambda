import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils.dart';

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
              if (model.firstLayerComments.isEmpty) return Text("No comments");
              final HNComment comment = model.firstLayerComments[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Html(
                  data: comment.text,
                  onLinkTap: (link) {
                    print("click link $link");
                    launchURL(context, Uri.parse(link));
                  },
                ),
              );
            }),
      ),
    );
  }
}
