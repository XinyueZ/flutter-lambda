import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'domain/grounds.dart';
import 'domain/latlng_bounds.dart' as llb;
import 'domain/moia/service_area.dart';
import 'domain/peek_size.dart';
import 'main.dart';
import 'navi/navi.dart';
import 'service/gateway.dart';
import 'weather_chip.dart';
import 'extensions.dart';

LoadingGroundsCallback loadingGroundsCallback;
LoadingWeatherCallback loadingWeatherCallback;

class MapView extends StatefulWidget {
  final MapViewState state = MapViewState();

  set center(Position position) {
    state.animateCamera(position);
  }

  @override
  State<MapView> createState() {
    return state;
  }
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _allMarkers = Set<Marker>();
  final Set<Polygon> _polygons = Set<Polygon>();
  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  BitmapDescriptor _markerIcon;
  bool _myLocationEnabled = false;
  Gateway _gateway;

  @override
  void dispose() {
    _gateway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _gateway = Provider.of<Gateway>(context);

    _createMarkerImageFromAsset(context);

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: _allMarkers,
        polygons: _polygons,
        onCameraIdle: _onCameraIdle,
        myLocationEnabled: _myLocationEnabled,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
      ),
    );
  }

  void animateCamera(Position position) async {
    final GoogleMapController c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: ZOOM.toDouble(),
    )));

    setState(() {
      _myLocationEnabled = Platform.isIOS ? false : true;
    });
  }

  void _onCameraIdle() async {
    final GoogleMapController c = await _mapController.future;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final PeekSize peekSize = PeekSize(width, height);

    final bounds = await c.getVisibleRegion();
    final latLngBounds = llb.LatLngBounds.from(bounds);

    _populateGrounds(latLngBounds, peekSize);
    _populateMOIAServiceAreas();
    _populateWeather(c);
  }

  _populateWeather(GoogleMapController c) async {
    final devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    final latLng = await c.getLatLng(
      ScreenCoordinate(
        x: (context.size.width * devicePixelRatio) ~/ 2.0,
        y: (context.size.height * devicePixelRatio) ~/ 2.0,
      ),
    );
    _gateway.fetchWeather(latLng.latitude, latLng.longitude,
        Localizations.localeOf(context).toLanguageTag());
    _gateway.weatherController.setStreamListener((weather) {
      loadingWeatherCallback(weather);
    });
  }

  _populateMOIAServiceAreas() {
    _gateway.fetchMOIAServiceAreas();
    _gateway.moiaServiceAreasController.setStreamListener((serviceAreas) {
      _postMOIAService(serviceAreas);
    });
  }

  _populateGrounds(llb.LatLngBounds latLngBounds, PeekSize peekSize) {
    _gateway.fetchGrounds(latLngBounds, peekSize);
    _gateway.groundsController.setStreamListener((grounds) {
      _postGroundsOnMap(grounds);
      loadingGroundsCallback(true);
    });
  }

  void _postGroundsOnMap(Grounds grounds) async {
    _allMarkers.clear();
    grounds.data.forEach((ground) {
      _allMarkers.add(Marker(
        visible: true,
        markerId: MarkerId(ground.id ?? "unknown ID"),
        position: ground.latLng,
        icon: _markerIcon,
        onTap: () {
          INavi.build().openMap(ground.latLng);
        },
      ));
    });
  }

  void _postMOIAService(MOIAServiceAreas serviceAreas) async {
    setState(() {
      _polygons.clear();

      final listOfLatLng = List<LatLng>();

      serviceAreas.listOfServiceArea[0].locationAttributes.area.locations
          .forEach((loc) {
        final LatLng latlng = LatLng(loc.lat, loc.lng);
        debugPrint("$latlng");
        listOfLatLng.add(latlng);
      });

      final Polygon polygon = Polygon(
          polygonId: PolygonId("polygon_id_1"),
          strokeWidth: 10,
          points: listOfLatLng,
          strokeColor: Colors.pink,
          fillColor: Colors.transparent,
          visible: true);

      _polygons.add(polygon);
    });
  }

  _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      var imageConfiguration;
      var pin = "asserts/images/ic_pin.png";

      if (Platform.isIOS) {
        imageConfiguration = createLocalImageConfiguration(context);
        pin = "asserts/images/ic_ios_pin.png";
      } else {
        imageConfiguration =
            createLocalImageConfiguration(context, size: Size(300, 300));
      }

      BitmapDescriptor.fromAssetImage(imageConfiguration, pin)
          .then((BitmapDescriptor bitmap) {
        setState(() {
          _markerIcon = bitmap;
        });
      });
    }
  }
}
