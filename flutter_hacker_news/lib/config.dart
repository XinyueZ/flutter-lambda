import 'dart:ui';

import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';

const APP_NAME = "HN Tree";
const APP_PRIMARY_COLOR = const Color.fromRGBO(255, 121, 0, 1);
const APP_ACCENT_COLOR = const Color.fromRGBO(255, 121, 0, 1);
const APP_BACKGROUND_COLOR = const Color.fromRGBO(245, 246, 240, 1);
const API_HOST = "https://hacker-news.firebaseio.com/v0";
const TOP_STORIES_ID_LIST = "/topstories.json?print=pretty";
const CONTENT = "/item/%s.json?print=pretty";
const MAX_ITEM = "/maxitem.json?print=pretty";
const INIT_PAGE_SIZE = 15;
const NEXT_PAGE_SIZE = 5;
const NULL_UNKNOWN = "unknown";
const NULL_PLACEHOLDER = "n/a";
const NULL_NUM = null;
const NULL_URI = "https://www.google.com";
const GOOGLE_PLAY_LOCATION = "http://tinyurl.com/tdh4b39";
const APP_SLOGAN = "Share different ideas, discussions and topics of IT, Geek and various technoledge.";
const APP_SHARE_SUBJECT = "Hacker News by $APP_NAME";
const APP_SHARE_CONTENT = "$APP_SLOGAN\nGoogle Play: $GOOGLE_PLAY_LOCATION";
const HN_COMMENT_PAGE = "Discussion: https://news.ycombinator.com/item?id=%s";
const ITEM_SHARE_SUBJECT = "Shared by $APP_NAME";
const ITEM_SHARE_CONTENT = "%s\n%s\n%s\n====\n$APP_SHARE_CONTENT";
const API_PROVIDER = "https://github.com/HackerNews/API";
const APP_OPEN_SOURCE = "http://tinyurl.com/s6kmvwb";

initSupportedLanguage() async {
  final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
  debugPrint("dl lang: ${window.locale.languageCode}");
  await modelManager.downloadModel(window.locale.languageCode);
}
