import 'dart:io';

import 'package:flutter_random_images/service/http_client_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("http-client provider test-suit", () {
    final HttpClientProvider provider = HttpClientProvider();
    final String hostTest = "http://mocks.io";
    final String endpointTest = "/mockApi";

    test("should create uri with combine", () async {
      final Uri uri = provider.createUri(hostTest, endpointTest);
      expect(hostTest + endpointTest, uri.toString());
    });

    test("should create request with right method", () async {
      Uri uriShouldBe = Uri.parse(hostTest + endpointTest);
      final HttpClientRequest getRequest =
          await provider.createRequest(hostTest, endpointTest, "GET");
      // ignore: unawaited_futures
      getRequest.close();
      expect(getRequest.method, "GET");
      expect(getRequest.uri, uriShouldBe);

      final HttpClientRequest postRequest =
          await provider.createRequest(hostTest, endpointTest, "POST");
      // ignore: unawaited_futures
      postRequest.close();
      expect(postRequest.method, "POST");
      expect(postRequest.uri, uriShouldBe);

      final HttpClientRequest putRequest =
          await provider.createRequest(hostTest, endpointTest, "PUT");
      // ignore: unawaited_futures
      putRequest.close();
      expect(putRequest.method, "PUT");
      expect(putRequest.uri, uriShouldBe);
    });

    test("should catch error when the method is not found", () async {
      var catchUnknownMethodFailure = false;
      try {
        await provider.createRequest(hostTest, endpointTest, "PUTasdfasdf");
      } catch (e) {
        catchUnknownMethodFailure = true;
      }
      expect(catchUnknownMethodFailure, true);
    });
  });
}
