class ServiceAreaLocation {
  final double lat;
  final double lng;

  ServiceAreaLocation(this.lat, this.lng);

  factory ServiceAreaLocation.from(Map<String, dynamic> map) {
    return ServiceAreaLocation(map["lat"], map["lon"]);
  }
}

class Area {
  final List<ServiceAreaLocation> locations;

  Area(this.locations);

  factory Area.from(Map<String, dynamic> map) {
    final locations = map["locations"];
    final listOfLocation = List<ServiceAreaLocation>();
    locations.forEach((l) => listOfLocation.add(ServiceAreaLocation.from(l)));
    return Area(listOfLocation);
  }
}

class ServiceAreaLocationAttributes {
  final Area area;
  final ServiceAreaLocation topLeft;
  final ServiceAreaLocation bottomRight;
  final String timeZone;
  final String city;
  final String country;

  ServiceAreaLocationAttributes(this.area, this.topLeft, this.bottomRight,
      this.timeZone, this.city, this.country);

  factory ServiceAreaLocationAttributes.from(Map<String, dynamic> map) {
    final topLeft = ServiceAreaLocation.from(map["topLeft"]);
    final bottomRight = ServiceAreaLocation.from(map["bottomRight"]);
    final timeZone = map["timeZone"];
    final city = map["city"];
    final country = map["country"];

    final area = Area.from(map["area"]);

    return ServiceAreaLocationAttributes(
        area, topLeft, bottomRight, timeZone, city, country);
  }
}

class ServiceParameters {
  final int maxSeats;
  final int childSeats;
  final int wheelchairSeats;

  ServiceParameters(this.maxSeats, this.childSeats, this.wheelchairSeats);

  factory ServiceParameters.from(Map<String, dynamic> map) {
    return ServiceParameters(
        map["maxSeats"], map["childSeats"], map["wheelchairSeats"]);
  }
}

class ServiceArea {
  final ServiceAreaLocationAttributes locationAttributes;
  final ServiceParameters serviceParameters;

  ServiceArea(this.locationAttributes, this.serviceParameters);

  factory ServiceArea.from(Map<String, dynamic> map) {
    final locationAttributes =
        ServiceAreaLocationAttributes.from(map["locationAttributes"]);
    final serviceParameters = ServiceParameters.from(map["serviceParameters"]);
    return ServiceArea(locationAttributes, serviceParameters);
  }
}

class ServiceAreas {
  final List<ServiceArea> listOfServiceArea;

  ServiceAreas(this.listOfServiceArea);

  factory ServiceAreas.from(Map<String, dynamic> map) {
    final listOfServiceArea = List<ServiceArea>();

    map["serviceAreas"].forEach((l) {
      listOfServiceArea.add(ServiceArea.from(l));
    });

    return ServiceAreas(listOfServiceArea);
  }
}
