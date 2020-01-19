import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:flutter_hacker_news/widgets/hn_jobs_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_news_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_detail_widget.dart';
import 'package:flutter_hacker_news/widgets/hn_news_list_widget.dart';

import 'navigation_constants.dart';

class HNJobsNavigation extends CupertinoTabView {
  HNJobsNavigation()
      : super(onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case TAB_HN_JOBS_TO_ROOT:
              return CupertinoPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => HNJobsWidget(),
              );
            default:
              throw Exception(
                  "Unexpected route ${settings.name} in HNJobsNavigation.");
          }
        });

  static const int TAB_HN_JOBS_INDEX = 1;
}
