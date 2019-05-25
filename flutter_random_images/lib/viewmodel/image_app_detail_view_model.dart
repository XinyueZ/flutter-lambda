import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_random_images/domain/photo.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../utils.dart';

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
        children: <Widget>[Icon(Icons.file_download), Text("Download")],
      ),
      color: Theme.of(context).accentColor,
      elevation: 5.0,
      splashColor: Colors.blueGrey,
      onPressed: () async {
        final fn = "${_photo.downloadUrl}.jpg";
        Image(
            image: NetworkToFileImage(
                url: _photo.downloadUrl, file: await file(fn)));
        Toast.show("Downloaded ${_photo.downloadUrl}.jpg", context);
      },
    );
  }
}
