import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sprintf/sprintf.dart';

class Ground {
  final String id;
  final String kind;
  final LatLng latLng;

  Ground(Map<String, dynamic> g)
      : id = g["id"],
        kind = g["kind"],
        latLng = LatLng(g["lat"], g["lon"]);

  @override
  String toString() => sprintf("id:%s, kind:%s, latitude:%s, longitude:%s",
      [id, kind, latLng.latitude.toString(), latLng.longitude.toString()]);
}
