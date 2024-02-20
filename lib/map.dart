import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_application_1/toast.dart';

class MapSample extends StatefulWidget {

  const MapSample(
      {super.key,
      required this.username,
      required this.ip,
      required this.seeker,
      required this.radius,
      required this.timeInterval});

  final String username;
  final String ip;
  final bool seeker;
  final double radius;
  final int timeInterval;


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

  LatLng _circlePosition = const LatLng(0, 0);

  List<Map<String, dynamic>> userLocations = [];

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
    _currentCircleRadius = widget.radius;
    if (userLocations.isNotEmpty) {
      _circlePosition = userLocations[0]['location'];
    }
    //updating locations
    Timer.periodic(Duration(minutes: widget.timeInterval), (Timer timer) async{
      // call function to update user locations
      var url = Uri.http("${widget.ip}:8000", "locations");
      
      Map body = {
        "username": widget.username,
        "location": "${currentLocation!.latitude!} ${currentLocation!.longitude!}",
        //mozda dodam address ak mi se bude dalo :/
        "address": ""
      };

      http.Response? response;
      try{
        response = await http.post(url, body: body);
      } catch (err){
        toast("Server nije pronađen");
      }
      
      if(response != null && response.statusCode == 400){
         toast("Nije moguće poslati lokaciju");
      }
      
      // jos treba dohvatit ostale lokacije
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


  void updateCircleRadius(double newRadius) {
    setState(() {
      _currentCircleRadius = newRadius;
    });
  }
}
