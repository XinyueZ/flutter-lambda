import 'package:dio/dio.dart';
import 'package:flutter_kids_spiel/domain/ground.dart';
import 'package:flutter_kids_spiel/domain/grounds.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart';
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/request.dart';

import '../config.dart';
import 'decoder_helper.dart';

class Gateway {
  final Dio _dio = Dio();

  Gateway() {
    _dio.options.headers = {"Content-Type": "application/json"};
  }

  Future<Grounds> loadGrounds(LatLngBounds bound, PeekSize peekSize) async {
    final payload = Request.from(bound, peekSize).toPayload();
    final response = await _dio.post(API, data: payload);

    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(response.toString());
    final List<dynamic> feedsResult = feedsMap["result"];

    final res = Grounds();
    feedsResult.forEach((g) {
      res.data.add(Ground(g));
    });

    return res;
  }
}
