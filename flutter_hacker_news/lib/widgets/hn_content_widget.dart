import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_list_view_bloc.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'hn_list_widget.dart';

class HNContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HNListBloc>.value(
        value: HNListBloc(),
        child: Material(
            child: Scaffold(
          appBar: AppBar(
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset('assets/logo/hn_flutter.png'),
                onPressed: () {},
              );
            }),
            title: Text(
              APP_NAME,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: APP_PRIMARY_COLOR,
          ),
          body: HNListWidget(),
        )));
  }
}
