import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter_random_images/domain/photo.dart';
import 'package:flutter_random_images/domain/photo_list.dart';
import 'package:flutter_random_images/domain/ping.dart';
import 'package:meta/meta.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'decoder_helper.dart';
import 'http_client_provider.dart';

abstract class Gateway {
  IHttpClientProvider _clientProvider;

  Gateway(this._clientProvider);

  IHttpClientProvider get httpClient => _clientProvider;

  @visibleForTesting
  Future<HttpClientResponse> getResponse(HttpClientRequest request) {
    Future<HttpClientResponse> response = request.close();
    return response;
  }

  @visibleForTesting
  Future<String> getResponseString(HttpClientRequest req) async {
    final HttpClientResponse res = await getResponse(req);
    //Workaround: https://github.com/dart-lang/co19/issues/383
    final String ret = await res
        .cast<List<int>>()
        .transform(DecoderHelper.getUtf8Decoder())
        .join(); // understand utf-8
    return Future.value(ret);
  }
}

class Service extends Gateway {
  Service(IHttpClientProvider clientProvider) : super(clientProvider);

  Future<PhotoList> getPhotoList(int page, int limit,
      {String host = API_HOST,
      String endpoint = API_END_POINT,
      String method = "GET"}) async {
    final String endpointPageLimit = sprintf(endpoint, [page, limit]);
    final HttpClientRequest req =
        await httpClient.createRequest(host, endpointPageLimit, method);
    final String res = await getResponseString(req);

    final PhotoList returnValue = PhotoList();
    //When response is totally empty without data.
    if (res.trim().isEmpty) return Future.value(returnValue);

    final List<dynamic> feedsMap = DecoderHelper.getJsonDecoder().convert(res);
    feedsMap.forEach((p) {
      returnValue.data.add(Photo.from(p));
    });

    return Future.value(returnValue);
  }

  Future<Ping> ping(
      {String host = PING_HOST,
      String endpoint = PING_END_POINT,
      String method = "GET"}) async {
    final HttpClientRequest req =
        await httpClient.createRequest(host, endpoint, method);
    final String res = await getResponseString(req);

    if (res.trim().isEmpty) return Ping(NULL_PLACEHOLDER);

    final Map<String, dynamic> feedsMap =
        DecoderHelper.getJsonDecoder().convert(res);
    final Ping returnValue = Ping.from(feedsMap);

    return returnValue;
  }
}
