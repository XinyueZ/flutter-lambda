import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_kids_spiel/domain/ground.dart';
import 'package:flutter_kids_spiel/domain/grounds.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart';
import 'package:flutter_kids_spiel/domain/moia/service_area.dart';
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/request.dart';
import 'package:flutter_kids_spiel/domain/weather.dart';
import 'package:sprintf/sprintf.dart';

import '../app_credentials.dart';
import '../config.dart';
import 'decoder_helper.dart';

abstract class HttpProvider {
  Future<dynamic> get(path);

  Future<dynamic> post(path, data);

  set requestHeaders(Map<String, String> keyValues);

  void clearHeaders();
}

class DioProvider implements HttpProvider {
  final Dio _dio = Dio();

  @override
  Future<dynamic> get(path) => _dio.get(path);

  @override
  Future<dynamic> post(path, data) => _dio.post(path, data: data);

  @override
  set requestHeaders(Map<String, String> keyValues) {
    _dio.options.headers = keyValues;
  }

  @override
  void clearHeaders() {
    _dio.options.headers.clear();
  }
}

class Gateway {
  final HttpProvider _httpProvider;
  final StreamController<Grounds> groundsController = StreamController();
  final StreamController<MOIAServiceAreas> moiaServiceAreasController =
      StreamController();
  final StreamController<Weather> weatherController = StreamController();

  Gateway(this._httpProvider);

  dispose() {
    groundsController.close();
    moiaServiceAreasController.close();
    weatherController.close();
  }

  fetchGrounds(LatLngBounds bound, PeekSize peekSize) async {
    final payload = GroundRequest.from(bound, peekSize).toPayload();

    _httpProvider.requestHeaders = {"Content-Type": "application/json"};
    final response = await _httpProvider.post(API_GROUNDS, payload);
    _httpProvider.clearHeaders();

    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    final List<dynamic> feedsResult = feedsMap["result"];

    final res = Grounds();
    feedsResult.forEach((g) {
      res.data.add(Ground(g));
    });

    groundsController.sink.add(res);
  }

  fetchWeather(double lat, double lng, String lang) async {
    final path = sprintf(API_WEATHER, [lat, lng, lang]);

    _httpProvider.requestHeaders = {"Content-Type": "application/json"};
    final response = await _httpProvider.get(path);
    _httpProvider.clearHeaders();

    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    weatherController.sink.add(Weather.from(feedsMap));
  }

  fetchMOIAServiceAreas() async {
    final String pathAuth = sprintf("%s%s", [MOIA_API_HOST, MOIA_API_AUTH]);

    _httpProvider.requestHeaders = {
      "Content-Type": "application/json",
      "accept": "application/vnd.moia+json",
      "authorization": MOIA_AUTHORIZATION
    };
    var response = await _httpProvider.post(pathAuth, MOIA_USER);
    _httpProvider.clearHeaders();

    var feedsMap = DecoderHelper.getJsonDecoder().convert(response.toString());
    final String idToken = feedsMap["id_token"];

    _httpProvider.requestHeaders  = {
      "Content-Type": "application/vnd.moia.v1+json",
      "accept": "application/vnd.moia.v1+json",
      "moia-auth": idToken
    };
    final String pathServiceAreas =
        sprintf("%s%s", [MOIA_API_HOST, MOIA_API_SERVICE_AREAS]);
    response = await _httpProvider.get(pathServiceAreas);
    _httpProvider.clearHeaders();

    feedsMap = DecoderHelper.getJsonDecoder().convert(response.toString());
    moiaServiceAreasController.sink.add(MOIAServiceAreas.from(feedsMap));
  }

  @deprecated
  Future<Grounds> loadGrounds(LatLngBounds bound, PeekSize peekSize) async {
    final payload = GroundRequest.from(bound, peekSize).toPayload();
    final response = await _httpProvider.post(API_GROUNDS, payload);

    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    final List<dynamic> feedsResult = feedsMap["result"];

    final res = Grounds();
    feedsResult.forEach((g) {
      res.data.add(Ground(g));
    });

    return res;
  }

  @deprecated
  Future<Weather> loadWeather(double lat, double lng, String lang) async {
    final path = sprintf(API_WEATHER, [lat, lng, lang]);

    final response = await _httpProvider.get(path);
    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    return Weather.from(feedsMap);
  }
}
