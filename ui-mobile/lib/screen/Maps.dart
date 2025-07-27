import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      home: Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(23.0225, 72.5714),
            zoom: 12,
          ),
        ),
      ),
    );
  }
}