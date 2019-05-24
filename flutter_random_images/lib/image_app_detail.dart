import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_random_images/domain/photo.dart';

import 'config.dart';

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
                leading: Icon(Icons.people),
                title: Text(_photo.author),
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: Text("${_photo.width} x ${_photo.height}"),
              ),
              ListTile(
                leading: Icon(Icons.web),
                title: InkWell(
                    child: Text("${_photo.webLocation}",
                        style: TextStyle(
                            color: Colors.lightBlue,
                            decoration: TextDecoration.underline)),
                    onTap: () => _launchURL(context, _photo.webLocation)),
              ),
            ],
          );
        });
  }

  void _launchURL(BuildContext context, Uri target) async {
    try {
      await launch(
        target.toString(),
        option: CustomTabsOption(
          toolbarColor: Colors.black,
          //Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
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
            title: Text(_photo.author),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showPhotoInformation(context);
            },
            backgroundColor: Colors.pinkAccent,
            child: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
