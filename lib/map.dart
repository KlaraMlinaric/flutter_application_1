import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:http/http.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample(
      {super.key,
      required this.ip,
      required this.seeker,
      this.radius,
      this.timeInterval});

  final String ip;
  final bool seeker;
  final double? radius;
  final int? timeInterval;

  @override
  State<MapSample> createState() => MapSampleState();
}




// STATE!!!
class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const double defaultZoom = 15.0;


  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: defaultZoom,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }




  // BUILD !!!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
        ? const Center(child: Text("Loading"))
        : GoogleMap(
        mapType: MapType.normal, //hybrid
        initialCameraPosition: CameraPosition(
            bearing: 0.0,
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            tilt: 0.0,
            zoom: defaultZoom
            ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: const MarkerId("MyMarker"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
          )
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => goToLoc(LatLng(currentLocation!.latitude!, currentLocation!.longitude!)),
        label: const Text('My Location'),
        icon: const Icon(Icons.gps_fixed),
      ),
    );
  }

  Future<void> goToLoc(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 0.0, target: pos, tilt: 0.0, zoom: defaultZoom)));
  }
}
