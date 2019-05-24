import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/photo.dart';
import 'package:share/share.dart';

import 'config.dart';
import 'utils.dart';

class ImageAppDetail extends StatelessWidget {
  final Photo _photo;

  ImageAppDetail(this._photo);

  void _showPhotoInformation(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.share),
                  title: InkWell(
                    child: Text("Share me"),
                    onTap: () => Share.share(_photo.url),
                  )),
              ListTile(
                leading: Icon(Icons.web),
                title:
                    openWebLinkText(context, "Open on web", _photo.webLocation),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text(_photo.author),
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: Text("${_photo.width} x ${_photo.height}"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        CachedNetworkImage(
          placeholder: (context, url) => Image.asset(
                placeholderUri,
                fit: BoxFit.cover,
              ),
          errorWidget: (context, url, error) => Image.asset(
                errorUri,
                fit: BoxFit.cover,
              ),
          imageUrl: _photo.downloadUrl.toString(),
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                elevation: 15,
                onPressed: () {
                  _showPhotoInformation(context);
                },
                backgroundColor: Colors.pinkAccent,
                child: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }
}
