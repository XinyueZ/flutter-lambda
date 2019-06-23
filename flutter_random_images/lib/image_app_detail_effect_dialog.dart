import 'package:flutter/material.dart';

enum Effect { Blur, Grayscale }

typedef OnToggleEffect = Function(
    bool checkGrayscale, bool checkBlur, double blurValue);

OnToggleEffect onToggleEffect;

class ImageAppDetailEffectDialog extends StatefulWidget {
  @override
  _ImageAppDetailEffectDialogState createState() =>
      _ImageAppDetailEffectDialogState();
}

class _ImageAppDetailEffectDialogState
    extends State<ImageAppDetailEffectDialog> {
  bool _checkGrayscale = false;
  bool _checkBlur = false;
  double _blurValue = 1;

  void _updateCheckGrayscale(bool value) =>
      setState(() => _checkGrayscale = value);

  void _updateCheckBlur(bool value) => setState(() => _checkBlur = value);

  void _updateBlurValue(double value) =>
      setState(() => _blurValue = _checkBlur ? value : _blurValue);

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
              ),
            ],
          ),
          Slider(
            value: _blurValue,
            onChanged: _updateBlurValue,
            min: 1,
            max: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MaterialButton(
                onPressed: () async {
                  if (onToggleEffect != null)
                    onToggleEffect(_checkGrayscale, _checkBlur, _blurValue);
                },
                child: Text("Apply"),
              ),
              MaterialButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
