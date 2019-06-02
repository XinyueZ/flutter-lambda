import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'config.dart';
import 'domain/weather.dart';
import 'map.dart';
import 'service/gateway.dart';

typedef LoadingWeatherCallback = Function(Weather weather);

class WeatherChip extends StatefulWidget {
  @override
  _WeatherChipState createState() => _WeatherChipState();
}

class _WeatherChipState extends State<WeatherChip> {
  Weather _weather;

  @override
  void initState() {
    loadingWeatherCallback = (weather) {
      _updateWeather(weather);
    };

    super.initState();
  }

  _updateWeather(weather) {
    setState(() {
      this._weather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(top: 25.0, left: 15.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(3),
            onTap: () async {
              ///TODO Optimise duplicated codes below, there's same code in [map.dart].
              Position position = await Geolocator()
                  .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              Locale myLocale = Localizations.localeOf(context);
              final weather = await Gateway().loadWeather(position.latitude,
                  position.longitude, myLocale.toLanguageTag());

              loadingWeatherCallback(weather);
            },
            child: Chip(
              padding: EdgeInsets.only(left: 3),
              avatar: Image.network(
                  _weather?.iconLocation?.toString() ?? DEFAULT_ICON_URL),
              label: Text(
                _weather?.temperatureString ?? DATA_NULL,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.pinkAccent,
            ),
          ),
        ));
  }
}
