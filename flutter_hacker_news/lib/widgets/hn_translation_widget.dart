import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_translation_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils.dart';

class HNTranslationWidget extends StatefulWidget {
  final String origin;

  HNTranslationWidget({
    Key key,
    @required this.origin,
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
            margin: const EdgeInsets.only(left: 16.0),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Html(
                  defaultTextStyle: const TextStyle(
                    height: 1.5,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                  ),
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
