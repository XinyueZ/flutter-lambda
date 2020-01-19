import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/config.dart';

import 'hn_jobs_navigation.dart';
import 'hn_news_navigation.dart';

class RootTabNavigation extends StatelessWidget {
  GlobalKey<NavigatorState> currentNavigatorKey() {
    switch (_tabController.index) {
      case HNNewsNavigation.TAB_HN_NEWS_INDEX:
        return HNNewsNavigation.newsTabNavKey;
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          return !await currentNavigatorKey().currentState.maybePop();
        },
        child: CupertinoTabScaffold(
            controller: _tabController,
            tabBar: CupertinoTabBar(
              backgroundColor: APP_PRIMARY_COLOR,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                  ),
                  title: Text(
                    "NEWS",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                  title: Text(
                    "JOBS",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              CupertinoTabView featureNavigation;
              switch (index) {
                case HNNewsNavigation.TAB_HN_NEWS_INDEX:
                  featureNavigation = HNNewsNavigation();
                  break;
                case HNJobsNavigation.TAB_HN_JOBS_INDEX:
                  featureNavigation = HNJobsNavigation();
                  break;
                default:
                  throw Exception(
                      "Unexpected feature navigation at tab: $index in RootTabNavigation.}");
              }
              return featureNavigation;
            }),
      ),
    );
  }

  final CupertinoTabController _tabController = CupertinoTabController();
}
