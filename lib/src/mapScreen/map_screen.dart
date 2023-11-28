import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;
import 'location_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as accuracy;
/*
Authors:
  Houston Taylor, Travis Libre
Description:
  This file is the map screen. It contains the Google Map widget, and a getter
  for the markers.
*/

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  // Keep screen alive between screen switches
  @override
  bool get wantKeepAlive => true; // Screen will stay loaded forever
  late LatLng _currentLoc;
  bool _isLoading = true;

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy.LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentLoc = location;
      _isLoading = false;
    });
  }

  //Wheelchair icon for ramps
  BitmapDescriptor wheelchairIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    addCustomIcon();
    //getCurrentLocation();
    super.initState();
    getLocation();
    //getCurrentLocation();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/wheelchair_marker.png")
        .then(
      (icon) {
        setState(() {
          wheelchairIcon = icon;
        });
      },
    );
  }
  //End wheelchair icon for ramps





//Entrance icon for entrances(Doesnt work)
BitmapDescriptor entranceIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState2() {
    //getCurrentLocation();
    addCustomIcon2();
    super.initState();
    getLocation();
    //getCurrentLocation();
  }

  void addCustomIcon2() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/entranceIcon.png")
        .then(
      (icon) {
        setState(() {
          entranceIcon = icon;
        });
      },
    );
  }
  //End entrance icon for entrances
  //TODO make a entrance icon

//Getting the markers from assets/locations.json, Converted to an object by lib/src/locations.dart, lib/src/locations.g.dart
//TODO create a Map for mapping marker names to their coordinates
  final Map<String, Marker> _markers = {};//This holds all of the markers
  final Map<String, Marker> _entranceMarkers = {};//THis holds the entrance markers
  final Map<String, Marker> _rampMarkers = {};//THis holds the ramp markers
  final Map<String, dynamic> _convertToCoords = {};//THis converts from the name of a place to a string representation of its coordinates ("(234.45435, 343333.3535)")
  


  /*
    Converts a LatLng Representation of coords to a string representation of coords.
  */
  String convertLatLngToString(LatLng coords){
    return "(" + coords.latitude.toString() + ", " + coords.longitude.toString() + ")";
  }


  Set<Polyline> _polylines = Set<Polyline>();//THis set holds the route to be drawn
  int _polylineIdCounter = 1;
  Completer<GoogleMapController> _controller = Completer();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //Gets the markers
    _controller.complete(controller);
    final googleMarkers = await locations.getGoogleMarkers();
    setState(() {
      for (final mark in googleMarkers.markers) {
        String lowercaseId = mark.id.toLowerCase();
        if(lowercaseId.contains("entrance")){//If marker is an entrance
        final marker = Marker(
          markerId: MarkerId(mark.id),
          position: LatLng(mark.lat, mark.lng),
          icon:
              entranceIcon, //TODO different icons for different marker types
          infoWindow: InfoWindow(
            title: mark.id,
            snippet: mark.description,
          ),
        );
        _entranceMarkers[mark.id] = marker;//Seperate map of markers for entrances
        _markers[mark.id] = marker;
        //_convertToCoords[mark.id] = "(" + mark.lat.toString() + ", " + mark.lng.toString() + ")";//Mapping the name to the coordinates
        _convertToCoords[mark.id] = LatLng(mark.lat, mark.lng);
        print(convertLatLngToString(_convertToCoords[mark.id]));

        }
        else if(lowercaseId.contains("ramp")){//If marker is a ramp
        final marker = Marker(
          markerId: MarkerId(mark.id),
          position: LatLng(mark.lat, mark.lng),
          icon:
              wheelchairIcon, //TODO different icons for different marker types
          infoWindow: InfoWindow(
            title: mark.id,
            snippet: mark.description,
          ),
        );
        _rampMarkers[mark.id] = marker;//Seperate map of markers for ramps 
        _markers[mark.id] = marker;

        }
        else{//ANy other type of marker
        final marker = Marker(
          markerId: MarkerId(mark.id),
          position: LatLng(mark.lat, mark.lng),
          icon:
            
              wheelchairIcon, //TODO different icons for different marker types
          infoWindow: InfoWindow(
            title: mark.id,
            snippet: mark.description,
          ),
        );
        _markers[mark.id] = marker;

        }
        getLocation();
    }});
    print(_convertToCoords);
  }
