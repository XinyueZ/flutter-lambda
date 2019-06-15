import 'dart:math';

List latlngToTile(final int zoom, final double lat, final double lon) {
  final List<num> tuple = List();

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

List tileToLatLng(final int zoom, final num x, final num y) {
  final List<num> tuple = List();

  tuple.add(zoom);
  tuple.add(tile2lat(y, zoom));
  tuple.add(tile2lon(x, zoom));

  return tuple;
}

toRadians(final x) => x * (pi) / 180;

toDegrees(final x) => x * 180 / (pi);

sinh(x) => (pow(e, x) - pow(e, -x)) / 2;

double tile2lat(final num y, final num zoom) =>
    toDegrees(atan(sinh(pi - (2.0 * pi * y) / pow(2.0, zoom))));

double tile2lon(final num x, final num zoom) =>
    x / pow(2.0, zoom) * 360.0 - 180;
