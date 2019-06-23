import 'package:flutter/material.dart';

import 'image_app_detail_effect_dialog.dart';

class ImageAppDetailEffectMenuItem extends StatefulWidget {
  @override
  _ImageAppDetailEffectMenuItemState createState() =>
      _ImageAppDetailEffectMenuItemState();
}

class _ImageAppDetailEffectMenuItemState
    extends State<ImageAppDetailEffectMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
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
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => ImageAppDetailEffectDialog());
      },
    );
  }
}