//End of getting the markers

  //This function centers the camera around a marker. It is not used yet. If you used it you would need to change it.
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 16),
    ));
  }


/*
  This function centers a camera around a route
*/
  Future<void> _goToPlaceRoute(double lat, double lng, Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
        ),
      25),
    );
  }
  Set<Marker> initializeMarkers(){
    final set = _markers.values.toSet();
    var markerLocal = Marker(
      markerId: MarkerId("Current Location"),
      position: _currentLoc,
      icon: entranceIcon,
      infoWindow: InfoWindow(
          title: "Current Location"
      ),
    );
    _markers["Current Location"] = markerLocal;
    set.add(markerLocal);
    return set;
  }

  /*
    This function updates _polyline so that it can be drawn on the map.
  */
  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    setState((){
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 4,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
    });
  }

  bool isDrawerOpen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //Start of UI
  @override
  Widget build(BuildContext context) {
    super.build(context);
    getLocation();
    //getCurrentLocation();
    // Map screen
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: const Text('AccessTech BETA'),
      //   elevation: 2,
      // ),
      body: _isLoading? Center(child:CircularProgressIndicator()) :
      Stack(
        children: [
          GoogleMap(

            onMapCreated: _onMapCreated,
            /*
            (GoogleMapController controller){
              _controller.complete(controller);
            },
            */
            mapType: MapType.hybrid,
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                //setting the bounds for the map. TODO change southwest and northeast coords
                southwest: const LatLng(33.5796412, -101.8814612),
                northeast: const LatLng(33.5897768, -101.8706036))),
            compassEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(
              14, //Minzoom
              null, //Maxzoom null means unbounded
            ),
            myLocationButtonEnabled: true,
            polylines:
                _polylines, //TODO polylines function that takes in two args: start location, end location and returns polylines
            trafficEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                  33.58479, -101.87466), //TODO initial position of the map
              zoom: 15,
            ),
            markers: initializeMarkers(),
          ),
          Positioned(
            top: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.small(
                onPressed: () async {
                  /*
                    The following code needs to be changed so that it is called by the search bar.

                    First it gets the LatLng representation of the a location.
                    Then it converts it from LatLng to String.
                    Then it calls getDirections which returns the polyline route and other route info
                    _goToPlaceRoute centers the camera around the route
                    _setPolyline draws the route on the map
                  */
                  print("\n\n\n one \n\n\n\n");
                  LatLng o = _convertToCoords["Livermore North Entrance"];
                  print(o);
                  String origin = "(" + o.latitude.toString() + ", " + o.longitude.toString() + ")";
                  LatLng d = _convertToCoords["Holden Hall Entrance"];
                  print(d);
                  String destination = "(" + d.latitude.toString() + ", " + d.longitude.toString() + ")";
                  var directions = await LocationService()
                      .getDirections("(33.58798, -101.87573)", destination);
                  print("\n\n\n\n\ntest\n\n\n\n");
                  print(directions);
                  _goToPlaceRoute(directions['start_location']['lat'], directions['start_location']['lng'], directions['bounds_ne'], directions['bounds_sw']);
                  _setPolyline(directions['polyline_decoded']);
                
                
                }, //TODO change button
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                elevation: 10,
              ),
            ),
          ),
          Positioned(
            top: 60,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.small(
                onPressed: () => scaffoldKey.currentState!.openDrawer(),
                child: Icon(
                  Icons.filter_vintage,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 204, 0, 0)),
              child: Text(
                "Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Drawer Item 1'),
              // Add your drawer items here
            ),
            ListTile(
              title: Text('Drawer Item 2'),
              // Add more drawer items
            ),
          ],
        ),
      ),
    );
  }
//End of MapScreenUI
}



/* Previous MapScreenUI Code // TODO Reimplement Theme Data
return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 182, 8,
            8), //TODO change color to accessible not color blind color
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AccessTech BETA'),
          elevation: 2,
        ),
 */
