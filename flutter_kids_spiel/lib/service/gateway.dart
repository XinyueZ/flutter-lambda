import 'package:dio/dio.dart';
import 'package:flutter_kids_spiel/domain/grounds.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart';
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/request.dart';

import '../config.dart';

class Gateway {
  Dio _dio = Dio();

  Future<Grounds> loadGrounds(LatLngBounds bound, PeekSize peekSize) async {
    final response =
        await _dio.post(API, data: Request.from(bound, peekSize).toPayload());
    print(response);
    return Grounds();
  }
}
