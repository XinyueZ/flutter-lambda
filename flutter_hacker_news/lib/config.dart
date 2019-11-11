import 'dart:ui';

const APP_NAME = "HN Flutter";
const APP_PRIMARY_COLOR = const Color.fromRGBO(255, 102, 0, 1);
const APP_ACCENT_COLOR = const Color.fromRGBO(255, 102, 0, 1);
const APP_BACKGROUND_COLOR = const Color.fromRGBO(245, 246, 240, 1);
const API_HOST = "https://hacker-news.firebaseio.com/v0";
const TOP_STORIES_ID_LIST = "/topstories.json?print=pretty";
const CONTENT = "/item/%s.json?print=pretty";
const MAX_ITEM = "/maxitem.json?print=pretty";
const INIT_PAGE_SIZE = 30;
const NEXT_PAGE_SIZE = 5;
const NULL_UNKNOWN = "unknown";
const NULL_PLACEHOLDER = "n/a";
const NULL_NUM = -1;
const NULL_URI = "http://mock.io";
