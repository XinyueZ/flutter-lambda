import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import '../config.dart';

class HNDetailViewModel extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: API_HOST,
    connectTimeout: 3000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  ));

  final HNItem _item;

  HNItem get currentHackerNews => _item;

  HNDetailViewModel(this._item);
}
