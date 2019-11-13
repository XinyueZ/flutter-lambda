import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
import 'package:provider/provider.dart';

class HNDetailCommentListWidget extends StatefulWidget {
  @override
  _HNDetailCommentListWidgetState createState() =>
      _HNDetailCommentListWidgetState();
}

class _HNDetailCommentListWidgetState extends State<HNDetailCommentListWidget> {
  @override
  Widget build(BuildContext context) {
    final HNDetailViewModel model = Provider.of<HNDetailViewModel>(context);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: model.firstLayerComments.isNotEmpty
            ? model.firstLayerComments.length
            : 1,
        itemBuilder: (BuildContext context, int index) {
          if (model.firstLayerComments.isEmpty) return Text("No comments");
          final HNComment comment = model.firstLayerComments[index];
          return Text(comment.text);
        });
  }
}
