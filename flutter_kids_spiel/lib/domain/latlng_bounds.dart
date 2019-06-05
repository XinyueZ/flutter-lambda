import 'package:google_maps_flutter/google_maps_flutter.dart' as f;

class LatLngBounds {
  final double west;
  final double south;
  final double east;
  final double north;

  LatLngBounds(this.west, this.south, this.east, this.north);

  factory LatLngBounds.from(f.LatLngBounds bounds) {
    return LatLngBounds(bounds.southwest.longitude, bounds.southwest.latitude,
        bounds.northeast.longitude, bounds.northeast.latitude);
  }
}
