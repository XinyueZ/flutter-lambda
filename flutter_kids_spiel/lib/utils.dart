import 'dart:math';

List latlngToTile(final int zoom, final double lat, final double lon) {
  List<num> tuple = List();

  int xtile = ((lon + 180) / 360 * (1 << zoom)).floor();
  int ytile = ((1 - log(tan(toRadians(lat)) + 1 / cos(toRadians(lat))) / pi) /
          2 *
          (1 << zoom))
      .floor();
  if (xtile < 0) xtile = 0;
  if (xtile >= (1 << zoom)) xtile = ((1 << zoom) - 1);
  if (ytile < 0) ytile = 0;
  if (ytile >= (1 << zoom)) ytile = ((1 << zoom) - 1);

  tuple.add(zoom);
  tuple.add(xtile);
  tuple.add(ytile);

  return tuple;
}

List tileToLatLng(final int zoom, final int x, final int y) {
  List<num> tuple = List();

  tuple.add(zoom);
  tuple.add(tile2lat(y, zoom));
  tuple.add(tile2lon(x, zoom));

  return tuple;
}

toRadians(x) => x * (pi) / 180;

toDegrees(x) => x * 180 / (pi);

sinh(x) => (pow(e, x) - pow(e, -x)) / 2;

double tile2lat(int y, int z) {
  double n = pi - (2.0 * pi * y) / pow(2.0, z);
  return toDegrees(atan(sinh(n)));
}

double tile2lon(int x, int z) {
  return x / pow(2.0, z) * 360.0 - 180;
}
