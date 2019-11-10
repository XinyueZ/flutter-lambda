import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_list_model.dart';
import 'package:provider/provider.dart';

import 'hn_list_widget.dart';

class HNContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HNListModel>.value(
        value: HNListModel(), child: HNListWidget());
  }
}
