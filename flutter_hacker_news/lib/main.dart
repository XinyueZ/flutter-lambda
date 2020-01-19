import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_jobs_bloc.dart';
import 'package:flutter_hacker_news/blocs/hn_top_stories_bloc.dart';
import 'package:flutter_hacker_news/config.dart';
import 'package:flutter_hacker_news/router/root_router.dart';
import 'package:flutter_hacker_news/widgets/hn_splash_widget.dart';
import 'package:provider/provider.dart';

import 'blocs/hn_translation_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HNTopStoriesBloc>.value(
            value: HNTopStoriesBloc()),
        ChangeNotifierProvider<HNJobsBloc>.value(value: HNJobsBloc()),
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
          backgroundColor: APP_BACKGROUND_COLOR,
          primaryColor: APP_PRIMARY_COLOR,
          accentColor: APP_ACCENT_COLOR,
          brightness: Brightness.light,
          primaryColorBrightness: Brightness.light,
        ),
        onGenerateRoute: generateRootRoute,
      ),
    );
  }
}
