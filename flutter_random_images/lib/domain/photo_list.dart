import 'photo.dart';

//
//
//    [
//    {
//    "id": "0",
//    "author": "Alejandro Escamilla",
//    "width": 5616,
//    "height": 3744,
//    "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
//    "download_url": "https://picsum.photos/id/0/5616/3744"
//    },
//    {
//    "id": "100",
//    "author": "Tina Rataj",
//    "width": 2500,
//    "height": 1656,
//    "url": "https://unsplash.com/photos/pwaaqfoMibI",
//    "download_url": "https://picsum.photos/id/100/2500/1656"
//    },
//    ........
//    ......
//    ......
//    ]
//
class PhotoList {
  List<Photo> data = List<Photo>();

  @override
  String toString() {
    final StringBuffer stringBuffer = StringBuffer();
    data.forEach((photo) {
      stringBuffer.writeln(photo.toString());
    });
    final ret = stringBuffer.toString();
    stringBuffer.clear();
    return ret;
  }
}
