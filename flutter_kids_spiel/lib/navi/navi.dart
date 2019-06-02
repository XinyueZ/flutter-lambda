import 'dart:io' show Platform;

import 'package:android_intent/android_intent.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

NaviOS _naviOS = NaviOS();

NaviOther _naviOther = NaviOther();

abstract class INavi {
  void openMap(LatLng latLng);

  static INavi build() {
    switch (Platform.isIOS) {
      case true:
        return _naviOS;
      default:
        return _naviOther;
    }
  }
}

class NaviOS extends INavi {
  @override
  void openMap(LatLng latLng) async {
    Position center = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String googleUrl =
        "comgooglemaps://?center=${center.latitude},${center.longitude}&q=${latLng.latitude},${latLng.longitude}";
    String appleUrl =
        "https://maps.apple.com/?q=${latLng.latitude},${latLng.longitude}";

    if (await canLaunch("comgooglemaps://")) {
      debugPrint("launching com googleUrl");
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      debugPrint("launching apple url");
      await launch(appleUrl);
    } else {
      debugPrint("Could not launch url");
    }
  }
}

class NaviOther extends INavi {
  @override
  void openMap(LatLng latLng) async {
    Position origin = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            "https://www.google.com/maps/dir/?api=1&travelmode=walking&dir_action=navigate&origin=${origin.latitude},${origin.longitude}&destination=${latLng.latitude},${latLng.longitude}"),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }
}
