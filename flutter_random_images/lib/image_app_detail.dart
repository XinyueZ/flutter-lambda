import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/photo.dart';

import 'config.dart';
import 'image_app_detail_effect.dart';
import 'viewmodel/image_app_detail_view_model.dart';

class ImageAppDetail extends StatefulWidget {
  final Photo _photo;
  final ImageAppDetailViewModel _viewModel;

  ImageAppDetail(this._photo) : _viewModel = ImageAppDetailViewModel(_photo);

  @override
  _ImageAppDetailState createState() => _ImageAppDetailState();
}

class _ImageAppDetailState extends State<ImageAppDetail> {
  var _imageLocation;

  @override
  void initState() {
    _imageLocation = widget._photo.downloadUrl.toString();
    super.initState();
  }

  get imageLocation => _imageLocation ?? widget._photo.downloadUrl.toString();

  void _updateImageLocation(Effect effect) {
    setState(() {
      switch (effect) {
        case Effect.Blur:
          break;
        case Effect.Grayscale:
          break;
      }
    });
  }

  void _showPhotoInformation(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.share),
                title: widget._viewModel.share,
              ),
              ListTile(
                  leading: Icon(Icons.web),
                  title: widget._viewModel.getWebLocation(context)),
              ListTile(
                leading: Icon(Icons.people),
                title: widget._viewModel.author,
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: widget._viewModel.size,
              ),
              widget._viewModel.getDownload(context),
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
          imageUrl: imageLocation,
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  onSelected: widget._viewModel.menuSelected,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "effect",
                        child: ImageAppDetailEffectMenuItem(),
                      ),
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
