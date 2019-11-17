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
  bool _untranslated = false;

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
          _untranslated = false;
        } else {
          _text = null;
          _untranslated = true;
        }
      });
    }();
  }

  @override
  Widget build(BuildContext context) => _text != null && !_untranslated
      ? Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16.0, top: 8),
            child: ListView(
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
                    print("click link $link");
                    launchURL(context, Uri.parse(link));
                  },
                )
              ],
            ),
          ),
        )
      : SizedBox(width: 15, height: 15, child: CircularProgressIndicator());
}
