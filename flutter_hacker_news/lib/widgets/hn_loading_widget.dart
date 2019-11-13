import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HNLoadingWidget extends StatelessWidget {
  final int count;

  HNLoadingWidget({this.count = 1});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double lineHeight = 10;
    Padding lineSpace = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
    );
    __shimmerLine(double lineWidth) => Align(
          alignment: Alignment.centerLeft,
          child: Container(
              width: lineWidth, height: lineHeight, color: Colors.white),
        );

    Widget __listOfShimmerLine() {
      List<Widget> list = List();
      for (int i = 0; i < count; i++) {
        list.add(Padding(
          padding: const EdgeInsets.all(20),
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
        ));
      }

      return Column(
        children: list,
      );
    }

    return __listOfShimmerLine();
  }
}
