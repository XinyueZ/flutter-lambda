import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'service_area.dart';

extension MOIAServiceAreasExtension on MOIAServiceAreas {
  List<MOIAServiceArea> filterAreasBy(LatLng latLng) =>
      listOfServiceArea.where((area) {
        final ServiceAreaLocationAttributes attr = area.locationAttributes;
        final LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(attr.bottomRight.lat, attr.topLeft.lng),
            northeast: LatLng(attr.topLeft.lat, attr.bottomRight.lng));
        return bounds.contains(latLng);
      }).toList();
}
