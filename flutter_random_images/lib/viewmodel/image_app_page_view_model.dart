import 'package:flutter_random_images/domain/photo_list.dart';
import 'package:flutter_random_images/service/gateway.dart';
import 'package:flutter_random_images/service/http_client_provider.dart';

class ImageAppPageViewModel {
  final Service service = Service(HttpClientProvider());

  Future<PhotoList> loadPhotoList(int page, int limit) async =>
      service.getPhotoList(page, limit);
}
