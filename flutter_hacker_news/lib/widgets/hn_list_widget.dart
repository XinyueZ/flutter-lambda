import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/models/hn_list_model.dart';
import 'package:provider/provider.dart';

import '../config.dart';

class HNListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HNListModel model = Provider.of<HNListModel>(context);

    return ListView.builder(
        itemCount: model.storyList == null ? 0 : model.storyList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 140,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: APP_ACCENT_COLOR,
                          child: InkWell(
                            splashColor: APP_PRIMARY_COLOR,
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: Center(
                                child: Text(
                                    model.storyList[index].by[0].toUpperCase()),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(model.storyList[index].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                letterSpacing: 2.0,
                                fontSize: 13.0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
