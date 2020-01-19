import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';

import '../config.dart';
import '../decoder_helper.dart';
import '../domain/extensions.dart';

class HNJobsBloc extends ChangeNotifier {
  final List<HNElement> _elements = List();

  final List<HNJob> _jobs = List();

  List<HNJob> get jobList => _jobs;

  int get jobsCount => jobList.length;

  HNJob getJobs(int index) => jobList[index];

  final Dio _dio = Dio(BaseOptions(
    baseUrl: API_HOST,
    connectTimeout: 3000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  ));

  HNJobsBloc() {
    fetchInit();
  }

  _fetchElements() async {
    Response response = await _dio.get(JOBS_ID_LIST);
    final List<dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    feedsMap.forEach((elementId) {
      _elements.add(HNObject(elementId));
    });
  }

  _fetchJobs() async {
    jobList.addAll(await _elements.buildJobs(_dio));
    notifyListeners();
  }

  fetchInit() async {
    _elements.clear();
    await _fetchElements();
    _jobs.clear();
    await _fetchJobs();
  }
}
