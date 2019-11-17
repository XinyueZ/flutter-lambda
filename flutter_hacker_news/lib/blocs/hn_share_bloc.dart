import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';

class HNShareBloc extends ChangeNotifier {
  String subject;
  String shareStory;
  String shareApp;

  storySharing(HNStory story) async {
    final String disCommentLocation = sprintf(HN_COMMENT_PAGE, [story.id]);
    String url = story.uri.toString();
    shareStory =
        sprintf(ITEM_SHARE_CONTENT, [story.text, url, disCommentLocation]);
    subject = ITEM_SHARE_SUBJECT;
    notifyListeners();
  }

  appSharing() async {
    shareApp = APP_SHARE_CONTENT;
    subject = APP_SHARE_SUBJECT;
    notifyListeners();
  }
}
