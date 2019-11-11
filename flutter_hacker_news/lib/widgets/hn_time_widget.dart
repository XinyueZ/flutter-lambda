import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:intl/intl.dart';

class HNTimeWidget extends StatelessWidget {
  final HNItem _item;
  final DateFormat format = DateFormat("yyyy.MM.dd HH:mm");

  HNTimeWidget(this._item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            format
                .format(DateTime.fromMillisecondsSinceEpoch(_item.time * 1000)),
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
