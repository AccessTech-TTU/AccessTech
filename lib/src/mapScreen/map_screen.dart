import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;

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

  //Wheelchair icon for ramps
  BitmapDescriptor wheelchairIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    addCustomIcon();
    super.initState();
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

  //getting user location
  /*
  LocationData? currentLocation;
  void getCurrentLocation(){
    Location location = Location();

    location.getLocation().then((location){

    },);    
  }
  */
  //end getting user location

//Getting the markers from assets/locations.json, Converted to an object by lib/src/locations.dart, lib/src/locations.g.dart
//TODO update the information we need from the markers

  final Map<String, Marker> _markers = {};
  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;
  Completer<GoogleMapController> _controller = Completer();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //Gets the markers
    _controller.complete(controller);
    final googleMarkers = await locations.getGoogleMarkers();
    setState(() {
      _markers.clear();
      for (final mark in googleMarkers.markers) {
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
    });
  }
//End of getting the markers

  //This function centers the camera around a marker.
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

/*
  //This function centers a camera around a route
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
          northeast: LatLng(ne lat, ne lng),
          southwest: LatLng(se lat, sw lng),
        ),
      25),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }
*/
  bool isDrawerOpen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //Start of UI
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Map screen
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: const Text('AccessTech BETA'),
      //   elevation: 2,
      // ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
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
            markers: _markers.values.toSet(),
          ),
          Positioned(
            top: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.small(
                onPressed: () async {
                  /*
                  var directions = await LocationService()
                      .getDirections("Holden Hall", "Physics");
                  _goToPlace(start_location, end_location, northeast bound, southwest bound);
                  _setPolyline(directions polyline decoded);
                */
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
