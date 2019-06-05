import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'config.dart';
import 'domain/grounds.dart';
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
  Set<Marker> allMarkers = Set<Marker>();

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  MapViewState(this._mapController);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: allMarkers,
        onCameraIdle: _onCameraIdle,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
      ),
    );
  }

  void _onCameraIdle() async {
    final GoogleMapController c = await _mapController.future;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final PeekSize peekSize = PeekSize(width, height);

    final bounds = await c.getVisibleRegion();
    final latLngBounds = b.LatLngBounds.from(bounds);

    final grounds = await Gateway().loadGrounds(latLngBounds, peekSize);
    _postGroundsOnMap(grounds);
  }

  void _postGroundsOnMap(Grounds grounds) {
    setState(() {
      allMarkers.clear();
      grounds.data.forEach((ground) {
        allMarkers.add(Marker(
          markerId: MarkerId(ground.id ?? "unknown ID"),
          position: ground.latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          onTap: () {
            _launchURL(
                "google.navigation:q=${ground.latLng.latitude},${ground.latLng.longitude}");
          },
        ));
      });
    });
  }
}
