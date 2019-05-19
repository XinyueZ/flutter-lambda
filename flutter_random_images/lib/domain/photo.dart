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

const thumbnailSize = 200;

class Photo {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  Photo(this.id, this.author, this.width, this.height, this.url,
      this.downloadUrl);

  factory Photo.from(Map<String, dynamic> map) => Photo(
      map["id"] ?? nullPlaceholder,
      map["author"] ?? nullPlaceholder,
      map["width"] ?? -1,
      map["height"] ?? -1,
      map["url"] ?? nullPlaceholder,
      map["download_url"] ?? nullPlaceholder);

  Uri get webLocation => Uri.parse(url);

  Uri get downloadLocation => Uri.parse(downloadUrl);

  Uri get thumbnail {
    //
    //Download is "https://picsum.photos/id/121/1600/1067"
    //Thumbnail shall be  "https://picsum.photos/id/121/$thumbnailSize/$thumbnailSize"
    //
    final heightSlash = downloadUrl.lastIndexOf("/"); //find: /1067
    final removeHeightSlashToEnd = downloadUrl.substring(0, heightSlash);
    final widthSlash = removeHeightSlashToEnd.lastIndexOf("/"); //find: /1600
    final removeWidthSlashToEnd =
        removeHeightSlashToEnd.substring(0, widthSlash);
    final thumbnailUrl = "$removeWidthSlashToEnd/$thumbnailSize/$thumbnailSize";

    return Uri.parse(thumbnailUrl);
  }

  int get originWidth => width;

  int get originHeight => height;

  @override
  String toString() => sprintf(
      "id:%s, author:%s, width:%d, height:%d, url:%s, downloadUrl:%s",
      [id, author, width, height, url, downloadUrl]);
}
