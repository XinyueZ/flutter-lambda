class ServiceAreaLocation {
  final double lat;
  final double lng;

  ServiceAreaLocation(this.lat, this.lng);
}

class Area {
  final List<ServiceAreaLocation> locations;

  Area(this.locations);
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
}

class ServiceParameters {
  final int maxSeats;
  final int childSeats;
  final int wheelchairSeats;

  ServiceParameters(this.maxSeats, this.childSeats, this.wheelchairSeats);
}
