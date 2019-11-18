import 'dart:io';

import 'package:flutter/material.dart';

typedef InternetAddressLookup = Future<List<InternetAddress>> Function();

class HNSplashBloc extends ChangeNotifier {
  final InternetAddressLookup _internetAddressLookup;

  HNSplashBloc(this._internetAddressLookup);

  Future<bool> pingInternet() async {
    try {
      final List<InternetAddress> result = await _internetAddressLookup();
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } catch (_) {
      return false;
    }
  }
}
