import 'package:sprintf/sprintf.dart';

import 'latlng_bounds.dart';
import 'peek_size.dart';

class GroundRequest {
  final double west;
  final double south;
  final double east;
  final double north;
  final int width;
  final int height;
  final num timestamps;

  GroundRequest(this.west, this.south, this.east, this.north, this.width,
      this.height, this.timestamps);

  factory GroundRequest.from(LatLngBounds bounds, PeekSize peekSize) {
    final res = GroundRequest(
        bounds.west,
        bounds.south,
        bounds.east,
        bounds.north,
        peekSize.width.toInt(),
        peekSize.height.toInt(),
        DateTime.now().millisecondsSinceEpoch);
    return res;
  }

  //{"left":9.957978664484589,"right":9.979414878931198,"top":53.46215403624407,"bottom":53.4523417770031,"width":999,"height":768,"filter":["playground"],"ts":1559731534147,"result":[]}
  String toPayload() => sprintf(""" 
    {"left":%f, "right":%f, "top":%f,"bottom":%f, "width":%d, "height":%d,  "ts":%d, "filter": ["playground"]}
    """, [west, east, north, south, width, height, timestamps]);
}
