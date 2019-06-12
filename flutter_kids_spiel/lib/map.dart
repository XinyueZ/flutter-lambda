import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'config.dart';
import 'domain/grounds.dart';
import 'domain/latlng_bounds.dart' as llb;
import 'domain/peek_size.dart';
import 'main.dart';
import 'navi/navi.dart';
import 'service/gateway.dart';

LoadingGroundsCallback loadingGroundsCallback;

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
  final Set<Marker> allMarkers = Set<Marker>();
  final gateway = Gateway();

  BitmapDescriptor _markerIcon;
  bool _myLocationEnabled = false;

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: allMarkers,
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

    Locale myLocale = Localizations.localeOf(context);
    final weather = await gateway.loadWeather(
        position.latitude, position.longitude, myLocale.toLanguageTag());
    debugPrint("weather: $weather \n");
  }

  void _onCameraIdle() async {
    final GoogleMapController c = await _mapController.future;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final PeekSize peekSize = PeekSize(width, height);

    final bounds = await c.getVisibleRegion();
    final latLngBounds = llb.LatLngBounds.from(bounds);

    final Grounds grounds = await gateway.loadGrounds(latLngBounds, peekSize);
    _postGroundsOnMap(grounds);

    loadingGroundsCallback(true);
  }

  _postGroundsOnMap(Grounds grounds) async {
    setState(() {
      allMarkers.clear();
      grounds.data.forEach((ground) {
        allMarkers.add(Marker(
          visible: true,
          markerId: MarkerId(ground.id ?? "unknown ID"),
          position: ground.latLng,
          icon: _markerIcon,
          onTap: () {
            INavi.build().openMap(ground.latLng);
          },
        ));
      });
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
            createLocalImageConfiguration(context, size: Size(350, 350));
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
