import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map.dart';

void main() => runApp(App());

typedef LoadingGroundsCallback = Function(bool isDone);

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final navigatorKey = GlobalKey<NavigatorState>();

  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  bool _isLoadingCompleted = true;

  Color _fabColor;
  Widget _fabIcon = Icon(Icons.my_location);
  Widget _fabLabel = Container(height: 0.0, width: 0.0);

  MapView _map = MapView();

  @override
  void initState() {
    loadingGroundsCallback = (isDone) {
      _loadingCompleted(isDone);
    };
    _initPermissionHandler();
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
          body: _map,
          floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  _loadingCompleted(false);
                  await _requestPermission(true);
                  await _moveMapCamera();
                },
                isExtended: !_isLoadingCompleted,
                label: _fabLabel,
                icon: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: _fabIcon),
                backgroundColor: _fabColor,
              ))),
    );
  }

  void _initPermissionHandler() {
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
  }

  void _updateFAB() {
    setState(() {
      if (!_isLoadingCompleted) {
        _fabLabel = Text(
          "ping...",
          style: TextStyle(fontStyle: FontStyle.italic),
        );
        _fabIcon = CircularProgressIndicator(
          backgroundColor: Colors.white,
        );
      } else {
        _fabLabel = Container(
          width: 0,
          height: 0,
        );
        _fabIcon = Icon(Icons.my_location);
      }
    });
  }

  void _loadingCompleted(bool completed) {
    setState(() {
      _isLoadingCompleted = completed;
      _updateFAB();
    });
  }

  Future _moveMapCamera() async {
    if (_permissionStatus == PermissionStatus.granted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _map.center = position;
    }
  }

  void _syncMapCamera() {
    if (_permissionStatus == PermissionStatus.granted) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        _map.center = position;
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

    setState(() {
      _permissionStatus = permissionRequestResult[permission];
      _fabColor = _getPermissionColor();
    });

    if (showRationale && _permissionStatus != PermissionStatus.granted) {
      _showPermissionRationale();
    }

    _syncMapCamera();
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
