import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;
import 'bottom_navigation_bar.dart';
import 'building_screen.dart';
import 'contact_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Making a wheelchair icon
  //TODO Make wheelchair icon work
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
  } //End of making a wheelchair icon

//Getting the markers from assets/locations.json, Converted to an object by lib/src/locations.dart, lib/src/locations.g.dart
//TODO update the information we need from the markers
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //Gets the markers
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          //icon: wheelchairIcon,
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }
//End of getting the markers

//Making a list view / grid view for viewing the building information

//End of list view

  //Start of UI
  @override
  Widget build(BuildContext context) {
    // Map screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('AccessTech BETA'),
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target:
          LatLng(33.58479, -101.87466), //TODO initial position of the map
          zoom: 15,
        ),
        markers: _markers.values.toSet(),
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