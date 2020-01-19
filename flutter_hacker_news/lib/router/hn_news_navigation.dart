import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_news_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_news_list_widget.dart';

import 'navigation_constants.dart';

class HNNewsNavigation extends CupertinoTabView {
  HNNewsNavigation()
      : super(onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case TAB_HN_NEWS_TO_ROOT:
              return CupertinoPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => HNNewsWidget(),
              );
            case TAB_HN_NEWS_TO_DETAIL:
              if (settings.arguments is! HNStory) {
                throw Exception(
                    "Unexpected object ${settings.arguments} for HNNewsDetailWidget.");
              }
              final HNStory hnItem = settings.arguments as HNStory;
              return CupertinoPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => HNNewsDetailWidget(item: hnItem),
              );
            default:
              throw Exception(
                  "Unexpected route ${settings.name} in HNNewsNavigation.");
          }
        });

  static const int TAB_HN_NEWS_INDEX = 0;
}
