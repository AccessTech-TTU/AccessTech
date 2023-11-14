import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*
  This file takes in a string for the TextFormField(basically a searchbar) in the DraggableBottomSheet.dart file.
  It sends that string to the google maps places api.
  It gets a response and extracts the place id .
*/
class LocationService {
  final String key = "AIzaSyDL6tLCdvSU3udcWF7DiYkM8f5AGhl3H_s";


  /*
This code is just copied and pasted from this tutorial
https://www.youtube.com/watch?v=tfFByL7F-00



  */
  /*
  TODO
  Change this method so that it takes in the name of the place as a parameter,
   then uses a Map<string, coords> to convert from the name to its respective coordinates
   then returns the co ordinates so that they can be used in the get directions function
  */
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;
    //print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  /*
  TODO
    Change getDirections so that it takes two co-ordinates as input. It then uses the dijkstra algorithm in Mapdata/adjacencyList.dart
    to get a sequence of coordinates.
      final result = graph.dijkstraPath('(33.5861073, -101.87357)', '(33.5870844, -101.8749556)');
      print('Shortest distances: ${result['distances']}');
      print('Shortest path: ${result['shortestPath']}');
    It then returns these co-ordinates in the results dictionary
    With bounds_ne being the most north east coordinate (to zoom the camera in around the bounds)
      Need a function that calculates the most north east coordinate out of a set of coordinates
    With bounds_sw being the most south west coordinate
      Need a function that calculates the most south west coordinate out of a set of coordinates
              For the above functions might be easier to find
                most northern point of all coordinates(highest latitude)
                most southern point of all coordinates(lowest latitude)
                most eastern(highest longitude)   Maybe switch these two
                mosts western(lowest longitude)
                and return bounds_ne = (highest lat, highest long)
                bounds_se = (lowest lat, lowest long)
    start_location just being the origin coordinate
    end_location being the destination coordinate
    polyline being the path as a sequence of coordinates(more specifically will probably be a sequence of LatLng objects)
  */
/*
  Future<Map<String, dynamic>> getDirections(
    String origin, String destination) async {
    getPath(origin, destination);
    var results = {
      'bounds_ne': ,//used to zoom in
      'bounds_sw': ,
      'start_location': ,
      'end_location': ,
      'polyline': ,
    }
  }*/
}
