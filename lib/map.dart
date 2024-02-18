import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key, required this.circleRadius}) : super(key: key);

  final double circleRadius;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  double _currentCircleRadius = 0.0;

  List<Map<String, dynamic>> userLocations = [
    {
      "username": "blabla",
      "location": LatLng(39.42796133580664, -122.085749655962),
      "address": "adreda ide tu"
    },
    {
      "username": "blabladva",
      "location": LatLng(37.42796133580664, -122.085749655962),
      "address": "adreda ide tu"
    },
  ];

  List<BitmapDescriptor> pinIcons = [
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
  ];

  @override
  void initState() {
    super.initState();
    _currentCircleRadius = widget.circleRadius;
  }

  @override
  Widget build(BuildContext context) {
    LatLng player0Location = userLocations.isNotEmpty
        ? userLocations[0]['location']
        : LatLng(0, 0); // Default to (0, 0) if userLocations is empty

    Set<Marker> markers = {};
    for (var i = 0; i < userLocations.length; i++) {
      var location = userLocations[i];
      var pinIcon = pinIcons[i % pinIcons.length];
      markers.add(
        Marker(
          markerId: MarkerId(location["username"]),
          position: location["location"],
          infoWindow: InfoWindow(title: location["username"]),
          icon: pinIcon,
        ),
      );
    }
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: player0Location, // camera position to player0's location
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        circles: <Circle>{
          Circle(
            circleId: const CircleId("player0_circle"),
            center:
                player0Location, // Set center of the circle to player0's location
            radius: _currentCircleRadius * 1000,
            fillColor: Colors.red.withOpacity(0.3),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
        },
      ),
    );
  }

  void updateCircleRadius(double newRadius) {
    setState(() {
      _currentCircleRadius = newRadius;
    });
  }
}
