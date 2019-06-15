import 'package:flutter_kids_spiel/config.dart';
import 'package:flutter_kids_spiel/utils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:test_api/test_api.dart';

void main() {
  group("utils test-suit", () {
    test("should latlngToTile and tileToLatLng be reversing", () {
      var tupleTiles = latlngToTile(ZOOM, 53.61123562, 9.96796678899);
      var tupleTilesString =
          sprintf("%d/%d/%d", [tupleTiles[0], tupleTiles[1], tupleTiles[2]]);
      print(tupleTilesString);
      print("->");

      var tupleLatLng =
          tileToLatLng(tupleTiles[0], tupleTiles[1], tupleTiles[2]);
      var tupleLatLngString =
          sprintf("%d/%f/%f", [tupleLatLng[0], tupleLatLng[1], tupleLatLng[2]]);
      print(tupleLatLngString);
      print("->");

      expect(tupleTiles[0], tupleLatLng[0]);
      expect(
          double.parse(
              double.parse(tupleLatLng[1].toString()).toStringAsFixed(3)),
          53.611);
      expect(
          double.parse(
              double.parse(tupleLatLng[2].toString()).toStringAsFixed(3)),
          9.967);

      tupleLatLng = tileToLatLng(ZOOM, 138330, 84649);
      tupleLatLngString =
          sprintf("%d/%f/%f", [tupleLatLng[0], tupleLatLng[1], tupleLatLng[2]]);
      print(tupleLatLngString);
      print("->");

      tupleTiles = latlngToTile(tupleLatLng[0], tupleLatLng[1], tupleLatLng[2]);
      tupleTilesString =
          sprintf("%d/%d/%d", [tupleTiles[0], tupleTiles[1], tupleTiles[2]]);
      print(tupleTilesString);
      print("->");

      expect(tupleTiles[0], tupleLatLng[0]);
      expect(tupleTiles[1], 138330);
      expect(tupleTiles[2], 84649);
    });
  });

  test("should toRadians and toDegrees be reversing", () {
    final double radians30 = toRadians(30);
    final double degrees30 = toDegrees(radians30);
    expect(degrees30.round(), 30);

    final double radians47 = toRadians(47);
    final double degrees47 = toDegrees(radians47);
    expect(degrees47.round(), 47);

    final double degrees23 = toDegrees(23);
    final double radians23 = toRadians(degrees23);
    expect(radians23.round(), 23);
  });
}
