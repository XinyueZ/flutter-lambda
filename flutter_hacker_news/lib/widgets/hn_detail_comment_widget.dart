import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_detail_bloc.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_comment_info_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_loading_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'hn_author_widget.dart';
import 'hn_time_widget.dart';
import 'hn_translation_button_widget.dart';
import 'hn_translation_widget.dart';

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
  bool _translate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        _translate
            ? Row(
                children: <Widget>[
                  HNTranslationWidget(
                    origin: widget.comment.text,
                    margin: const EdgeInsets.all(0),
                    textStyle: DefaultTextStyle.of(context).style,
                  ),
                ],
              )
            : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 10),
                child: Html(
                  useRichText: true,
                  data: widget.comment.text,
                  onLinkTap: (link) {
                    debugPrint("click link $link");
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
                    final list = await Provider.of<HNDetailBloc>(context)
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
                HNTranslationButtonWidget(
                  alignment: Alignment.topLeft,
                  onTranslationClicked: () {
                    setState(() {
                      _translate = !_translate;
                    });
                  },
                  padding: const EdgeInsets.only(bottom: 0, left: 0),
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
