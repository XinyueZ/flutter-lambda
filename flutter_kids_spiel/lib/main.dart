import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final map = MapView();
  Color _fabColor;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location)
        .then((PermissionStatus status) {
      setState(() {
        _permissionStatus = status;
        _fabColor = _getPermissionColor();

        _syncMapCamera();
      });
    });
    PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.location)
        .then((isShown) {
      if (!isShown) _requestPermission(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Kids playground search',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
          body: map,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: FloatingActionButton(
              onPressed: () async {
                await _requestPermission(true);
                await _moveMapCamera();
              },
              child: Icon(Icons.my_location),
              backgroundColor: _fabColor,
            ),
          )),
    );
  }

  Future _moveMapCamera() async {
    if (_permissionStatus == PermissionStatus.granted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      map.animateCamera(position);
    }
  }

  void _syncMapCamera() {
    if (_permissionStatus == PermissionStatus.granted) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        map.animateCamera(position);
      });
    }
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> _requestPermission(bool showRationale,
      {PermissionGroup permission = PermissionGroup.location}) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    if (showRationale && _permissionStatus != PermissionStatus.granted) {
      _showPermissionRationale();
    }

    setState(() {
      _permissionStatus = permissionRequestResult[permission];
      _fabColor = _getPermissionColor();
    });
  }

  void _showPermissionRationale() {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text(
                "App needs location permission, please turn on it, otherwise you cannot get current location."),
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await PermissionHandler().openAppSettings();
                },
                child: Text("Open App-Settings"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        });
  }
}
