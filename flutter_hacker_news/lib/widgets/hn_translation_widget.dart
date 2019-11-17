import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_translation_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils.dart';

class HNTranslationWidget extends StatefulWidget {
  final String origin;
  final EdgeInsetsGeometry margin;
  final TextStyle textStyle;

  HNTranslationWidget({
    Key key,
    @required this.origin,
    this.margin,
    this.textStyle,
  });

  @override
  _HNTranslationWidgetState createState() => _HNTranslationWidgetState();
}

class _HNTranslationWidgetState extends State<HNTranslationWidget> {
  String _text;
  bool _untranslated = true;

  @override
  void initState() {
    super.initState();
    () async {
      final HNTranslationBloc model = HNTranslationBloc(widget.origin);
      debugPrint("want to translate: ${widget.origin}");
      await model.translate();
      setState(() {
        if (model?.translated?.isNotEmpty == true) {
          _text = model.translated;
        } else {
          _text = widget.origin;
        }
        _untranslated = false;
      });
    }();
  }

  @override
  Widget build(BuildContext context) => !_untranslated
      ? Expanded(
          child: Container(
            margin: widget.margin,
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Html(
                  defaultTextStyle: widget.textStyle,
                  useRichText: true,
                  data: _text,
                  renderNewlines: true,
                  onLinkTap: (link) {
                    debugPrint("click link $link");
                    launchURL(context, Uri.parse(link));
                  },
                )
              ],
            ),
          ),
        )
      : Expanded(
          child: Center(
              child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ))));
}
