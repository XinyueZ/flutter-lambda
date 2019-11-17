import 'package:flutter/material.dart';

typedef OnTranslationClicked = Function();

class HNTranslationButtonWidget extends StatelessWidget {
  final AlignmentGeometry alignment;
  final OnTranslationClicked onTranslationClicked;
  final EdgeInsetsGeometry padding;

  const HNTranslationButtonWidget(
      {Key key, this.alignment, this.onTranslationClicked, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: this.alignment,
        child: IconButton(
          padding: this.padding,
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
      );
}
