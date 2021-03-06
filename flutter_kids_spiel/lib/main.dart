import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kids_spiel/share_app_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'about_button.dart';
import 'map.dart';
import 'weather_chip.dart';

void main() => runApp(App());

typedef LoadingGroundsCallback = Function(bool isDone);

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final permissionHandler = PermissionHandler();
  final permissionGroup = PermissionGroup.location;

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
    _fabColor = _getPermissionColor();
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Kids playground search',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Material(
          child: Stack(
            children: <Widget>[
              Scaffold(
                  body: _map,
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () async {
                      _loadingCompleted(false);
                      await _requestPermission(true, permissionGroup);
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
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AboutButton(),
                    ShareAppButton(),
                  ],
                ),
              ),
              WeatherChip()
            ],
          ),
        ));
  }

  void _updateFAB() {
    setState(() {
      if (!_isLoadingCompleted) {
        _fabLabel = Text(
          "ping...",
          style: TextStyle(fontStyle: FontStyle.italic),
        );
        _fabIcon = Container(
          margin: EdgeInsets.only(right: 5),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          ),
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

  void _initPermissionHandler() {
    permissionHandler
        .checkPermissionStatus(permissionGroup)
        .then((PermissionStatus status) {
      setState(() {
        _permissionStatus = status;
        _fabColor = _getPermissionColor();

        _syncMapCamera();
      });
    });
    permissionHandler
        .shouldShowRequestPermissionRationale(permissionGroup)
        .then((isShown) {
      if (!isShown) _requestPermission(false, permissionGroup);
    });
  }

  get _hasPermissions => _permissionStatus == PermissionStatus.granted;

  get _noPermissions => _permissionStatus != PermissionStatus.granted;

  void _loadingCompleted(bool completed) {
    if (_hasPermissions)
      setState(() {
        _isLoadingCompleted = completed;
        _updateFAB();
      });
  }

  Future _moveMapCamera() async {
    if (_hasPermissions) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _map.center = position;
    }
  }

  void _syncMapCamera() {
    if (_hasPermissions) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        _map.center = position;
      });
    }
  }

  Color _getPermissionColor() {
    if (_hasPermissions) return Colors.pinkAccent;
    return Colors.grey;
  }

  Future<void> _requestPermission(
      bool showRationale, PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await permissionHandler.requestPermissions(permissions);

    setState(() {
      _permissionStatus = permissionRequestResult[permission];
      _fabColor = _getPermissionColor();
    });

    bool hasService = await _checkServiceStatus(permission);

    if (hasService && showRationale && _noPermissions) {
      _askOpenAppSettings();
    }

    _syncMapCamera();
  }

  Future<bool> _checkServiceStatus(PermissionGroup permission) async {
    final status = await permissionHandler.checkServiceStatus(permission);
    if (status == ServiceStatus.disabled) {
      _askOpenLocationSettings();
      return false;
    } else
      return true;
  }

  void _askOpenAppSettings() {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            title: Text("Info"),
            content: Text(
                "App needs location permission, please turn on it, otherwise you cannot get current location."),
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await AppSettings.openAppSettings();
                },
                child: Text("App Settings"),
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

  void _askOpenLocationSettings() {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            title: Text("Info"),
            content: Text(
                "The system location service hasn't been turned on, please turn it on."),
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await AppSettings.openLocationSettings();
                },
                child: Text("Location Settings"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Not yet"),
              ),
            ],
          );
        });
  }
}
