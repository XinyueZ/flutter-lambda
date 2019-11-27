import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kids_spiel/app_credentials.dart';
import 'package:flutter_kids_spiel/domain/ground.dart';
import 'package:flutter_kids_spiel/domain/grounds.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart';
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/request.dart';
import 'package:flutter_kids_spiel/domain/weather.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'decoder_helper.dart';

abstract class HttpProvider {
  Future<dynamic> get(path);

  Future<dynamic> post(path, data);
}

class DioProvider implements HttpProvider {
  final Dio _dio = Dio();
  static final DioProvider instance = DioProvider();

  DioProvider() {
    _dio.options.headers = {"Content-Type": "application/json"};
  }

  @override
  Future<dynamic> get(path) => _dio.get(path);

  @override
  Future<dynamic> post(path, data) => _dio.post(path, data: data);
}

class Gateway {
  final HttpProvider _httpProvider;
  static final Gateway instance = Gateway(DioProvider.instance);

  Gateway(this._httpProvider);

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

  Future<Weather> loadWeather(double lat, double lng, String lang) async {
    final path = sprintf(API_WEATHER, [lat, lng, lang]);

    final response = await _httpProvider.get(path);
    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    return Weather.from(feedsMap);
  }
}

loadMOIAServiceAreas() async {
  final String pathAuth = sprintf(MOIA_API_HOST, [MOIA_API_AUTH]);
  final String pathServiceAreas =
  sprintf(MOIA_API_HOST, [MOIA_API_SERVICE_AREAS]);
  final Dio dio = Dio();
  dio.options.headers = {
    "Content-Type": "application/json",
    "accept": "application/vnd.moia+json",
    "authorization": MOIA_AUTHORIZATION
  };
  final response = await dio.post(pathAuth, data: MOIA_USER);
  final Map<String, dynamic> feedsMap =
  DecoderHelper.getJsonDecoder().convert(response.toString());
  debugPrint(feedsMap.toString());
}
