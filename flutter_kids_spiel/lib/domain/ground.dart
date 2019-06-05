import 'package:sprintf/sprintf.dart';

class Ground {
  final String id;
  final String kind;
  final double latitude;
  final double longitude;

  Ground(Map<String, dynamic> g)
      : id = g["id"],
        kind = g["kind"],
        latitude = g["lat"],
        longitude = g["lon"];

  @override
  String toString() => sprintf("id:%s, kind:%s, latitude:%s, longitude:%s",
      [id, kind, latitude.toString(), longitude.toString()]);
}
