import 'package:flutter_random_images/domain/photo.dart';
import 'package:test_api/test_api.dart';

void main() {
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

  group("special effects test-suit", () {
    test("should create the special effects based on download-url of a photo",
        () {
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=3"),
          photo.getBlur(3));
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale"),
          photo.grayscale);
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=2"),
          photo.getGrayscaleBlur(2));
    });

    test("should create the blur effect max under 10", () {
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=10"),
          photo.getBlur(10));
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=10"),
          photo.getGrayscaleBlur(10));
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=10"),
          photo.getBlur(11));
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=10"),
          photo.getGrayscaleBlur(11));
    });

    test("should create the blur effect min above 1", () {
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=1"),
          photo.getBlur(-1));
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=1"),
          photo.getGrayscaleBlur(-1));
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=1"),
          photo.getBlur(0));
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=1"),
          photo.getGrayscaleBlur(0));
      expect(Uri.parse("https://picsum.photos/id/121/1600/1067?blur=1"),
          photo.getBlur(1));
      expect(
          Uri.parse("https://picsum.photos/id/121/1600/1067?grayscale&blur=1"),
          photo.getGrayscaleBlur(1));
    });
  });
}
