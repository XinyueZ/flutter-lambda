import 'package:sprintf/sprintf.dart';

import '../config.dart';

class Weather {
  final num id;
  final String name;
  final Uri iconLocation;
  final double temperature;
  final String unit;

  Weather(this.id, this.name, this.iconLocation, this.temperature, this.unit);

  factory Weather.from(Map<String, dynamic> map) {
    final id = map["id"] ?? DATA_NULL;
    final name = map["name"] ?? DATA_NULL;

    var icon = "50d";
    final List<dynamic> listOfDetails = map["weather"] ?? List<dynamic>();
    if (listOfDetails.isNotEmpty) {
      final firstDetail = listOfDetails.first;
      icon = firstDetail["icon"] ?? icon;
    }
    final iconLocation = Uri.parse(sprintf(WEATHER_ICON_URL, [icon]));

    final main = map["main"] ?? Map<String, dynamic>();
    final temperature = main["temp"] ?? DATA_NULL;

    return Weather(id, name, iconLocation, temperature, TEMP_UNIT);
  }

  get temperatureString => "${temperature.toStringAsFixed(0)} $unit";

  @override
  String toString() {
    return sprintf("id:%d, name:%s, icon:%s, temp:%f, unit:%s",
        [id, name, iconLocation.toString(), temperature, unit]);
  }
}
