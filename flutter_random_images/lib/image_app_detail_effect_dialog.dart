import 'package:flutter/material.dart';

import 'domain/photo.dart';

typedef OnToggleEffect = Function(
    bool checkGrayscale, bool checkBlur, double blurValue);

Map<String, OnToggleEffect> onToggleEffects = Map();

class ImageAppDetailEffectDialog extends StatefulWidget {
  final _ImageAppDetailEffectDialogState _state;

  ImageAppDetailEffectDialog(checkGrayscale, checkBlur, blurValue)
      : _state = _ImageAppDetailEffectDialogState(
            checkGrayscale, checkBlur, blurValue);

  @override
  _ImageAppDetailEffectDialogState createState() => _state;
}

class _ImageAppDetailEffectDialogState
    extends State<ImageAppDetailEffectDialog> {
  bool _checkGrayscale = false;
  bool _checkBlur = false;
  double _blurValue = 1;

  _ImageAppDetailEffectDialogState(
      this._checkGrayscale, this._checkBlur, this._blurValue);

  void _updateCheckGrayscale(bool value) =>
      setState(() => _checkGrayscale = value);

  void _updateCheckBlur(bool value) => setState(() => _checkBlur = value);

  void _updateBlurValue(double value) =>
      setState(() => _blurValue = _checkBlur ? value : _blurValue);

  _revertAll() {
    _updateBlurValue(1);
    _updateCheckBlur(false);
    _updateCheckGrayscale(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: _checkGrayscale,
                onChanged: _updateCheckGrayscale,
              ),
              InkResponse(
                child: Text("Grayscale"),
                onTap: () => _updateCheckGrayscale(!_checkGrayscale),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: _checkBlur,
                onChanged: _updateCheckBlur,
              ),
              InkResponse(
                child: Text("Blur"),
                onTap: () => _updateCheckBlur(!_checkBlur),
              ),
            ],
          ),
          Slider(
            value: _blurValue,
            onChanged: _updateBlurValue,
            min: BLUR_MIN.toDouble(),
            max: BLUR_MAX.toDouble(),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MaterialButton(
                child: Icon(Icons.replay),
                onPressed: () => _revertAll(),
              ),
              MaterialButton(
                child: Icon(Icons.check),
                onPressed: () {
                  onToggleEffects.values.forEach((on) {
                    on(_checkGrayscale, _checkBlur, _blurValue);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
