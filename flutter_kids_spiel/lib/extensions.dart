import 'dart:async';

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
  Future<LatLng> getMapCenterLatLng() async {
    final LatLngBounds latLngBounds = await getVisibleRegion();
    final double lat =
        (latLngBounds.southwest.latitude + latLngBounds.northeast.latitude) / 2;
    final double lng =
        (latLngBounds.southwest.longitude + latLngBounds.northeast.longitude) /
            2;
    return LatLng(lat, lng);
  }
}
