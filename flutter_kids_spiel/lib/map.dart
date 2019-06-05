import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'config.dart';
import 'domain/latlng_bounds.dart' as b;
import 'domain/peek_size.dart';
import 'service/gateway.dart';

class MapView extends StatefulWidget {
  final Completer<GoogleMapController> _mapController = Completer();

  void animateCamera(Position position) async {
    final GoogleMapController c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: ZOOM.toDouble(),
    )));
  }

  @override
  State<MapView> createState() => MapViewState(_mapController);
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController;

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  MapViewState(this._mapController);

  void _onCameraIdle() async {
    final GoogleMapController c = await _mapController.future;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final PeekSize peekSize = PeekSize(width, height);
    final bounds = await c.getVisibleRegion();
    final latLngBounds = b.LatLngBounds.from(bounds);

    await Gateway().loadGrounds(latLngBounds, peekSize);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        onCameraIdle: _onCameraIdle,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
      ),
    );
  }
}
