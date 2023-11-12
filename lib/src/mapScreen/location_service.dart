import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*
  This file takes in a string for the TextFormField(basically a searchbar) in the DraggableBottomSheet.dart file.
  It sends that string to the google maps places api.
  It gets a response and extracts the place id .
*/
class LocationService {
  final String key = "AIzaSyDL6tLCdvSU3udcWF7DiYkM8f5AGhl3H_s";

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

  Future<Map<String, dynamic>> getDirections(
    String origin, String destination) async {
    getPath(origin, destination);
    var results = {
      'bounds_ne': ,//used to zoom in
      'bounds_se': ,
      'start_location': ,
      'end_location': ,
      'polyline': ,
    }
  }
}
