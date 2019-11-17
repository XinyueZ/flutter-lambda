import 'package:flutter/material.dart';

typedef OnTranslationClicked = Function();

class HNTranslationButtonWidget extends StatelessWidget {
  final AlignmentGeometry alignment;
  final OnTranslationClicked onTranslationClicked;

  const HNTranslationButtonWidget(
      {Key key, this.alignment, this.onTranslationClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Align(
          alignment: this.alignment,
          child: IconButton(
            padding: EdgeInsets.only(bottom: 0, left: 16),
            icon: SizedBox(
              child: Icon(
                Icons.translate,
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              onTranslationClicked();
            },
          ),
        ),
      );
}
