import '../config.dart';

class Ping {
  final String origin;

  Ping(this.origin);

  factory Ping.from(Map<String, dynamic> map) => Ping(
        map["origin"] ?? NULL_PLACEHOLDER,
      );
}
