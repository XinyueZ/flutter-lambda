import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/photo_list.dart';
import 'package:flutter_random_images/viewmodel/image_app_page_view_model.dart';

import 'domain/photo.dart';

class ImageAppPage extends StatefulWidget {
  final int index;

  ImageAppPage({Key key, this.index}) : super(key: key);

  @override
  _ImageAppPageState createState() => _ImageAppPageState(index);
}

class _ImageAppPageState extends State<ImageAppPage> {
  final int _index;
  final PhotoList _photoList = PhotoList();
  final ImageAppPageViewModel _viewModel = ImageAppPageViewModel();

  _ImageAppPageState(this._index);

  Future<PhotoList> _loadPhotoList() async {
    PhotoList photoList = await _viewModel.loadPhotoList(_index, defaultLimit);
    return photoList;
  }

  @override
  void initState() {
    _loadPhotoList().then((newList) {
      setState(() {
        _photoList.data.addAll(newList.data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          itemCount: _photoList.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: lineCount),
          itemBuilder: (BuildContext context, int index) =>
              ImageCell(_photoList.data[index])),
    );
  }
}

class ImageCell extends StatefulWidget {
  final Photo _photo;

  ImageCell(this._photo);

  @override
  _ImageCellState createState() => _ImageCellState();
}

class _ImageCellState extends State<ImageCell> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Hero(
        tag: widget._photo.id,
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(3),
            child: GridTile(
              child: CachedNetworkImage(
                placeholder: (context, url) => Image.asset(
                      placeholderUri,
                      fit: BoxFit.cover,
                    ),
                errorWidget: (context, url, error) => Image.asset(
                      errorUri,
                      fit: BoxFit.cover,
                    ),
                imageUrl: widget._photo.downloadUrl,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
