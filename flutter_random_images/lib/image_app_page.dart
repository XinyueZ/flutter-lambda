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
  final int index;
  final PhotoList photoList = PhotoList();
  final ImageAppPageViewModel viewModel = ImageAppPageViewModel();

  _ImageAppPageState(this.index);

  Future<PhotoList> _loadPhotoList() async {
    PhotoList photoList = await viewModel.loadPhotoList(index, defaultLimit);
    return photoList;
  }

  @override
  void initState() {
    _loadPhotoList().then((newList) {
      setState(() {
        photoList.data.addAll(newList.data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          itemCount: photoList.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: lineCount),
          itemBuilder: (BuildContext context, int index) =>
              ImageCell(photo: photoList.data[index])),
    );
  }
}

class ImageCell extends StatelessWidget {
  final Photo photo;

  ImageCell({this.photo});

  @override
  Widget build(BuildContext context) => Card(
        child: Hero(
          tag: photo.id,
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
                  imageUrl: photo.downloadUrl,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      );
}
