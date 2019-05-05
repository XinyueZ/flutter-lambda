import 'dart:io';

import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/ping.dart';
import 'package:flutter_random_images/service/gateway.dart';
import 'package:flutter_random_images/viewmodel/image_app_splash_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockService extends Mock implements Service {}

void main() {
  group("ImageAppSplashViewModel test-suit", () {
    final service = MockService();
    test("should ping return true when the service can give origin", () async {
      Ping ping = Ping("12.13.21.5");
      when(service.ping()).thenAnswer((_) => Future.value(ping));

      final viewModel = ImageAppSplashViewModel(
          service, () => Future.value(List<InternetAddress>()));
      final checked = await viewModel.ping();

      expect(true, checked);
    });
    test("should ping return false when the service cannot give origin",
        () async {
      Ping ping = Ping(nullPlaceholder);
      when(service.ping()).thenAnswer((_) => Future.value(ping));

      final viewModel = ImageAppSplashViewModel(
          service, () => Future.value(List<InternetAddress>()));
      final checked = await viewModel.ping();

      expect(false, checked);
    });
    test(
        "should checkApiBase return true when list of InternetAddress is not empty",
        () async {
      final List<InternetAddress> list = List();
      list.add(InternetAddress("12.11.41.4"));
      list.add(InternetAddress("12.13.21.5"));
      final ImageAppSplashViewModel viewModel =
          ImageAppSplashViewModel(any, () => Future.value(list));

      final checked = await viewModel.checkApiBase();

      expect(true, checked);
    });
    test(
        "should checkApiBase return false when list of InternetAddress is empty",
        () async {
      final ImageAppSplashViewModel viewModel = ImageAppSplashViewModel(
          any, () => Future.value(List<InternetAddress>()));

      final checked = await viewModel.checkApiBase();

      expect(false, checked);
    });
  });
}
