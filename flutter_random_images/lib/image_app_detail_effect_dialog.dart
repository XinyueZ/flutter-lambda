import 'package:flutter/material.dart';

class ImageAppDetailEffectDialog extends StatefulWidget {
  @override
  _ImageAppDetailEffectDialogState createState() =>
      _ImageAppDetailEffectDialogState();
}

class _ImageAppDetailEffectDialogState
    extends State<ImageAppDetailEffectDialog> {
  bool _checkGrayscale = false;
  bool _checkBlur = false;

  void _updateCheckGrayscale(bool value) {
    setState(() {
      _checkGrayscale = value;
    });
  }

  void _updateCheckBlur(bool value) {
    setState(() {
      _checkBlur = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Effect"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
