import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/blocs/hn_app_about_bloc.dart';
import 'package:provider/provider.dart';

class HNAppAboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNAppAboutBloc model = Provider.of<HNAppAboutBloc>(context);

    return AlertDialog(
      title: Text(
        "About",
        style: TextStyle(fontSize: 27),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: model.aboutList,
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
