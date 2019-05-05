import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/config.dart';
import 'package:flutter_random_images/domain/photo_list.dart';
import 'package:flutter_random_images/viewmodel/image_app_page_view_model.dart';

import 'domain/photo.dart';

class ImageAppPage extends StatefulWidget {
  ImageAppPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ImageAppPageState createState() => _ImageAppPageState();
}

class _ImageAppPageState extends State<ImageAppPage> {
  final PhotoList photoList = PhotoList();
  final ImageAppPageViewModel viewModel = ImageAppPageViewModel();

  Future<PhotoList> _loadPhotoList() async {
    PhotoList photoList =
        await viewModel.loadPhotoList(startPage, defaultLimit);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
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

  const ImageCell({this.photo});

  @override
  Widget build(BuildContext context) => Card(
        child: Hero(
          tag: photo.id,
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              child: GridTile(
                child: Image.network(photo.downloadUrl, fit: BoxFit.cover),
              ),
              onTap: () {},
            ),
          ),
        ),
      );
}
