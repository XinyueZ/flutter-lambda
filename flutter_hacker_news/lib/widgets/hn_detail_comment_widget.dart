import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/models/hn_detail_view_model.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_comment_info_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_loading_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'hn_author_widget.dart';
import 'hn_time_widget.dart';

class HNDetailCommentWidget extends StatefulWidget {
  final HNComment comment;

  HNDetailCommentWidget({
    Key key,
    @required this.comment,
  });

  @override
  _HNDetailCommentWidgetState createState() => _HNDetailCommentWidgetState();
}

class _HNDetailCommentWidgetState extends State<HNDetailCommentWidget> {
  List<HNComment> _listOfChildComment = List();
  bool _showLoadingIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        SizedBox(
          width: 5,
        ),
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Html(
            useRichText: true,
            data: widget.comment.text,
            onLinkTap: (link) {
              print("click link $link");
              launchURL(context, Uri.parse(link));
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                HNTimeWidget(item: widget.comment),
                SizedBox(
                  width: 5,
                ),
                HNAuthorWidget(item: widget.comment),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  child: HNDetailCommentInfoWidget(comment: widget.comment),
                  onTap: () async {
                    setState(() {
                      _showLoadingIndicator = true;
                    });
                    final list = await Provider.of<HNDetailViewModel>(context)
                        .fetchComments(widget.comment);
                    setState(() {
                      _showLoadingIndicator = false;
                    });
                    if (list.isEmpty) {
                      return;
                    }
                    setState(() {
                      _listOfChildComment = list;
                    });
                  },
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
        _showLoadingIndicator
            ? HNLoadingWidget()
            : Container(
                margin: const EdgeInsets.only(left: 8),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _listOfChildComment.isNotEmpty
                        ? _listOfChildComment.length
                        : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (_listOfChildComment.isEmpty) return Container();
                      final HNComment comment = _listOfChildComment[index];
                      return HNDetailCommentWidget(comment: comment);
                    }),
              ),
      ],
    );
  }
}
