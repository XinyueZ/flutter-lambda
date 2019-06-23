import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/photo.dart';

import 'config.dart';
import 'image_app_detail_effect.dart';
import 'image_app_detail_effect_dialog.dart';
import 'viewmodel/image_app_detail_view_model.dart';

class ImageAppDetail extends StatefulWidget {
  final Photo _photo;
  final ImageAppDetailViewModel _viewModel;

  ImageAppDetail(this._photo) : _viewModel = ImageAppDetailViewModel(_photo);

  @override
  _ImageAppDetailState createState() => _ImageAppDetailState();
}

class _ImageAppDetailState extends State<ImageAppDetail> {
  Uri _imageLocation;
  bool _checkGrayscale = false;
  bool _checkBlur = false;
  double _blurValue = 1;

  @override
  void initState() {
    onToggleEffect = (bool checkGrayscale, bool checkBlur, double blurValue) {
      _checkGrayscale = checkGrayscale;
      _checkBlur = checkBlur;
      _blurValue = blurValue;

      setState(() {
        if (checkGrayscale && checkBlur) {
          _imageLocation = widget._photo.getGrayscaleBlur(blurValue.toInt());
        } else if (checkGrayscale) {
          _imageLocation = widget._photo.grayscale;
        } else if (checkBlur) {
          _imageLocation = widget._photo.getBlur(blurValue.toInt());
        }
      });
    };
    _imageLocation = widget._photo.downloadLocation;
    super.initState();
  }

  void _showPhotoInformation(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
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
          imageUrl: _imageLocation.toString(),
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
                      child: ImageAppDetailEffectMenuItem(
                          _checkGrayscale, _checkBlur, _blurValue),
                    ),
                  ];
                },
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            elevation: 15,
            onPressed: () {
              _showPhotoInformation(context);
            },
            backgroundColor: Colors.pinkAccent,
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
