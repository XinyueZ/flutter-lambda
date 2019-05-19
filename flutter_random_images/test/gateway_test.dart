import 'dart:io';

import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/photo.dart';
import 'package:flutter_random_images/domain/photo_list.dart';
import 'package:flutter_random_images/service/decoder_helper.dart';
import 'package:flutter_random_images/service/gateway.dart';
import 'package:flutter_random_images/service/http_client_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockStreamString extends Mock implements Stream<String> {}

class MockHttpClientProvider extends Mock implements IHttpClientProvider {}

void main() {
  group("gateway test-suit", () {
    final String hostTest = "http://mocks.io";
    final String endpointTest = "/mockApi";

    final HttpClientRequest mockRequest = MockHttpClientRequest();
    final HttpClientResponse mockResponse = MockHttpClientResponse();
    final Stream<String> mockStream = MockStreamString();
    final IHttpClientProvider mockClientProvider = MockHttpClientProvider();

    final server = Service(mockClientProvider);

    when(mockResponse.transform(DecoderHelper.getUtf8Decoder()))
        .thenAnswer((_) => mockStream);
    when(mockRequest.uri).thenReturn(Uri.parse("http://mockurl.com"));
    when(mockRequest.close()).thenAnswer((_) => Future.value(mockResponse));

    test("should get response future", () async {
      final HttpClientResponse response = await server.getResponse(mockRequest);
      expect(response, mockResponse);
    });

    test("should get response in string future", () async {
      final String dummyResponse = "dummy dummy";
      when(mockStream.join()).thenAnswer((_) => Future.value(dummyResponse));
      final String response = await server.getResponseString(mockRequest);
      expect(response, dummyResponse);
    });

    test("should get response PhotoList future", () async {
      final String photoListResponse = """[
      {
        "id": "0",
      "author": "Alejandro Escamilla",
      "width": 5616,
      "height": 3744,
      "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
      "download_url": "https://picsum.photos/id/0/5616/3744"
      },
      {
      "id": "100",
      "author": "Tina Rataj",
      "width": 2500,
      "height": 1656,
      "url": "https://unsplash.com/photos/pwaaqfoMibI",
      "download_url": "https://picsum.photos/id/100/2500/1656"
      }
      ]""";

      when(mockClientProvider.createRequest(hostTest, endpointTest, "GET"))
          .thenAnswer((_) => Future.value(mockRequest));
      when(mockStream.join())
          .thenAnswer((_) => Future.value(photoListResponse));
      final PhotoList response = await server.getPhotoList(0, 0,
          host: hostTest, endpoint: endpointTest);
      expect(2, response.data.length);

      final Photo photo_1 = response.data.first;
      expect("0", photo_1.id);
      expect("Alejandro Escamilla", photo_1.author);
      expect(5616, photo_1.width);
      expect(3744, photo_1.height);
      expect("https://unsplash.com/photos/yC-Yzbqy7PY", photo_1.url);
      expect("https://picsum.photos/id/0/5616/3744", photo_1.downloadUrl);

      final Photo photo_2 = response.data.last;
      expect("100", photo_2.id);
      expect("Tina Rataj", photo_2.author);
      expect(2500, photo_2.width);
      expect(1656, photo_2.height);
      expect("https://unsplash.com/photos/pwaaqfoMibI", photo_2.url);
      expect("https://picsum.photos/id/100/2500/1656", photo_2.downloadUrl);
    });

    test("should have nothing if feeds is containing 0-size data", () async {
      final String photoListResponse = """[]""";

      when(mockClientProvider.createRequest(hostTest, endpointTest, "GET"))
          .thenAnswer((_) => Future.value(mockRequest));
      when(mockStream.join())
          .thenAnswer((_) => Future.value(photoListResponse));
      final PhotoList response = await server.getPhotoList(0, 0,
          host: hostTest, endpoint: endpointTest);
      expect(0, response.data.length);
    });

    test("should have nothing if feeds is totally empty", () async {
      final String photoListResponse = """""";

      when(mockClientProvider.createRequest(hostTest, endpointTest, "GET"))
          .thenAnswer((_) => Future.value(mockRequest));
      when(mockStream.join())
          .thenAnswer((_) => Future.value(photoListResponse));
      final PhotoList response = await server.getPhotoList(0, 0,
          host: hostTest, endpoint: endpointTest);
      expect(0, response.data.length);
    });

    test("should use default values when the feeds cannot provide data",
        () async {
      final String photoListResponse = """[
      {
      },
      {
      }
      ]""";
      when(mockClientProvider.createRequest(hostTest, endpointTest, "GET"))
          .thenAnswer((_) => Future.value(mockRequest));
      when(mockStream.join())
          .thenAnswer((_) => Future.value(photoListResponse));
      final PhotoList response = await server.getPhotoList(0, 0,
          host: hostTest, endpoint: endpointTest);
      expect(2, response.data.length);

      final Photo photo_1 = response.data.first;
      expect(nullPlaceholder, photo_1.id);
      expect(nullPlaceholder, photo_1.author);
      expect(photo_1.width < 0, true);
      expect(photo_1.height < 0, true);
      expect(nullUri, photo_1.url);
      expect(nullUri, photo_1.downloadUrl);

      final Photo photo_2 = response.data.first;
      expect(nullPlaceholder, photo_2.id);
      expect(nullPlaceholder, photo_2.author);
      expect(photo_2.width < 0, true);
      expect(photo_2.height < 0, true);
      expect(nullUri, photo_2.url);
      expect(nullUri, photo_2.downloadUrl);
    });
  });
}
