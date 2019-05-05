
import 'package:sprintf/sprintf.dart';

import '../config.dart';

//
//{
//"id": "0",
//"author": "Alejandro Escamilla",
//"width": 5616,
//"height": 3744,
//"url": "https://unsplash.com/photos/yC-Yzbqy7PY",
//"download_url": "https://picsum.photos/id/0/5616/3744"
//}
//
class Photo {
  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;

  Photo(this.id, this.author, this.width, this.height, this.url,
      this.downloadUrl);

  Uri get webLocation => Uri.parse(url);

  Uri get downloadLocation => Uri.parse(downloadUrl);

  int get originWidth => width;

  int get originHeight => height;

  @override
  String toString() => sprintf(
      "id:%s, author:%s, width:%d, height:%d, url:%s, downloadUrl:%s",
      [id, author, width, height, url, downloadUrl]);

  static Photo from(Map<String, dynamic> map) => Photo(
      map["id"] ?? nullPlaceholder,
      map["author"] ?? nullPlaceholder,
      map["width"] ?? -1,
      map["height"] ?? -1,
      map["url"] ?? nullPlaceholder,
      map["download_url"] ?? nullPlaceholder);
}
