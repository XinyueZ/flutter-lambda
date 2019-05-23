import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_random_images/domain/photo.dart';

import 'config.dart';

class ImageAppDetail extends StatelessWidget {
  final Photo _photo;

  ImageAppDetail(this._photo);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CachedNetworkImage(
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
    ));
  }
}