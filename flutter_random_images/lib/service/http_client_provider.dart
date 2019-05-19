import 'dart:io';

import 'package:meta/meta.dart';

abstract class IHttpClientProvider {
  Future<HttpClientRequest> createRequest(
      String host, String endpoint, String method);
}

class HttpClientProvider implements IHttpClientProvider {
  final HttpClient _httpClient = HttpClient();

  @visibleForTesting
  Uri createUri(String endpoint, String data) => Uri.parse(endpoint + data);

  Future<HttpClientRequest> createRequest(
      String host, String endpoint, String method) {
    if (method.toUpperCase() == "GET") {
      return _httpClient.getUrl(createUri(host, endpoint));
    }

    if (method.toUpperCase() == "POST") {
      return _httpClient.postUrl(createUri(host, endpoint));
    }

    if (method.toUpperCase() == "PUT") {
      return _httpClient.putUrl(createUri(host, endpoint));
    }

    throw ArgumentError("Not found method, method shall be GET, POST, PUT");
  }
}
