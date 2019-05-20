import 'dart:io';

import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/ping.dart';
import 'package:flutter_random_images/service/gateway.dart';

typedef InternetAddressLookup = Future<List<InternetAddress>> Function();

class ImageAppSplashViewModel {
  final Service _service;
  final InternetAddressLookup _internetAddressLookup;

  ImageAppSplashViewModel(this._service, this._internetAddressLookup);

  Future<bool> ping() async {
    final Ping ping = await _service.ping();
    switch (ping.origin) {
      case nullPlaceholder:
        return false;
    }
    return true;
  }

  Future<bool> checkApiBase() async {
    try {
      final List<InternetAddress> result = await _internetAddressLookup();
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } catch (_) {
      return false;
    }
  }
}
