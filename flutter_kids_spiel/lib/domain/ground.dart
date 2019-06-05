import 'package:sprintf/sprintf.dart';

class Ground {
  String id;
  double latitude;
  double longitude;

  @override
  String toString() => sprintf("id:%s, latitude:%s, longitude:%s",
      [id, latitude.toString(), longitude.toString()]);
}
