import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/ping.dart';
import 'package:flutter_random_images/service/gateway.dart';
import 'package:flutter_random_images/service/http_client_provider.dart';

class ImageAppSplashViewModel {
  final Service service = Service(HttpClientProvider());

  Future<bool> ping() async {
    final Ping ping = await service.ping();
    switch (ping.origin) {
      case nullPlaceholder:
        return false;
    }
    return true;
  }
}
