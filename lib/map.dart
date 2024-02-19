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

  double _currentCircleRadius = 0.0;

  LatLng _circlePosition = LatLng(0, 0);

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
    _currentCircleRadius = widget.radius ?? 10.0;
    if (userLocations.isNotEmpty) {
      _circlePosition = userLocations[0]['location'];
    }
    //updating locations
    Timer.periodic(Duration(minutes: 1), (Timer timer) {
      // call function to update user locations
      updateFirstUserLocation(); // demo x
    });
  }



  // BUILD !!!
  @override
  Widget build(BuildContext context) {
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
          target: _circlePosition, // camera position to the circle's position
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
                _circlePosition, // center of the circle to the circle's position(player0 start position)
            radius: _currentCircleRadius * 1000,
            fillColor: Colors.red.withOpacity(0.3),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
        },
      ),
    );
  }

  void updateFirstUserLocation() {
    setState(() {
      // update first user's location
      userLocations[0]['location'] = LatLng(40.0, -120.0); // New coordinates x
    });
  }

  void updateCircleRadius(double newRadius) {
    setState(() {
      _currentCircleRadius = newRadius;
    });
  }
}
