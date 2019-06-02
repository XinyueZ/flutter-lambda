import 'package:flutter_kids_spiel/config.dart';
import 'package:flutter_kids_spiel/domain/latlng_bounds.dart' as p;
import 'package:flutter_kids_spiel/domain/peek_size.dart';
import 'package:flutter_kids_spiel/domain/weather.dart';
import 'package:flutter_kids_spiel/service/gateway.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:sprintf/sprintf.dart';

class MockHttpProvider extends Mock implements HttpProvider {}

class WeatherResponse {
  @override
  String toString() => """
          {"coord":{"lon":139,"lat":35},
"sys":{"country":"JP","sunrise":1369769524,"sunset":1369821049},
"weather":[{"id":804,"main":"clouds","description":"overcast clouds","icon":"04n"}],
"main":{"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":292.04},
"wind":{"speed":7.31,"deg":187.002},
"rain":{"3h":0},
"clouds":{"all":92},
"dt":1369824698,
"id":1851632,
"name":"Shuzenji",
"cod":200}
      """;
}

class PlaygroundsResponse {
  @override
  String toString() => """{
	"left": 9.9952106475824,
	"right": 10.338190078735,
	"top": 49.818436149322,
	"bottom": 49.648012751741,
	"width": 999,
	"height": 768,
	"filter": ["playground"],
	"ts": 1560622360984,
	"result": [{
		"lat": 49.776992,
		"kind": "playground",
		"lon": 9.996527,
		"id": "M51062967"
	}, {
		"lat": 49.790656,
		"kind": "playground",
		"lon": 10.016286,
		"id": "M51055498"
	}]
}""";
}

void main() {
  group("gateway happy-path test-suit", () {
    test("should loadWeather as expected", () async {
      final MockHttpProvider mockHttpProvider = MockHttpProvider();
      final WeatherResponse weatherResponse = WeatherResponse();

      final gateway = Gateway(mockHttpProvider);

      when(mockHttpProvider.get(anything))
          .thenAnswer((_) => Future.value(weatherResponse));

      final Weather weather = await gateway.loadWeather(12, 23, "de");

      expect(1851632, weather.id);
      expect("Shuzenji", weather.name);
      expect(
          Uri.parse(sprintf(WEATHER_ICON_URL, ["04n"])), weather.iconLocation);
      expect(289.5, weather.temperature);
      expect(TEMP_UNIT, weather.unit);
    });

    test("should loadGrounds as expected", () async {
      final MockHttpProvider mockHttpProvider = MockHttpProvider();
      final PlaygroundsResponse groundsResponse = PlaygroundsResponse();

      final gateway = Gateway(mockHttpProvider);

      when(mockHttpProvider.post(anything, anything))
          .thenAnswer((_) => Future.value(groundsResponse));

      final grounds =
          await gateway.loadGrounds(p.LatLngBounds(0, 0, 0, 0), PeekSize(1, 1));
      final size = grounds.data.length;

      expect(2, size);

      expect(
          LatLng(
            49.776992,
            9.996527,
          ),
          grounds.data[0].latLng);
      expect("M51062967", grounds.data[0].id);
      expect("playground", grounds.data[0].kind);

      expect(
          LatLng(
            49.790656,
            10.016286,
          ),
          grounds.data[1].latLng);
      expect("M51055498", grounds.data[1].id);
      expect("playground", grounds.data[1].kind);
    });
  });
}
