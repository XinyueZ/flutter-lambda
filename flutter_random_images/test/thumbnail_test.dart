import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/photo.dart';
import 'package:test_api/test_api.dart';

void main() {
  group("build thumbnail test-suit", () {
    test("should create thumbnail based on download-url of a photo", () {
//      {
//      "id": "121",
//      "author": "Radio Pink",
//      "width": 1600,
//      "height": 1067,
//      "url": "https://unsplash.com/photos/p-bkdO43shE",
//      "download_url": "https://picsum.photos/id/121/1600/1067"
//      },
      Photo photo = Photo(
          "121",
          "Radio Pink",
          1600,
          1067,
          "https://unsplash.com/photos/p-bkdO43shE",
          "https://picsum.photos/id/121/1600/1067");
      expect(
          Uri.parse(
              "https://picsum.photos/id/121/$THUMBNAIL_SIZE/$THUMBNAIL_SIZE"),
          photo.thumbnail);
    });
  });
}
