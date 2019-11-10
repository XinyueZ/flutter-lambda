import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import '../config.dart';
import '../decoder_helper.dart';
import '../domain/extensions.dart';

class HNListModel extends ChangeNotifier {
  final List<HNElement> _elements = List();

  final List<HNStory> _stories = List();

  List<HNStory> get storyList => _stories;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: API_HOST,
    connectTimeout: 3000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  ));

  HNListModel() {
    _fetchAll();
  }

  _fetchAll() async {
    await _fetchElements();
    await _fetchStories(0, 10);
  }

  _fetchElements() async {
    _elements.clear();
    Response response = await _dio.get(TOP_STORIES_ID_LIST);
    final List<dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    feedsMap.forEach((elementId) {
      _elements.add(HNElement(elementId));
    });
  }

  _fetchStories(int from, int to) async {
    _stories.clear();
    _stories.addAll(await _elements.sublist(from, to).buildStories(_dio));
    notifyListeners();
  }
}
