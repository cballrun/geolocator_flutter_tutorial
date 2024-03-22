import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoLocation Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GeoLocationTutorial(),
    );
  }
}

class GeoLocationTutorial extends StatefulWidget {
  const GeoLocationTutorial({Key? key}) : super(key: key);

  @override
  State<GeoLocationTutorial> createState() => _GeoLocationTutorialState();
}

class _GeoLocationTutorialState extends State<GeoLocationTutorial> {
  _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  _showMaterialBanner(String message, Color color) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        backgroundColor: color,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _checkLocationService() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _showSnackBar('Location services are disabled.', Colors.red);
      return false;
    }
    _showSnackBar('Location services are enabled.', Colors.green);
    return true;
  }

  _getCurrentLocation() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled.', Colors.red);
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied', Colors.red);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.',
          Colors.red);
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(position.toString());
    _showMaterialBanner(position.toString(), Colors.green);
  }

  _getLastLocation() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled.', Colors.red);
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied', Colors.red);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.',
          Colors.red);
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position? position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      _showSnackBar('No location data available.', Colors.red);
      return;
    }
    log(position.toString());
    _showMaterialBanner(position.toString(), Colors.green);
  }

  _getLocationUpdates() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled.', Colors.red);
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied', Colors.red);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.',
          Colors.red);
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      log(position.toString());
      _showMaterialBanner(position.toString(), Colors.green);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoLocation Tutorial allaboutflutter.com'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                _checkLocationService();
              },
              child: const Text('Check Location Service'),
            ),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Get Current Location'),
            ),
            ElevatedButton(
              onPressed: _getLastLocation,
              child: const Text('Get Last Location'),
            ),
            ElevatedButton(
              onPressed: _getLocationUpdates,
              child: const Text('Get Location Updates'),
            ),
          ],
        ),
      ),
    );
  }
}
