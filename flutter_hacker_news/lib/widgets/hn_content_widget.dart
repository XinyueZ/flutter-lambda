import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_list_view_bloc.dart';
import 'package:provider/provider.dart';

import 'hn_list_widget.dart';

class HNContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<HNListBloc>.value(
          value: HNListBloc(), child: HNListWidget());
}
