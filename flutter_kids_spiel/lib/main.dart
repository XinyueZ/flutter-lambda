import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
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
      });
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
          body: MapSample(),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: FloatingActionButton(
              onPressed: () {
                requestPermission(PermissionGroup.location);
              },
              child: Icon(Icons.my_location),
              backgroundColor: _fabColor,
            ),
          )),
    );
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    bool isShown = await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.location);

    setState(() {
      _permissionStatus = permissionRequestResult[permission];
      _fabColor = _getPermissionColor();

      if (!isShown && _permissionStatus == PermissionStatus.denied) {
        _showPermissionRationale();
      }
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
                child: Text("OK"),
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
