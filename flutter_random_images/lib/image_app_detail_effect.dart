import 'package:flutter/material.dart';

import 'image_app_detail_effect_dialog.dart';

class ImageAppDetailEffectMenuItem extends StatelessWidget {
  bool _checkGrayscale = false;
  bool _checkBlur = false;
  double _blurValue = 1;

  ImageAppDetailEffectMenuItem(
      this._checkGrayscale, this._checkBlur, this._blurValue);

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
            builder: (context) => ImageAppDetailEffectDialog(
                _checkGrayscale, _checkBlur, _blurValue));
      },
    );
  }
}
