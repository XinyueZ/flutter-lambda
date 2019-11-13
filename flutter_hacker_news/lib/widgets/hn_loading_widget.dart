import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HNLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double lineHeight = 10;
    Padding lineSpace = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
    );
    __shimmerLine(double lineWidth) =>
        Container(
          width: lineWidth,
          height: lineHeight,
          color: Colors.white,
        );

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              __shimmerLine(width),
              lineSpace,
              __shimmerLine(width / 2),
              lineSpace,
              __shimmerLine(width / 3),
              lineSpace,
              __shimmerLine(width / 4),
              lineSpace,
              __shimmerLine(width / 4),
              lineSpace,
            ],
          )),
    );
  }
}
