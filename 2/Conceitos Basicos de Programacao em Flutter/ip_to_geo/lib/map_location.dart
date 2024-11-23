import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation extends StatelessWidget {
  MapLocation({super.key});
  // 1 
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    // 2
    Map<String, double?> location =
        ModalRoute.of(context)!.settings.arguments as Map<String, double?>;
    // 3
    CameraPosition poi = CameraPosition(
      target: LatLng(location["lat"] ?? 0, location["lon"] ?? 0),
      zoom: 14.4746,
    );
    return Scaffold(
      // 4
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: poi,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
