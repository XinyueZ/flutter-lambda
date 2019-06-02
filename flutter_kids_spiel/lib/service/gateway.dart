import 'package:dio/dio.dart';
import 'package:flutter_kids_spiel/domain/ground.dart';
import 'package:flutter_kids_spiel/domain/grounds.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart';
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/request.dart';
import 'package:flutter_kids_spiel/domain/weather.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'decoder_helper.dart';

class Gateway {
  final Dio _dio = Dio();

  Gateway() {
    _dio.options.headers = {"Content-Type": "application/json"};
  }

  Future<Grounds> loadGrounds(LatLngBounds bound, PeekSize peekSize) async {
    final payload = GroundRequest.from(bound, peekSize).toPayload();
    final response = await _dio.post(API_GROUNDS, data: payload);

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

    final response = await _dio.get(path);
    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    return Weather.from(feedsMap);
  }
}
