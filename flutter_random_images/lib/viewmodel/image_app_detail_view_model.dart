import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_random_images/domain/photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../config.dart';
import '../utils.dart';

enum Effect { Blur, Grayscale }

typedef OnToggleEffect = Function(Effect effect);

class ImageAppDetailViewModel {
  final Photo _photo;

  ImageAppDetailViewModel(this._photo);

  Widget get author => Text(_photo.author);

  Widget getWebLocation(BuildContext context) =>
      openWebLinkText(context, "Open on web", _photo.webLocation);

  Widget get share => InkWell(
      child: Text("Share me"), onTap: () => Share.share(_photo.downloadUrl));

  Widget get size => Text("${_photo.width} x ${_photo.height}");

  Widget getDownload(BuildContext context) {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.file_download,
            color: Colors.white,
          ),
          Text(
            "Download",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      color: Theme.of(context).accentColor,
      elevation: 5.0,
      splashColor: Colors.black38,
      onPressed: () async {
        final dir = await getApplicationDocumentsDirectory();
        final fn =
            "${dir.path}/$APP_DISPLAY_NAME-${_photo.author}-${_photo.id}-${_photo.width}x${_photo.height}.jpg";
        Dio dio = Dio();
        dio.download(_photo.downloadUrl, fn, onReceiveProgress: (rec, total) {
          debugPrint("Rec: $rec , Total: $total");
          if (rec == total) {
            Toast.show("Downloaded $fn", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          }
        });
      },
    );
  }

  void menuSelected(String value) {
    switch (value) {
      case "effect":
        debugPrint("Show effect will be waited.");
        break;
    }
  }
}
