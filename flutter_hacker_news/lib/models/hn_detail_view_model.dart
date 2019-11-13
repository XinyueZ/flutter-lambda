import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/extensions.dart';
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

  List<HNComment> firstLayerComments;

  HNDetailViewModel(this._item) {
    _fetchFirstLayerComments();
  }

  _fetchFirstLayerComments() async {
    List<HNComment> comments = await fetchComments(currentHackerNews);

    if (firstLayerComments == null)
      firstLayerComments = List();
    else
      firstLayerComments.clear();

    firstLayerComments.addAll(comments);
    notifyListeners();
  }

  Future<List<HNComment>> fetchComments(HNItem item) async {
    List<HNComment> list = await item.buildComments(_dio, loadAll: false);
    list.sort((HNItem a, HNItem b) => b.time.compareTo(a.time));
    return list;
  }
}
