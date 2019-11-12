import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import '../config.dart';
import '../decoder_helper.dart';
import '../domain/extensions.dart';

class HNListViewModel extends ChangeNotifier {
  final List<HNElement> _elements = List();

  final List<HNStory> _stories = List();

  List<HNStory> get storyList => _stories;

  int get storyCount => storyList.length;

  HNStory getStory(int index) => storyList[index];

  int _from = 0;
  int _to = 0;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: API_HOST,
    connectTimeout: 3000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  ));

  HNListViewModel() {
    fetchInit();
  }

  _fetchElements() async {
    Response response = await _dio.get(TOP_STORIES_ID_LIST);
    final List<dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    feedsMap.forEach((elementId) {
      _elements.add(HNElement(elementId));
    });
  }

  _fetchStories(int from, int to) async {
    print("load from $_from to $_to");
    _stories.addAll(await _elements.sublist(from, to).buildStories(_dio));
    notifyListeners();
  }

  fetchInit() async {
    _from = 0;
    _to = _from + INIT_PAGE_SIZE;

    _elements.clear();
    await _fetchElements();
    _stories.clear();
    await _fetchStories(_from, _to);
  }

  fetchNext() async {
    _from = _to;
    _to = _from + NEXT_PAGE_SIZE;
    _fetchStories(_from, _to);
  }
}
