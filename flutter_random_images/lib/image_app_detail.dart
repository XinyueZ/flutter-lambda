import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/photo.dart';

import 'config.dart';
import 'viewmodel/image_app_detail_view_model.dart';

class ImageAppDetail extends StatelessWidget {
  final Photo _photo;
  final ImageAppDetailViewModel _viewModel;

  ImageAppDetail(this._photo) : _viewModel = ImageAppDetailViewModel(_photo);

  void _showPhotoInformation(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.share),
                title: _viewModel.share,
              ),
              ListTile(
                  leading: Icon(Icons.web),
                  title: _viewModel.getWebLocation(context)),
              ListTile(
                leading: Icon(Icons.people),
                title: _viewModel.author,
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: _viewModel.size,
              ),
              _viewModel.getDownload(context),
              SizedBox(
                height: 10,
              )
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
                PLACEHOLDER_URI,
                fit: BoxFit.cover,
              ),
          errorWidget: (context, url, error) => Image.asset(
                ERROR_URI,
                fit: BoxFit.cover,
              ),
          imageUrl: _photo.downloadUrl.toString(),
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  onSelected: _viewModel.menuSelected,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "effect",
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.format_paint,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Effect")
                            ]),
                      )
                    ];
                  },
                )
              ],
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
