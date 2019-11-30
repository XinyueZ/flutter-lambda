import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension StreamControllerExtension<T> on StreamController<T> {
  setStreamListener(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    if (!this.hasListener) {
      this.stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    }
  }
}

extension GoogleMapControllerExtension on GoogleMapController {
  Future<LatLng> getMapCenterLatLng(BuildContext context) async {
    final devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    final latLng = await getLatLng(
      ScreenCoordinate(
        x: (context.size.width * devicePixelRatio) ~/ 2.0,
        y: (context.size.height * devicePixelRatio) ~/ 2.0,
      ),
    );
    return latLng;
  }
}
