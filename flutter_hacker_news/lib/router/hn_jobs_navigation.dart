import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/widgets/hn_jobs_widget.dart';

import 'navigation_constants.dart';

class HNJobsNavigation extends CupertinoTabView {
  HNJobsNavigation()
      : super(
            navigatorKey: jobsTabNavKey,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case TAB_HN_JOBS_TO_ROOT:
                  return CupertinoPageRoute<void>(
                    settings: settings,
                    builder: (BuildContext context) => HNJobsWidget(),
                  );
                default:
                  throw Exception(
                      "Unexpected navigation ${settings.name} in HNJobsNavigation.");
              }
            });

  static const int TAB_HN_JOBS_INDEX = 1;
  static GlobalKey<NavigatorState> jobsTabNavKey = GlobalKey<NavigatorState>();
}
