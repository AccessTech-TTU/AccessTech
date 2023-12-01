import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math';
import 'dart:core';

/*
This file finds path between two places and returns a polyline
*/
class LocationService {
  final String key = "AIzaSyDL6tLCdvSU3udcWF7DiYkM8f5AGhl3H_s";

  /*
This code is just copied and pasted from this tutorial
https://www.youtube.com/watch?v=tfFByL7F-00



  */
  /*

  THIS FUNCTION IS NOT USED 
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

  /*

  THIS FUNCTION IS NOT USED
  */
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
    PsuedoCode Plan: 
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
    This function takes in a a String version of the coordinates and returns a list where the 0th element is the lat and 1st element is lng
  */
  List<double> convertCoords(String coord) {
    //print("print cords" + coord);
    String removeParen =
        coord.substring(1, coord.length - 1); //Removing start and end paren
    List<String> coords = removeParen.split(", "); //split by the comma
    double lat = double.parse(coords[0]);
    double lng = double.parse(coords[1]);
    List<double> temp = [lat, lng];
    return temp;
  }

  /*
    This function takes the path and finds the most North east point in the path. Need this point to center the camera around the route
  */
  Map<String, dynamic> getBoundsNe(List<String> path) {
    print(path);
    double mostNorth = -100000;
    double mostEast = -100000;
    for (int i = 0; i < path.length; i++) {
      List<double> coords = convertCoords(path[i]);
      double lat = coords[0];
      double lng = coords[1];
      mostNorth = mostNorth > lat ? mostNorth : lat;
      mostEast = mostEast > lng ? mostEast : lng; //TODO  > to <
    }
    return {'lat': mostNorth, 'lng': mostEast};
  }

  /*
    This function takes the path and finds the most south west point in the path. Need this point to center the camera around the route
  */
  Map<String, dynamic> getBoundsSw(List<String> path) {
    double mostSouth = 100000;
    double mostWest = 100000;
    for (int i = 0; i < path.length; i++) {
      List<double> coords = convertCoords(path[i]);
      double lat = coords[0];
      double lng = coords[1];
      mostSouth = mostSouth < lat ? mostSouth : lat;
      mostWest = mostWest < lng ? mostWest : lng; //TODO switch > to <
    }
    return {'lat': mostSouth, 'lng': mostWest};
  }

  /*
    Converts the path from a sequence of String ("(2432.3, 485388.2)") to a sequence of PointLatLng objects.
  */
  List<PointLatLng> convertPath(List<String> path) {
    List<PointLatLng> converted = [];
    for (int i = 0; i < path.length; i++) {
      List<double> coords = convertCoords(path[i]);
      converted.add(PointLatLng(coords[0], coords[1]));
    }
    return converted;
  }

  /*
    This method takes in the string representation of coordinates, finds the path and returns a results variable that contains:
      the most norht east point
      the most south west point
      the starting point
      the ending point
      the polyline(not used)
      the polyline decoded(used)
  */
  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    List<String> path = getPath(origin, destination);
    path.remove("");
    print("updated path");
    print(path);
    List<double> convertOrigin = convertCoords(origin);
    List<double> convertDestination = convertCoords(destination);

    var results = {
      'bounds_ne': getBoundsNe(path), //used to zoom in
      'bounds_sw': getBoundsSw(path), //lat lng
      'start_location': {
        "lat": convertOrigin[0],
        "lng": convertOrigin[1]
      }, //{lat: , lng: }
      'end_location': {
        "lat": convertDestination[0],
        "lng": convertDestination[1]
      }, //lat lng
      'polyline': path,
      'polyline_decoded': convertPath(path)
    };
    return results;
  }
}

/*
The rest of this file is auto generated by running KMLTOAdjacencyMatrix.py
It contains the graph, path finding alogo.
*/
class Edge {
  final String vertex1;
  final String vertex2;
  final double weight;

  Edge(this.vertex1, this.vertex2, this.weight);
}

class UndirectedWeightedGraph {
  final Map<String, List<Edge>> _adjacencyList = {};
  //final List<String> vertexes = List.empty(growable: true);

  void addVertex(String vertex) {
    if (!_adjacencyList.containsKey(vertex)) {
      _adjacencyList[vertex] = [];
      //vertexes.add(vertex);
    }
  }

  void addEdge(String vertex1, String vertex2, double weight) {
    addVertex(vertex1);
    addVertex(vertex2);

    final edge = Edge(vertex1, vertex2, weight);
    _adjacencyList[vertex1]?.add(edge);
    _adjacencyList[vertex2]
        ?.add(edge); // Undirected graph, so we add the edge for both vertices
  }

  void bfs(String startVertex) {
    final visited = <String>{};
    final queue = <String>[];

    visited.add(startVertex);
    queue.add(startVertex);

    while (queue.isNotEmpty) {
      final currentVertex = queue.removeAt(0);
      print(currentVertex);

      for (final edge in _adjacencyList[currentVertex]!) {
        final neighbor =
            edge.vertex1 == currentVertex ? edge.vertex2 : edge.vertex1;
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add(neighbor);
        }
      }
    }
  }

  Map<String, double> dijkstra(String startVertex) {
    final distances = <String, double>{};
    final priorityQueue = <String, double>{};
    final previous = <String, String>{};

    for (final vertex in _adjacencyList.keys) {
      distances[vertex] = double.infinity;
      previous[vertex] = "";
    }

    distances[startVertex] = 0;
    priorityQueue[startVertex] = 0;

    while (priorityQueue.isNotEmpty) {
      final currentVertex = priorityQueue.keys
          .reduce((a, b) => priorityQueue[a]! < priorityQueue[b]! ? a : b);
      priorityQueue.remove(currentVertex);

      for (final edge in _adjacencyList[currentVertex]!) {
        final neighbor =
            edge.vertex1 == currentVertex ? edge.vertex2 : edge.vertex1;
        final totalWeight = distances[currentVertex]! + edge.weight;

        if (totalWeight < distances[neighbor]!) {
          distances[neighbor] = totalWeight;
          previous[neighbor] = currentVertex;
          priorityQueue[neighbor] = totalWeight;
        }
      }
    }

    return distances;
  }

  Map<String, dynamic> dijkstraPath(String startVertex, String? endVertex) {
    final distances = <String, double>{};
    final priorityQueue = <String, double>{};
    final previous = <String, String>{};

    for (final vertex in _adjacencyList.keys) {
      distances[vertex] = double.infinity;
      previous[vertex] = "";
    }

    distances[startVertex] = 0;
    priorityQueue[startVertex] = 0;

    while (priorityQueue.isNotEmpty) {
      final currentVertex = priorityQueue.keys
          .reduce((a, b) => priorityQueue[a]! < priorityQueue[b]! ? a : b);
      priorityQueue.remove(currentVertex);

      for (final edge in _adjacencyList[currentVertex]!) {
        final neighbor =
            edge.vertex1 == currentVertex ? edge.vertex2 : edge.vertex1;
        final totalWeight = distances[currentVertex]! + edge.weight;

        if (totalWeight < distances[neighbor]!) {
          distances[neighbor] = totalWeight;
          previous[neighbor] = currentVertex;
          priorityQueue[neighbor] = totalWeight;
        }
      }
    }

    // Build the sequence of nodes in the shortest path
    final path = <String>[];
    var current = endVertex;
    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }

    return {'distances': distances, 'shortestPath': path};
  }

  void printGraph() {
    _adjacencyList.forEach((vertex, edges) {
      print(
          '$vertex -> ${edges.map((e) => '${e.vertex1}-${e.vertex2}:${e.weight}').join(', ')}');
    });
  }

  List<double> convertCoords(String coord) {
    //print("print cords" + coord);
    String removeParen =
        coord.substring(1, coord.length - 1); //Removing start and end paren
    List<String> coords = removeParen.split(", "); //split by the comma
    double lat = double.parse(coords[0]);
    double lng = double.parse(coords[1]);
    List<double> temp = [lat, lng];
    return temp;
  }

  double getDistance(String coords1, String coords2) {
    List<double> convertedOne = convertCoords(coords1);
    List<double> convertedTwo = convertCoords(coords2);
    double dif1 = (convertedOne[0] - convertedTwo[0]);
    dif1 = dif1 * dif1;
    double dif2 = (convertedOne[1] - convertedTwo[1]);
    dif2 = dif2 * dif2;
    return dif1 + dif2;
  }

  String findClosestVertex(String coords) {
    String closest = coords;
    double min = 10000000000;
    Iterable<String> vertexes = _adjacencyList.keys;
    for (int i = 0; i < vertexes.length; i++) {
      double currentDistance = getDistance(coords, vertexes.elementAt(i));
      print(i);
      if (currentDistance < min) {
        min = currentDistance;
        closest = vertexes.elementAt(i);
      }
    }
    return closest;
  }
}

List<String> getPath(String origin, String destination) {
  final graph = UndirectedWeightedGraph();
  graph.addEdge("(33.5844713, -101.8746846)", "(33.584315, -101.8746843)",
      18.95890368132894);
  graph.addEdge("(33.584315, -101.8746843)", "(33.5841113, -101.8746853)",
      24.708612819281033);
  graph.addEdge("(33.5841113, -101.8746853)", "(33.5838454, -101.8746817)",
      32.25520983643949);
  graph.addEdge("(33.5838454, -101.8746817)", "(33.5838037, -101.8746813)",
      5.0582896346960355);
  graph.addEdge("(33.5838037, -101.8746813)", "(33.5837264, -101.8746817)",
      9.376423285134093);
  graph.addEdge("(33.5837264, -101.8746817)", "(33.5835952, -101.8746826)",
      15.914559537677963);
  graph.addEdge("(33.5844713, -101.8746846)", "(33.5844042, -101.874517)",
      18.861634654588105);
  graph.addEdge("(33.5844042, -101.874517)", "(33.5843384, -101.8743527)",
      18.491374339016005);
  graph.addEdge("(33.5843384, -101.8743527)", "(33.5842006, -101.8740081)",
      38.77265574754055);
  graph.addEdge("(33.5842006, -101.8740081)", "(33.5841848, -101.8739639)",
      4.879441892525009);
  graph.addEdge("(33.5841848, -101.8739639)", "(33.5841481, -101.8738617)",
      11.290302470160315);
  graph.addEdge("(33.5851427, -101.8750749)", "(33.5850812, -101.8750393)",
      8.28922811797436);
  graph.addEdge("(33.5850812, -101.8750393)", "(33.5850321, -101.8750109)",
      6.6169262822927895);
  graph.addEdge("(33.5850321, -101.8750109)", "(33.584611, -101.874766)",
      56.80827432068469);
  graph.addEdge("(33.584611, -101.874766)", "(33.5844713, -101.8746846)",
      18.853030929303923);
  graph.addEdge("(33.5844713, -101.8746846)", "(33.5846104, -101.8746051)",
      18.703600104853585);
  graph.addEdge("(33.5846104, -101.8746051)", "(33.585033, -101.8743544)",
      57.231344948123265);
  graph.addEdge("(33.5844713, -101.8746846)", "(33.5845391, -101.8745174)",
      18.86186344443476);
  graph.addEdge("(33.5845391, -101.8745174)", "(33.5846053, -101.8743531)",
      18.512333644795078);
  graph.addEdge("(33.5846053, -101.8743531)", "(33.5847423, -101.8740131)",
      38.30946650508424);
  graph.addEdge("(33.5844713, -101.8746846)", "(33.5844024, -101.8748528)",
      19.011567037927207);
  graph.addEdge("(33.5844024, -101.8748528)", "(33.5841948, -101.87536)",
      57.31985383669354);
  graph.addEdge("(33.5841948, -101.87536)", "(33.5841872, -101.8753772)",
      1.9745947988602741);
  graph.addEdge("(33.5841872, -101.8753772)", "(33.5841893, -101.8754203)",
      4.383042897692969);
  graph.addEdge("(33.5841893, -101.8754203)", "(33.5841942, -101.8755203)",
      10.169667856323992);
  graph.addEdge("(33.5841942, -101.8755203)", "(33.5841965, -101.8755679)",
      4.840533598245792);
  graph.addEdge("(33.5848672, -101.8778696)", "(33.5849593, -101.8778722)",
      11.174665717714934);
  graph.addEdge("(33.5885371, -101.8791561)", "(33.5884856, -101.8791566)",
      6.247057981514114);
  graph.addEdge("(33.5884856, -101.8791566)", "(33.5884277, -101.8791572)",
      7.0234236229459786);
  graph.addEdge("(33.5884277, -101.8791572)", "(33.5884112, -101.8791348)",
      3.029316046070704);
  graph.addEdge("(33.5884112, -101.8791348)", "(33.5883955, -101.8791216)",
      2.3285963439968334);
  graph.addEdge("(33.5883955, -101.8791216)", "(33.5883597, -101.8791083)",
      4.547534397464135);
  graph.addEdge("(33.5883597, -101.8791083)", "(33.58831, -101.8790995)",
      6.094348408178943);
  graph.addEdge("(33.58831, -101.8790995)", "(33.5882502, -101.8790973)",
      7.257063169421169);
  graph.addEdge("(33.5882502, -101.8790973)", "(33.5882042, -101.8791017)",
      5.5975627506985735);
  graph.addEdge("(33.5882042, -101.8791017)", "(33.5881563, -101.8791138)",
      5.938607978572395);
  graph.addEdge("(33.5881563, -101.8791138)", "(33.5880827, -101.8791392)",
      9.292466982520432);
  graph.addEdge("(33.5847962, -101.8731217)", "(33.5847935, -101.8727293)",
      39.838633359370625);
  graph.addEdge("(33.5858704, -101.8762086)", "(33.5858034, -101.8760477)",
      18.244740560466465);
  graph.addEdge("(33.5866833, -101.8743475)", "(33.5865315, -101.8743409)",
      18.42523162862991);
  graph.addEdge("(33.5851222, -101.8732694)", "(33.5852271, -101.8732717)",
      12.726305316175278);
  graph.addEdge("(33.5852271, -101.8732717)", "(33.5854571, -101.8732769)",
      27.903541235471618);
  graph.addEdge("(33.5854571, -101.8732769)", "(33.5854577, -101.873175)",
      10.345282853118313);
  graph.addEdge("(33.585364, -101.8750245)", "(33.5854805, -101.875024)",
      14.131311878480314);
  graph.addEdge("(33.5854805, -101.875024)", "(33.5855714, -101.8750249)",
      11.026369846433278);
  graph.addEdge("(33.5855714, -101.8750249)", "(33.5858019, -101.8750262)",
      27.95950902397227);
  graph.addEdge("(33.5858019, -101.8750262)", "(33.586076, -101.8750278)",
      33.24819009117172);
  graph.addEdge("(33.586076, -101.8750278)", "(33.5860932, -101.8750278)",
      2.0863263723703245);
  graph.addEdge("(33.5855749, -101.8748304)", "(33.5855749, -101.8749397)",
      11.096269896070938);
  graph.addEdge("(33.5847935, -101.8727293)", "(33.5848225, -101.8726833)",
      5.846612202478632);
  graph.addEdge("(33.5848225, -101.8726833)", "(33.5848582, -101.8726434)",
      5.929608922472244);
  graph.addEdge("(33.5848582, -101.8726434)", "(33.5848975, -101.8725974)",
      6.673337656114311);
  graph.addEdge("(33.5847923, -101.8726076)", "(33.5847954, -101.8724422)",
      16.795971599078534);
  graph.addEdge("(33.5856917, -101.8717105)", "(33.5856917, -101.8715228)",
      19.05550826413011);
  graph.addEdge("(33.5862212, -101.8756748)", "(33.586257, -101.8756319)",
      6.150207356524776);
  graph.addEdge("(33.586257, -101.8756319)", "(33.5862632, -101.8754248)",
      21.038325376441463);
  graph.addEdge("(33.5862632, -101.8754248)", "(33.586105, -101.8755166)",
      21.33274052926541);
  graph.addEdge("(33.5849008, -101.8722838)", "(33.5848448, -101.8722712)",
      6.912085221022746);
  graph.addEdge("(33.5848448, -101.8722712)", "(33.5847919, -101.872267)",
      6.430816738109702);
  graph.addEdge("(33.5859185, -101.8738375)", "(33.5859791, -101.873836)",
      7.352238565608347);
  graph.addEdge("(33.5859791, -101.873836)", "(33.5861028, -101.8738349)",
      15.004983602392596);
  graph.addEdge("(33.5861028, -101.8738349)", "(33.5862238, -101.8738346)",
      14.677095213376495);
  graph.addEdge("(33.5862238, -101.8738346)", "(33.5862672, -101.8738345)",
      5.264345070968693);
  graph.addEdge("(33.5862672, -101.8738345)", "(33.5862921, -101.8738345)",
      3.02032141236585);
  graph.addEdge("(33.5857693, -101.8741889)", "(33.5857693, -101.8743458)",
      15.92864448694169);
  graph.addEdge("(33.5862212, -101.8756748)", "(33.5861944, -101.8757097)",
      4.808422738240688);
  graph.addEdge("(33.5861944, -101.8757097)", "(33.5861938, -101.8757865)",
      7.797114058921418);
  graph.addEdge("(33.5861938, -101.8757865)", "(33.5861931, -101.8759691)",
      18.537837869147136);
  graph.addEdge("(33.5861931, -101.8759691)", "(33.5861949, -101.8762433)",
      27.837777333702615);
  graph.addEdge("(33.5861023, -101.8744415)", "(33.5861022, -101.8744529)",
      1.1573984871862224);
  graph.addEdge("(33.5878077, -101.8751518)", "(33.5875215, -101.8751541)",
      34.71629453007031);
  graph.addEdge("(33.5875215, -101.8751541)", "(33.5875219, -101.8751285)",
      2.5993378625157995);
  graph.addEdge("(33.5875219, -101.8751285)", "(33.587474, -101.8751287)",
      5.810213152352056);
  graph.addEdge("(33.587474, -101.8751287)", "(33.5873375, -101.8751285)",
      16.55719911180644);
  graph.addEdge("(33.5873375, -101.8751285)", "(33.5873378, -101.8751556)",
      2.751409900880578);
  graph.addEdge("(33.5873378, -101.8751556)", "(33.587139, -101.8751585)",
      24.11585293723429);
  graph.addEdge("(33.5858481, -101.8744345)", "(33.5858486, -101.8743465)",
      8.934045482811522);
  graph.addEdge("(33.5862612, -101.8753018)", "(33.5862632, -101.8754248)",
      12.489368015183251);
  graph.addEdge("(33.5853002, -101.8749453)", "(33.5854811, -101.874941)",
      21.94715582203896);
  graph.addEdge("(33.5854811, -101.874941)", "(33.5855749, -101.8749397)",
      11.3785209992981);
  graph.addEdge("(33.5855749, -101.8749397)", "(33.5857006, -101.8749426)",
      15.250005302093859);
  graph.addEdge("(33.5857006, -101.8749426)", "(33.5857319, -101.8749587)",
      4.133514609554666);
  graph.addEdge("(33.5857319, -101.8749587)", "(33.5858012, -101.8749614)",
      8.410422011396111);
  graph.addEdge("(33.5855761, -101.8744296)", "(33.5858481, -101.8744345)",
      32.996816173168476);
  graph.addEdge("(33.5858481, -101.8744345)", "(33.5859156, -101.8744355)",
      8.188247129078315);
  graph.addEdge("(33.5859156, -101.8744355)", "(33.5861023, -101.8744415)",
      22.654535097085255);
  graph.addEdge("(33.5843483, -101.8736184)", "(33.5843484, -101.873549)",
      7.045683144909892);
  graph.addEdge("(33.5843484, -101.873549)", "(33.5843488, -101.8733252)",
      22.720823368662742);
  graph.addEdge("(33.5843488, -101.8733252)", "(33.5843499, -101.8733061)",
      1.9436679567508466);
  graph.addEdge("(33.5843499, -101.8733061)", "(33.584353, -101.8732893)",
      1.7465392288078754);
  graph.addEdge("(33.584353, -101.8732893)", "(33.5843608, -101.87328)",
      1.3366341655490979);
  graph.addEdge("(33.5850722, -101.8727062)", "(33.5850459, -101.8726359)",
      7.81751429785179);
  graph.addEdge("(33.5850459, -101.8726359)", "(33.585037, -101.8725662)",
      7.157949532885756);
  graph.addEdge("(33.585037, -101.8725662)", "(33.5850334, -101.8725022)",
      6.512056131069345);
  graph.addEdge("(33.5850334, -101.8725022)", "(33.5850325, -101.8724857)",
      1.6786642038603738);
  graph.addEdge("(33.5850325, -101.8724857)", "(33.5850335, -101.8724419)",
      4.448311558328112);
  graph.addEdge("(33.5850335, -101.8724419)", "(33.5850347, -101.8723865)",
      5.626194159047017);
  graph.addEdge("(33.5862682, -101.8743508)", "(33.5861019, -101.8743534)",
      20.17359205309335);
  graph.addEdge("(33.5861019, -101.8743534)", "(33.5859156, -101.8743483)",
      22.603756042897793);
  graph.addEdge("(33.5859156, -101.8743483)", "(33.5858486, -101.8743465)",
      8.129022937625146);
  graph.addEdge("(33.5858486, -101.8743465)", "(33.5857693, -101.8743458)",
      9.61919703555708);
  graph.addEdge("(33.5857693, -101.8743458)", "(33.5855989, -101.8743433)",
      20.670743701311086);
  graph.addEdge("(33.5855989, -101.8743433)", "(33.5854398, -101.8743438)",
      19.298583925091148);
  graph.addEdge("(33.5866859, -101.8748456)", "(33.5869947, -101.8744904)",
      51.99350940032828);
  graph.addEdge("(33.5870866, -101.8752864)", "(33.58694, -101.875159)",
      21.98835575795427);
  graph.addEdge("(33.58694, -101.875159)", "(33.5868045, -101.8750309)",
      20.958529066962985);
  graph.addEdge("(33.5868045, -101.8750309)", "(33.5871407, -101.8750526)",
      40.83986801625261);
  graph.addEdge("(33.5851495, -101.871806)", "(33.5852366, -101.8718042)",
      10.566638440539158);
  graph.addEdge("(33.5852366, -101.8718042)", "(33.5856112, -101.8718017)",
      45.43895156658474);
  graph.addEdge("(33.5856112, -101.8718017)", "(33.5856917, -101.8717105)",
      13.45620073783786);
  graph.addEdge("(33.5855504, -101.8741959)", "(33.5855442, -101.874213)",
      1.8919087680063562);
  graph.addEdge("(33.5855442, -101.874213)", "(33.5854398, -101.8743438)",
      18.349282024938915);
  graph.addEdge("(33.5877429, -101.8749533)", "(33.5874746, -101.8749484)",
      32.54807496465557);
  graph.addEdge("(33.5874746, -101.8749484)", "(33.5872401, -101.8749453)",
      28.446138296769263);
  graph.addEdge("(33.5872401, -101.8749453)", "(33.5872133, -101.874956)",
      3.4274738406210674);
  graph.addEdge("(33.5872133, -101.874956)", "(33.5871396, -101.8749555)",
      8.939811590837254);
  graph.addEdge("(33.5871396, -101.8749555)", "(33.5870844, -101.8749556)",
      6.695660884963304);
  graph.addEdge("(33.5870844, -101.8749556)", "(33.5866866, -101.8749483)",
      48.25805927752838);
  graph.addEdge("(33.5830112, -101.8754223)", "(33.5832286, -101.8754225)",
      26.370190113457603);
  graph.addEdge("(33.5832286, -101.8754225)", "(33.5832409, -101.8754185)",
      1.5462451920270508);
  graph.addEdge("(33.5832409, -101.8754185)", "(33.5832918, -101.8753923)",
      6.722672296105234);
  graph.addEdge("(33.5832918, -101.8753923)", "(33.5833044, -101.8753882)",
      1.5840234774717985);
  graph.addEdge("(33.5833044, -101.8753882)", "(33.5833091, -101.8753866)",
      0.5927907001565369);
  graph.addEdge("(33.5833091, -101.8753866)", "(33.5833267, -101.8753826)",
      2.173125661943575);
  graph.addEdge("(33.5833267, -101.8753826)", "(33.5833812, -101.8753828)",
      6.610771703695115);
  graph.addEdge("(33.5833812, -101.8753828)", "(33.5835063, -101.8753833)",
      15.174463828497787);
  graph.addEdge("(33.5835063, -101.8753833)", "(33.58353, -101.8753849)",
      2.8793480691083797);
  graph.addEdge("(33.58353, -101.8753849)", "(33.5835423, -101.8753903)",
      1.5895011668761556);
  graph.addEdge("(33.5835423, -101.8753903)", "(33.5835921, -101.8754174)",
      6.637689687192624);
  graph.addEdge("(33.5835921, -101.8754174)", "(33.5836015, -101.8754225)",
      1.25225577569773);
  graph.addEdge("(33.5836015, -101.8754225)", "(33.5836102, -101.8754272)",
      1.1581557045533635);
  graph.addEdge("(33.5836102, -101.8754272)", "(33.5836567, -101.875427)",
      5.640393395131888);
  graph.addEdge("(33.5836567, -101.875427)", "(33.5836725, -101.8754275)",
      1.9171804909835601);
  graph.addEdge("(33.5836725, -101.8754275)", "(33.5836825, -101.8754265)",
      1.2172211930680337);
  graph.addEdge("(33.5836825, -101.8754265)", "(33.5836954, -101.8754222)",
      1.6245001979775926);
  graph.addEdge("(33.5836954, -101.8754222)", "(33.5837071, -101.8754128)",
      1.710209772573119);
  graph.addEdge("(33.5837071, -101.8754128)", "(33.5837183, -101.8754)",
      1.8799796691269455);
  graph.addEdge("(33.5837183, -101.8754)", "(33.5837258, -101.8753823)",
      2.0141245467330564);
  graph.addEdge("(33.5837258, -101.8753823)", "(33.5837278, -101.8753511)",
      3.1768061806395003);
  graph.addEdge("(33.5837278, -101.8753511)", "(33.5837274, -101.8751572)",
      19.685444798775816);
  graph.addEdge("(33.5837274, -101.8751572)", "(33.5837271, -101.8750149)",
      14.446824054370566);
  graph.addEdge("(33.5837271, -101.8750149)", "(33.5837268, -101.8748649)",
      15.228551846421823);
  graph.addEdge("(33.5837268, -101.8748649)", "(33.5837264, -101.8746817)",
      18.599148251025227);
  graph.addEdge("(33.5837264, -101.8746817)", "(33.5837278, -101.8746225)",
      6.012583231655163);
  graph.addEdge("(33.5837278, -101.8746225)", "(33.5837317, -101.8745759)",
      4.754582226755414);
  graph.addEdge("(33.5837317, -101.8745759)", "(33.5837359, -101.874532)",
      4.485898844016188);
  graph.addEdge("(33.5837359, -101.874532)", "(33.583747, -101.8744686)",
      6.575895309834287);
  graph.addEdge("(33.583747, -101.8744686)", "(33.583768, -101.8743915)",
      8.231494715341864);
  graph.addEdge("(33.583768, -101.8743915)", "(33.583799, -101.8743033)",
      9.7118433099426);
  graph.addEdge("(33.583799, -101.8743033)", "(33.5838225, -101.874246)",
      6.478129915218068);
  graph.addEdge("(33.5838225, -101.874246)", "(33.5838579, -101.8741816)",
      7.822066334269996);
  graph.addEdge("(33.5838579, -101.8741816)", "(33.5838797, -101.8741441)",
      4.635350350291529);
  graph.addEdge("(33.5838797, -101.8741441)", "(33.5839157, -101.8740914)",
      6.906064382431007);
  graph.addEdge("(33.5839157, -101.8740914)", "(33.5839554, -101.8740395)",
      7.138083546176542);
  graph.addEdge("(33.5839554, -101.8740395)", "(33.5839987, -101.8739952)",
      6.914687770861535);
  graph.addEdge("(33.5839987, -101.8739952)", "(33.5840656, -101.8739368)",
      10.050022931913539);
  graph.addEdge("(33.5840656, -101.8739368)", "(33.5840736, -101.8739298)",
      1.2027818287046268);
  graph.addEdge("(33.5840736, -101.8739298)", "(33.5841481, -101.8738617)",
      11.378110094775716);
  graph.addEdge("(33.5841481, -101.8738617)", "(33.5842054, -101.8738018)",
      9.23520190262194);
  graph.addEdge("(33.5842054, -101.8738018)", "(33.5842196, -101.8737843)",
      2.4745209548515095);
  graph.addEdge("(33.5842196, -101.8737843)", "(33.5842316, -101.8737599)",
      2.8731525969244114);
  graph.addEdge("(33.5842316, -101.8737599)", "(33.5842451, -101.8737233)",
      4.06056178721521);
  graph.addEdge("(33.5842451, -101.8737233)", "(33.5842512, -101.8736992)",
      2.556132676621204);
  graph.addEdge("(33.5842512, -101.8736992)", "(33.5842559, -101.8736754)",
      2.4825873761145067);
  graph.addEdge("(33.5842559, -101.8736754)", "(33.5842571, -101.8736475)",
      2.8362227933793336);
  graph.addEdge("(33.5842571, -101.8736475)", "(33.5842565, -101.8736135)",
      3.4525412996082343);
  graph.addEdge("(33.5842565, -101.8736135)", "(33.5842557, -101.8732988)",
      31.949362916773932);
  graph.addEdge("(33.5842557, -101.8732988)", "(33.5842529, -101.8732871)",
      1.2354187171400028);
  graph.addEdge("(33.5842529, -101.8732871)", "(33.5842469, -101.8732792)",
      1.0830177608499747);
  graph.addEdge("(33.5842469, -101.8732792)", "(33.5842393, -101.8732717)",
      1.195657390550217);
  graph.addEdge("(33.5842393, -101.8732717)", "(33.5842298, -101.8732683)",
      1.2029191269082982);
  graph.addEdge("(33.5842298, -101.8732683)", "(33.5842191, -101.873269)",
      1.2998328433295765);
  graph.addEdge("(33.5842191, -101.873269)", "(33.5841528, -101.8732941)",
      8.436121069201878);
  graph.addEdge("(33.5841528, -101.8732941)", "(33.5841166, -101.8733129)",
      4.78786439738728);
  graph.addEdge("(33.5841166, -101.8733129)", "(33.5840795, -101.8733388)",
      5.212042082037426);
  graph.addEdge("(33.5840795, -101.8733388)", "(33.5837971, -101.8736075)",
      43.7896457561448);
  graph.addEdge("(33.5837971, -101.8736075)", "(33.5837321, -101.873672)",
      10.249045955558856);
  graph.addEdge("(33.5837321, -101.873672)", "(33.5836912, -101.8737089)",
      6.216631938447828);
  graph.addEdge("(33.5836912, -101.8737089)", "(33.583649, -101.8737478)",
      6.465178749405201);
  graph.addEdge("(33.583649, -101.8737478)", "(33.5836138, -101.8737827)",
      5.548360411644626);
  graph.addEdge("(33.5836138, -101.8737827)", "(33.5835979, -101.8737984)",
      2.502044012801182);
  graph.addEdge("(33.5835979, -101.8737984)", "(33.583568, -101.8738175)",
      4.112646340421809);
  graph.addEdge("(33.583568, -101.8738175)", "(33.5835314, -101.873842)",
      5.088813241382028);
  graph.addEdge("(33.5835314, -101.873842)", "(33.583492, -101.8738635)",
      5.254010108403486);
  graph.addEdge("(33.583492, -101.8738635)", "(33.5834599, -101.8738812)",
      4.288324851397128);
  graph.addEdge("(33.5834599, -101.8738812)", "(33.5834459, -101.8738892)",
      1.882402692415366);
  graph.addEdge("(33.5861017, -101.8741882)", "(33.5859168, -101.8741909)",
      22.4296831604508);
  graph.addEdge("(33.587139, -101.8751585)", "(33.5871407, -101.8750526)",
      10.752881021773605);
  graph.addEdge("(33.5871407, -101.8750526)", "(33.5871396, -101.8749555)",
      9.858435927840995);
  graph.addEdge("(33.5854577, -101.873175)", "(33.5854457, -101.8731689)",
      1.5818377870128186);
  graph.addEdge("(33.5854457, -101.8731689)", "(33.5854239, -101.8731595)",
      2.8112270734836216);
  graph.addEdge("(33.5854239, -101.8731595)", "(33.5854055, -101.8731582)",
      2.2357824960812924);
  graph.addEdge("(33.5854055, -101.8731582)", "(33.5853608, -101.8731689)",
      5.529767230196598);
  graph.addEdge("(33.5853608, -101.8731689)", "(33.5852541, -101.8732004)",
      13.331730809248414);
  graph.addEdge("(33.5852541, -101.8732004)", "(33.5851893, -101.8732232)",
      8.193849476936938);
  graph.addEdge("(33.5851893, -101.8732232)", "(33.585122, -101.8732387)",
      8.31363791832564);
  graph.addEdge("(33.585122, -101.8732387)", "(33.5850363, -101.8732521)",
      10.483877965162538);
  graph.addEdge("(33.5850363, -101.8732521)", "(33.5849592, -101.8732621)",
      9.407020001258909);
  graph.addEdge("(33.5849592, -101.8732621)", "(33.5849033, -101.8732662)",
      6.793323352505529);
  graph.addEdge("(33.5849033, -101.8732662)", "(33.5848631, -101.8732668)",
      4.876560902942282);
  graph.addEdge("(33.5848631, -101.8732668)", "(33.5847982, -101.8732655)",
      7.873347751392322);
  graph.addEdge("(33.5847982, -101.8732655)", "(33.5847826, -101.8732655)",
      1.8922491032282425);
  graph.addEdge("(33.5847826, -101.8732655)", "(33.5847736, -101.8732709)",
      1.2216033546862386);
  graph.addEdge("(33.5847736, -101.8732709)", "(33.5846996, -101.8732709)",
      8.976053358625274);
  graph.addEdge("(33.5858012, -101.8749614)", "(33.5858771, -101.8749614)",
      9.206521237895462);
  graph.addEdge("(33.5858771, -101.8749614)", "(33.5859084, -101.874948)",
      4.032991640390132);
  graph.addEdge("(33.5859084, -101.874948)", "(33.5860793, -101.8749495)",
      20.73039487835352);
  graph.addEdge("(33.5860793, -101.8749495)", "(33.5866866, -101.8749483)",
      73.66440692567036);
  graph.addEdge("(33.5851219, -101.8730855)", "(33.5850355, -101.873106)",
      10.684798166073834);
  graph.addEdge("(33.5850355, -101.873106)", "(33.5849592, -101.8731136)",
      9.287145161400774);
  graph.addEdge("(33.5849592, -101.8731136)", "(33.584876, -101.873122)",
      10.127961960469278);
  graph.addEdge("(33.584876, -101.873122)", "(33.5847962, -101.8731217)",
      9.679629938737532);
  graph.addEdge("(33.5859168, -101.8741909)", "(33.5857693, -101.8741889)",
      17.892612991337867);
  graph.addEdge("(33.5857693, -101.8741889)", "(33.5856498, -101.8741949)",
      14.507908454775057);
  graph.addEdge("(33.58483, -101.8724418)", "(33.5849457, -101.8725681)",
      19.009678601854652);
  graph.addEdge("(33.5849457, -101.8725681)", "(33.5850722, -101.8727062)",
      20.784843429442084);
  graph.addEdge("(33.585364, -101.8750245)", "(33.5853009, -101.8750192)",
      7.672795142272358);
  graph.addEdge("(33.5851284, -101.8718292)", "(33.5851495, -101.871806)",
      3.4782074299240344);
  graph.addEdge("(33.5855753, -101.8745351)", "(33.5854407, -101.8746812)",
      22.05805162431407);
  graph.addEdge("(33.5866838, -101.8742238)", "(33.5866833, -101.8743475)",
      12.558161378963522);
  graph.addEdge("(33.5866833, -101.8743475)", "(33.586685, -101.874444)",
      9.798842799607941);
  graph.addEdge("(33.5861073, -101.87357)", "(33.5861053, -101.8736898)",
      12.164587466753058);
  graph.addEdge("(33.5861053, -101.8736898)", "(33.5861028, -101.8738349)",
      14.733760807357795);
  graph.addEdge("(33.5861028, -101.8738349)", "(33.586102, -101.8740788)",
      24.761066258204423);
  graph.addEdge("(33.586102, -101.8740788)", "(33.5861017, -101.8741882)",
      11.10641411864048);
  graph.addEdge("(33.5861073, -101.87357)", "(33.5859785, -101.8737872)",
      27.02405114187612);
  graph.addEdge("(33.5859785, -101.8737872)", "(33.5859715, -101.8737996)",
      1.5184430999989713);
  graph.addEdge("(33.5859715, -101.8737996)", "(33.5859185, -101.8738375)",
      7.492245269818784);
  graph.addEdge("(33.5859185, -101.8738375)", "(33.5859168, -101.8741909)",
      35.87805165484624);
  graph.addEdge("(33.5859168, -101.8741909)", "(33.5859156, -101.8743483)",
      15.980040840656487);
  graph.addEdge("(33.5859156, -101.8743483)", "(33.5859156, -101.8744355)",
      8.852616030612385);
  graph.addEdge("(33.5851398, -101.8742801)", "(33.5850757, -101.8743267)",
      9.101392277825497);
  graph.addEdge("(33.5850757, -101.8743267)", "(33.585033, -101.8743544)",
      5.893612203318452);
  graph.addEdge("(33.586267, -101.8741879)", "(33.5862682, -101.8743508)",
      16.538315963237856);
  graph.addEdge("(33.5853646, -101.875191)", "(33.585364, -101.8750245)",
      16.90348170979639);
  graph.addEdge("(33.5866866, -101.8749483)", "(33.5866844, -101.8750285)",
      8.146269940996708);
  graph.addEdge("(33.5855749, -101.8748304)", "(33.5853295, -101.8748287)",
      29.767037479669824);
  graph.addEdge("(33.5853295, -101.8748287)", "(33.5852998, -101.8748223)",
      3.6606743070815515);
  graph.addEdge("(33.5864245, -101.8751559)", "(33.5861639, -101.8751429)",
      31.637810411279183);
  graph.addEdge("(33.5860805, -101.8755166)", "(33.586105, -101.8755166)",
      2.9718021022708245);
  graph.addEdge("(33.586105, -101.8755166)", "(33.5862212, -101.8756748)",
      21.36833043220358);
  graph.addEdge("(33.5856498, -101.8741949)", "(33.5855984, -101.8741954)",
      6.234925672795976);
  graph.addEdge("(33.5855984, -101.8741954)", "(33.5855504, -101.8741959)",
      5.822526940786017);
  graph.addEdge("(33.5855504, -101.8741959)", "(33.585289, -101.8741976)",
      31.707775209132237);
  graph.addEdge("(33.585289, -101.8741976)", "(33.5852086, -101.8741974)",
      9.752382622971016);
  graph.addEdge("(33.5851398, -101.8742801)", "(33.5851186, -101.8742297)",
      5.72654206778225);
  graph.addEdge("(33.5851186, -101.8742297)", "(33.5851003, -101.8741984)",
      3.876164160631413);
  graph.addEdge("(33.5851003, -101.8741984)", "(33.5850951, -101.8741895)",
      1.1019241171528935);
  graph.addEdge("(33.5850951, -101.8741895)", "(33.585075, -101.8741593)",
      3.917190929003643);
  graph.addEdge("(33.585075, -101.8741593)", "(33.5850678, -101.8741426)",
      1.9071346335152928);
  graph.addEdge("(33.5850678, -101.8741426)", "(33.5850672, -101.8741131)",
      2.995777834791791);
  graph.addEdge("(33.5850672, -101.8741131)", "(33.5850638, -101.8740815)",
      3.234489658236846);
  graph.addEdge("(33.5850638, -101.8740815)", "(33.585051, -101.8740561)",
      3.0099952710438904);
  graph.addEdge("(33.585051, -101.8740561)", "(33.5850214, -101.8740209)",
      5.065720523367785);
  graph.addEdge("(33.5850214, -101.8740209)", "(33.5850091, -101.8740062)",
      2.110245187231115);
  graph.addEdge("(33.5850091, -101.8740062)", "(33.5849904, -101.8739857)",
      3.0783845652309707);
  graph.addEdge("(33.5849904, -101.8739857)", "(33.5849429, -101.8739397)",
      7.416580481255378);
  graph.addEdge("(33.5849429, -101.8739397)", "(33.5849085, -101.8739089)",
      5.214248274503342);
  graph.addEdge("(33.5849085, -101.8739089)", "(33.5848999, -101.8739012)",
      1.3035621818456964);
  graph.addEdge("(33.5848999, -101.8739012)", "(33.5848801, -101.8738861)",
      2.84924595762769);
  graph.addEdge("(33.5848801, -101.8738861)", "(33.5848496, -101.8738666)",
      4.195961963406858);
  graph.addEdge("(33.5848496, -101.8738666)", "(33.5848222, -101.8738522)",
      3.6308805922340652);
  graph.addEdge("(33.5848222, -101.8738522)", "(33.584801, -101.8738469)",
      2.62720788518086);
  graph.addEdge("(33.584801, -101.8738469)", "(33.5847823, -101.8738412)",
      2.340924688591873);
  graph.addEdge("(33.5847823, -101.8738412)", "(33.5847664, -101.8738351)",
      2.0256259849919265);
  graph.addEdge("(33.5847664, -101.8738351)", "(33.5847549, -101.8738288)",
      1.5345673513035882);
  graph.addEdge("(33.5847549, -101.8738288)", "(33.5847412, -101.8738187)",
      1.9526685353901412);
  graph.addEdge("(33.5847412, -101.8738187)", "(33.5847267, -101.8738006)",
      2.543629217991013);
  graph.addEdge("(33.5847267, -101.8738006)", "(33.5847175, -101.8737872)",
      1.7595477246379398);
  graph.addEdge("(33.5847175, -101.8737872)", "(33.5847055, -101.8737577)",
      3.329889468448128);
  graph.addEdge("(33.5847055, -101.8737577)", "(33.5846985, -101.8737319)",
      2.7534602646948345);
  graph.addEdge("(33.5846985, -101.8737319)", "(33.5846926, -101.8737054)",
      2.7838992074162365);
  graph.addEdge("(33.5846926, -101.8737054)", "(33.5846887, -101.8736789)",
      2.731614305896344);
  graph.addEdge("(33.5846887, -101.8736789)", "(33.5846879, -101.8736625)",
      1.6677905449635453);
  graph.addEdge("(33.5846879, -101.8736625)", "(33.584691, -101.8736484)",
      1.4800279793780147);
  graph.addEdge("(33.584691, -101.8736484)", "(33.5846919, -101.8736198)",
      2.90558817247555);
  graph.addEdge("(33.5846919, -101.8736198)", "(33.5846462, -101.8736192)",
      5.543654046018547);
  graph.addEdge("(33.5846462, -101.8736192)", "(33.5846023, -101.8736209)",
      5.327779049553035);
  graph.addEdge("(33.5856917, -101.8715228)", "(33.585361, -101.8715174)",
      40.117005768269706);
  graph.addEdge("(33.585361, -101.8715174)", "(33.5853609, -101.871494)",
      2.375633496187511);
  graph.addEdge("(33.5850347, -101.8723865)", "(33.5849878, -101.8723409)",
      7.334483662557627);
  graph.addEdge("(33.5849878, -101.8723409)", "(33.5849466, -101.8723078)",
      6.022202201738208);
  graph.addEdge("(33.5849466, -101.8723078)", "(33.5849008, -101.8722838)",
      6.06627442504703);
  graph.addEdge("(33.584786, -101.8718338)", "(33.5851284, -101.8718292)",
      41.5350684300385);
  graph.addEdge("(33.5849085, -101.8739089)", "(33.5849208, -101.8738939)",
      2.1318941540090615);
  graph.addEdge("(33.5849208, -101.8738939)", "(33.5851228, -101.8736514)",
      34.73407078306969);
  graph.addEdge("(33.5847423, -101.8740131)", "(33.5847433, -101.8740103)",
      0.30906016323169433);
  graph.addEdge("(33.5847433, -101.8740103)", "(33.5847621, -101.8739617)",
      5.435474119370935);
  graph.addEdge("(33.5847621, -101.8739617)", "(33.584766, -101.8739515)",
      1.1384649247917222);
  graph.addEdge("(33.584766, -101.8739515)", "(33.584801, -101.8738469)",
      11.436409098436323);
  graph.addEdge("(33.584801, -101.8738469)", "(33.5848399, -101.8738028)",
      6.50452336117055);
  graph.addEdge("(33.5848399, -101.8738028)", "(33.5848972, -101.87365)",
      16.99845728236331);
  graph.addEdge("(33.5848972, -101.87365)", "(33.5849568, -101.8735236)",
      14.72866664140341);
  graph.addEdge("(33.5849568, -101.8735236)", "(33.5850195, -101.8734029)",
      14.422029446582322);
  graph.addEdge("(33.5850195, -101.8734029)", "(33.5850685, -101.873323)",
      10.056062917805232);
  graph.addEdge("(33.5850685, -101.873323)", "(33.5851222, -101.8732694)",
      8.487579105476017);
  graph.addEdge("(33.5855749, -101.8748304)", "(33.5855753, -101.8745351)",
      29.979256942939525);
  graph.addEdge("(33.5848975, -101.8725974)", "(33.5848414, -101.8726054)",
      6.853115482931886);
  graph.addEdge("(33.5848414, -101.8726054)", "(33.5847923, -101.8726076)",
      5.959919259212482);
  graph.addEdge("(33.5854577, -101.873175)", "(33.5855722, -101.8731751)",
      13.888628565334361);
  graph.addEdge("(33.5855722, -101.8731751)", "(33.5859132, -101.8731725)",
      41.36347320514761);
  graph.addEdge("(33.5859132, -101.8731725)", "(33.5861118, -101.873171)",
      24.090272733331666);
  graph.addEdge("(33.5861118, -101.873171)", "(33.5861081, -101.8734963)",
      33.027700124522106);
  graph.addEdge("(33.5861081, -101.8734963)", "(33.5861073, -101.87357)",
      7.482697539733591);
  graph.addEdge("(33.5855761, -101.8744296)", "(33.5855989, -101.8743433)",
      9.187412685409296);
  graph.addEdge("(33.5855989, -101.8743433)", "(33.5855984, -101.8741954)",
      15.015107555331909);
  graph.addEdge("(33.5865315, -101.8743409)", "(33.5863039, -101.8742104)",
      30.62173109968323);
  graph.addEdge("(33.5863039, -101.8742104)", "(33.586267, -101.8741879)",
      5.025064470720906);
  graph.addEdge("(33.586267, -101.8741879)", "(33.5861017, -101.8741882)",
      20.050590267106394);
  graph.addEdge("(33.5870844, -101.8749556)", "(33.5870875, -101.8750499)",
      9.580666618099494);
  graph.addEdge("(33.5870875, -101.8750499)", "(33.5870882, -101.8751586)",
      11.03549121377872);
  graph.addEdge("(33.5870882, -101.8751586)", "(33.5870866, -101.8752864)",
      12.975637666849352);
  graph.addEdge("(33.5847954, -101.8724422)", "(33.5847919, -101.872267)",
      17.791744821718584);
  graph.addEdge("(33.5847919, -101.872267)", "(33.5847897, -101.8721388)",
      13.017874215971606);
  graph.addEdge("(33.5847897, -101.8721388)", "(33.584786, -101.8718338)",
      30.9675071075181);
  graph.addEdge("(33.5853009, -101.8750192)", "(33.5853002, -101.8749453)",
      7.5029227333003465);
  graph.addEdge("(33.5857993, -101.8748421)", "(33.5855753, -101.8745351)",
      41.34767935048174);
  graph.addEdge("(33.5861639, -101.8751429)", "(33.5862612, -101.8753018)",
      19.98806976570117);
  graph.addEdge("(33.5839115, -101.8743481)", "(33.584126, -101.8743501)",
      26.01921418593972);
  graph.addEdge("(33.584126, -101.8743501)", "(33.5843384, -101.8743527)",
      25.765049148606625);
  graph.addEdge("(33.5843384, -101.8743527)", "(33.5846053, -101.8743531)",
      32.37446518682933);
  graph.addEdge("(33.5846053, -101.8743531)", "(33.585033, -101.8743544)",
      51.87933102674749);
  graph.addEdge("(33.584079, -101.8752696)", "(33.5840848, -101.875248)",
      2.302986348097676);
  graph.addEdge("(33.5840848, -101.875248)", "(33.5841113, -101.8746853)",
      57.217328264079775);
  graph.addEdge("(33.5841113, -101.8746853)", "(33.584126, -101.8743501)",
      34.07716791563704);
  graph.addEdge("(33.584126, -101.8743501)", "(33.5841388, -101.8740481)",
      30.699207057126216);
  graph.addEdge("(33.586032, -101.8798305)", "(33.586035, -101.8795813)",
      25.301572385214406);
  graph.addEdge("(33.586035, -101.8795813)", "(33.586038, -101.8793281)",
      25.707612910121522);
  graph.addEdge("(33.586038, -101.8793281)", "(33.5860383, -101.8793013)",
      2.720997630013861);
  graph.addEdge("(33.586032, -101.8798305)", "(33.5859525, -101.8798303)",
      9.643215797072633);
  graph.addEdge("(33.5859525, -101.8798303)", "(33.585953, -101.8795813)",
      25.278747602145263);
  graph.addEdge("(33.585953, -101.8795813)", "(33.5859533, -101.8794033)",
      18.070735843388952);
  graph.addEdge("(33.5859533, -101.8794033)", "(33.5859535, -101.8793275)",
      7.6953134973173585);
  graph.addEdge("(33.5859535, -101.8793275)", "(33.5859535, -101.8793075)",
      2.030415633480438);
  graph.addEdge("(33.5859535, -101.8793075)", "(33.5859542, -101.8792497)",
      5.868515437064442);
  graph.addEdge("(33.5859542, -101.8792497)", "(33.585955, -101.8791725)",
      7.838004959262896);
  graph.addEdge("(33.585955, -101.8791725)", "(33.5859555, -101.8791323)",
      4.081585961934143);
  graph.addEdge("(33.5859555, -101.8791323)", "(33.5859574, -101.878779)",
      35.86803135961304);
  graph.addEdge("(33.5859574, -101.878779)", "(33.5859551, -101.8787616)",
      1.7883565895642375);
  graph.addEdge("(33.5859551, -101.8787616)", "(33.5859516, -101.8787281)",
      3.4273418092709362);
  graph.addEdge("(33.5859516, -101.8787281)", "(33.5859536, -101.8786993)",
      2.933845731796682);
  graph.addEdge("(33.5859536, -101.8786993)", "(33.5859578, -101.8786852)",
      1.519397949129938);
  graph.addEdge("(33.5859578, -101.8786852)", "(33.5859676, -101.8786724)",
      1.7611555075264718);
  graph.addEdge("(33.5859676, -101.8786724)", "(33.585975, -101.878665)",
      1.170503173045582);
  graph.addEdge("(33.585975, -101.878665)", "(33.5859851, -101.8786563)",
      1.5102950876800414);
  graph.addEdge("(33.5859851, -101.8786563)", "(33.5860002, -101.8786477)",
      2.0290455819930138);
  graph.addEdge("(33.5873343, -101.8805192)", "(33.5873713, -101.8804288)",
      10.215957904061161);
  graph.addEdge("(33.5873713, -101.8804288)", "(33.5873774, -101.8804063)",
      2.401032679090739);
  graph.addEdge("(33.5873774, -101.8804063)", "(33.5873783, -101.8802125)",
      19.67470707142693);
  graph.addEdge("(33.5873783, -101.8802125)", "(33.5873793, -101.8799963)",
      21.948767276236133);
  graph.addEdge("(33.5873359, -101.8795229)", "(33.5872308, -101.8793109)",
      25.014438345170444);
  graph.addEdge("(33.5872308, -101.8793109)", "(33.5872174, -101.8792536)",
      6.0398709363616945);
  graph.addEdge("(33.587228, -101.8804493)", "(33.5872247, -101.8802581)",
      19.414615319695947);
  graph.addEdge("(33.5872247, -101.8802581)", "(33.5872223, -101.8801215)",
      13.870590894996761);
  graph.addEdge("(33.5872223, -101.8801215)", "(33.5872226, -101.8797934)",
      33.308500737331336);
  graph.addEdge("(33.5872226, -101.8797934)", "(33.5872169, -101.879447)",
      35.1730811507991);
  graph.addEdge("(33.5872169, -101.879447)", "(33.5872173, -101.8792857)",
      16.37513525876277);
  graph.addEdge("(33.5872173, -101.8792857)", "(33.5872174, -101.8792536)",
      3.258792152417897);
  graph.addEdge("(33.5872174, -101.8792536)", "(33.5872175, -101.8792233)",
      3.0760587465502938);
  graph.addEdge("(33.5872175, -101.8792233)", "(33.5872187, -101.8787955)",
      43.43020072414354);
  graph.addEdge("(33.5872187, -101.8787955)", "(33.5872187, -101.8787792)",
      1.6547645883815048);
  graph.addEdge("(33.5872187, -101.8787792)", "(33.5872188, -101.8787488)",
      3.0862105525888857);
  graph.addEdge("(33.5872188, -101.8787488)", "(33.5870884, -101.8787433)",
      15.82711983310025);
  graph.addEdge("(33.5870884, -101.8787433)", "(33.587032, -101.8787408)",
      6.845916967505881);
  graph.addEdge("(33.587032, -101.8787408)", "(33.5869591, -101.8787385)",
      8.845711024452891);
  graph.addEdge("(33.5852715, -101.8804951)", "(33.5852742, -101.8803424)",
      15.505804145549554);
  graph.addEdge("(33.5852742, -101.8803424)", "(33.5852736, -101.8803399)",
      0.264032571671698);
  graph.addEdge("(33.5852736, -101.8803399)", "(33.5852736, -101.8801106)",
      23.27889780860493);
  graph.addEdge("(33.5852736, -101.8801106)", "(33.5852736, -101.8798819)",
      23.217984861163462);
  graph.addEdge("(33.5852736, -101.8798819)", "(33.5852736, -101.8797146)",
      16.98455997989754);
  graph.addEdge("(33.5852736, -101.8797146)", "(33.5852754, -101.8796817)",
      3.34718849068431);
  graph.addEdge("(33.5852754, -101.8796817)", "(33.585457, -101.8794199)",
      34.51996066802627);
  graph.addEdge("(33.585457, -101.8794199)", "(33.5857681, -101.8794213)",
      37.736086528315646);
  graph.addEdge("(33.5857681, -101.8794213)", "(33.5857913, -101.8794039)",
      3.3225952994340817);
  graph.addEdge("(33.5857913, -101.8794039)", "(33.5859533, -101.8794033)",
      19.650376999620725);
  graph.addEdge("(33.5866976, -101.8783461)", "(33.5866152, -101.878345)",
      9.995583647147686);
  graph.addEdge("(33.5866152, -101.878345)", "(33.5864218, -101.8783424)",
      23.46052842091967);
  graph.addEdge("(33.5864218, -101.8783424)", "(33.5863963, -101.8783359)",
      3.162706632235461);
  graph.addEdge("(33.5863963, -101.8783359)", "(33.5863555, -101.8783183)",
      5.261626212892125);
  graph.addEdge("(33.5863555, -101.8783183)", "(33.5863213, -101.8782955)",
      4.750456223296928);
  graph.addEdge("(33.5863213, -101.8782955)", "(33.5862979, -101.8782792)",
      3.285524654286671);
  graph.addEdge("(33.5862979, -101.8782792)", "(33.58628, -101.8782746)",
      2.2208883237769776);
  graph.addEdge("(33.58628, -101.8782746)", "(33.5860959, -101.8782751)",
      22.33102812204108);
  graph.addEdge("(33.5860959, -101.8782751)", "(33.5860344, -101.8782752)",
      7.4598366404024965);
  graph.addEdge("(33.5860344, -101.8782752)", "(33.5860196, -101.8782733)",
      1.8055439614298479);
  graph.addEdge("(33.5860196, -101.8782733)", "(33.5859708, -101.878267)",
      5.953797334609414);
  graph.addEdge("(33.585401, -101.8780818)", "(33.5852276, -101.8777324)",
      41.23865176005155);
  graph.addEdge("(33.5852276, -101.8777324)", "(33.5851697, -101.8776212)",
      13.295524137051922);
  graph.addEdge("(33.5851697, -101.8776212)", "(33.5851344, -101.8775482)",
      8.55909894808933);
  graph.addEdge("(33.5851344, -101.8775482)", "(33.5850691, -101.8774133)",
      15.820852363111744);
  graph.addEdge("(33.5852276, -101.8777324)", "(33.5853092, -101.8775477)",
      21.203069957520448);
  graph.addEdge("(33.5800625, -101.880112)", "(33.580017, -101.8802193)",
      12.212187856701242);
  graph.addEdge("(33.580017, -101.8802193)", "(33.5799287, -101.8804124)",
      22.33995798675035);
  graph.addEdge("(33.5799287, -101.8804124)", "(33.5799086, -101.8804325)",
      3.1794293081594587);
  graph.addEdge("(33.5799086, -101.8804325)", "(33.579851, -101.8804724)",
      8.07620712035631);
  graph.addEdge("(33.579851, -101.8804724)", "(33.5797924, -101.880513)",
      8.216791735080918);
  graph.addEdge("(33.5797924, -101.880513)", "(33.5797611, -101.8805237)",
      3.9489893184077496);
  graph.addEdge("(33.5802248, -101.8811946)", "(33.5803051, -101.8811723)",
      9.999896840932127);
  graph.addEdge("(33.5803051, -101.8811723)", "(33.5803717, -101.8811538)",
      8.293917987414657);
  graph.addEdge("(33.5803717, -101.8811538)", "(33.5804142, -101.8811931)",
      6.518893879624194);
  graph.addEdge("(33.5804142, -101.8811931)", "(33.5804718, -101.8811995)",
      7.0169107135071505);
  graph.addEdge("(33.5804718, -101.8811995)", "(33.5804921, -101.8811994)",
      2.4623690084608323);
  graph.addEdge("(33.5804921, -101.8811994)", "(33.5805293, -101.8811992)",
      4.51232888483236);
  graph.addEdge("(33.5805293, -101.8811992)", "(33.5806182, -101.8811987)",
      10.783506053338034);
  graph.addEdge("(33.5806182, -101.8811987)", "(33.5806449, -101.8811985)",
      3.238718593992315);
  graph.addEdge("(33.5806449, -101.8811985)", "(33.5808945, -101.8811974)",
      30.276171923115538);
  graph.addEdge("(33.5808945, -101.8811974)", "(33.5811202, -101.8812141)",
      27.429398164441558);
  graph.addEdge("(33.5811202, -101.8812141)", "(33.5812941, -101.8812178)",
      21.097057942418846);
  graph.addEdge("(33.5812941, -101.8812178)", "(33.5814219, -101.8812317)",
      15.565980662572144);
  graph.addEdge("(33.5814219, -101.8812317)", "(33.5815519, -101.88125)",
      15.877810430428877);
  graph.addEdge("(33.5815519, -101.88125)", "(33.581791, -101.8813014)",
      29.468081025947882);
  graph.addEdge("(33.581791, -101.8813014)", "(33.5818308, -101.8813098)",
      4.902405927868474);
  graph.addEdge("(33.5818308, -101.8813098)", "(33.5818651, -101.8813162)",
      4.21095242820107);
  graph.addEdge("(33.5818651, -101.8813162)", "(33.5819622, -101.8813394)",
      12.011241129805333);
  graph.addEdge("(33.5819622, -101.8813394)", "(33.5820032, -101.8813451)",
      5.006772472405803);
  graph.addEdge("(33.5820032, -101.8813451)", "(33.582043, -101.8813457)",
      4.828043307422746);
  graph.addEdge("(33.582043, -101.8813457)", "(33.5821458, -101.8813351)",
      12.515783888783952);
  graph.addEdge("(33.5821458, -101.8813351)", "(33.5822265, -101.8813389)",
      9.796345614680234);
  graph.addEdge("(33.5822265, -101.8813389)", "(33.5822546, -101.8813427)",
      3.4302370105397086);
  graph.addEdge("(33.5822546, -101.8813427)", "(33.5824004, -101.8813729)",
      17.949054580320276);
  graph.addEdge("(33.5824004, -101.8813729)", "(33.5824346, -101.8813769)",
      4.168220497206125);
  graph.addEdge("(33.5824346, -101.8813769)", "(33.5824627, -101.8813717)",
      3.44911554184342);
  graph.addEdge("(33.5824627, -101.8813717)", "(33.5824947, -101.8813572)",
      4.151315950446705);
  graph.addEdge("(33.5824947, -101.8813572)", "(33.5824981, -101.8813647)",
      0.8659501735762529);
  graph.addEdge("(33.5824981, -101.8813647)", "(33.5825601, -101.8813964)",
      8.180172491169467);
  graph.addEdge("(33.5825601, -101.8813964)", "(33.5826021, -101.8814165)",
      5.488016361729985);
  graph.addEdge("(33.5826021, -101.8814165)", "(33.5826443, -101.8814185)",
      5.122800278689337);
  graph.addEdge("(33.5826443, -101.8814185)", "(33.582687, -101.8814194)",
      5.180229552668523);
  graph.addEdge("(33.582687, -101.8814194)", "(33.582716, -101.8814702)",
      6.242842525345643);
  graph.addEdge("(33.582716, -101.8814702)", "(33.5827432, -101.8814856)",
      3.6510105024508737);
  graph.addEdge("(33.5827432, -101.8814856)", "(33.5827853, -101.881497)",
      5.236157928424917);
  graph.addEdge("(33.5827853, -101.881497)", "(33.5828054, -101.8814813)",
      2.9128863015675672);
  graph.addEdge("(33.5828054, -101.8814813)", "(33.5828393, -101.8814462)",
      5.441244987324697);
  graph.addEdge("(33.5828393, -101.8814462)", "(33.5828625, -101.8814222)",
      3.7223895633602595);
  graph.addEdge("(33.5828625, -101.8814222)", "(33.5828965, -101.8814553)",
      5.319880741912843);
  graph.addEdge("(33.5828965, -101.8814553)", "(33.582929, -101.8814806)",
      4.705140671113736);
  graph.addEdge("(33.582929, -101.8814806)", "(33.5829938, -101.881502)",
      8.154851017750005);
  graph.addEdge("(33.5829938, -101.881502)", "(33.5831798, -101.881535)",
      22.808822919773657);
  graph.addEdge("(33.5831798, -101.881535)", "(33.5833081, -101.8815914)",
      16.58248828077687);
  graph.addEdge("(33.5833081, -101.8815914)", "(33.5833285, -101.8816039)",
      2.780922519601056);
  graph.addEdge("(33.5833285, -101.8816039)", "(33.5833842, -101.8816381)",
      7.5962586225553);
  graph.addEdge("(33.5833842, -101.8816381)", "(33.5834646, -101.8816544)",
      9.891763439377984);
  graph.addEdge("(33.5834646, -101.8816544)", "(33.5835807, -101.8816787)",
      14.297152433901626);
  graph.addEdge("(33.5835807, -101.8816787)", "(33.5836192, -101.8816867)",
      4.740073443765486);
  graph.addEdge("(33.5836192, -101.8816867)", "(33.5838476, -101.8817354)",
      28.142179484207304);
  graph.addEdge("(33.5838476, -101.8817354)", "(33.5842646, -101.8818238)",
      51.371283114096315);
  graph.addEdge("(33.5842646, -101.8818238)", "(33.5844582, -101.8818639)",
      23.83356152489473);
  graph.addEdge("(33.5844582, -101.8818639)", "(33.5849218, -101.8819629)",
      57.124885232422606);
  graph.addEdge("(33.5849218, -101.8819629)", "(33.5851459, -101.8820072)",
      27.552425113727526);
  graph.addEdge("(33.5851459, -101.8820072)", "(33.5852281, -101.8820207)",
      10.064452424349236);
  graph.addEdge("(33.5852281, -101.8820207)", "(33.5853328, -101.8820149)",
      12.713546614783054);
  graph.addEdge("(33.5853328, -101.8820149)", "(33.5853973, -101.882011)",
      7.83373504764668);
  graph.addEdge("(33.5853973, -101.882011)", "(33.5854472, -101.8820168)",
      6.08134526141476);
  graph.addEdge("(33.5854472, -101.8820168)", "(33.58551, -101.8820265)",
      7.680905119547654);
  graph.addEdge("(33.58551, -101.8820265)", "(33.5855407, -101.8820149)",
      3.9056252165067695);
  graph.addEdge("(33.5855407, -101.8820149)", "(33.5855713, -101.8819917)",
      4.395937791274572);
  graph.addEdge("(33.5855713, -101.8819917)", "(33.5856161, -101.8820048)",
      5.594525499799657);
  graph.addEdge("(33.5856161, -101.8820048)", "(33.585674, -101.8820217)",
      7.229687127018516);
  graph.addEdge("(33.5836096, -101.8801936)", "(33.5836725, -101.8801773)",
      7.807044221358319);
  graph.addEdge("(33.5836725, -101.8801773)", "(33.5837121, -101.8801668)",
      4.920264824061485);
  graph.addEdge("(33.5837121, -101.8801668)", "(33.5837247, -101.8801285)",
      4.177930636183743);
  graph.addEdge("(33.5837247, -101.8801285)", "(33.583746, -101.8800705)",
      6.430238728161685);
  graph.addEdge("(33.583746, -101.8800705)", "(33.5838853, -101.8796607)",
      44.90451218073055);
  graph.addEdge("(33.5838853, -101.8796607)", "(33.5839465, -101.8794722)",
      20.526487289434943);
  graph.addEdge("(33.5839465, -101.8794722)", "(33.5840449, -101.8791695)",
      32.96752927259892);
  graph.addEdge("(33.5840449, -101.8791695)", "(33.5840963, -101.8789935)",
      18.92455435599498);
  graph.addEdge("(33.5840963, -101.8789935)", "(33.5841262, -101.8789272)",
      7.645895781582295);
  graph.addEdge("(33.5841262, -101.8789272)", "(33.5841498, -101.8788747)",
      6.050046510626468);
  graph.addEdge("(33.5841498, -101.8788747)", "(33.5841834, -101.8788001)",
      8.600589275119649);
  graph.addEdge("(33.5841834, -101.8788001)", "(33.5844362, -101.8786832)",
      32.880675508962376);
  graph.addEdge("(33.5858704, -101.8762086)", "(33.5858726, -101.8765677)",
      36.457123839053736);
  graph.addEdge("(33.5858726, -101.8765677)", "(33.5858738, -101.8767674)",
      20.27424139270744);
  graph.addEdge("(33.5858738, -101.8767674)", "(33.5858738, -101.8767842)",
      1.7055506994040273);
  graph.addEdge("(33.5852041, -101.8798816)", "(33.5852736, -101.8798819)",
      8.430267978555506);
  graph.addEdge("(33.5866833, -101.8743475)", "(33.5870946, -101.8743558)",
      49.897007475509575);
  graph.addEdge("(33.5870946, -101.8743558)", "(33.5874856, -101.8743554)",
      47.42756217229315);
  graph.addEdge("(33.5874856, -101.8743554)", "(33.5875203, -101.8743546)",
      4.209826588640929);
  graph.addEdge("(33.5875203, -101.8743546)", "(33.5875586, -101.8743567)",
      4.650605228636232);
  graph.addEdge("(33.5875586, -101.8743567)", "(33.5875908, -101.8743429)",
      4.149451586438135);
  graph.addEdge("(33.5875908, -101.8743429)", "(33.5876059, -101.8743437)",
      1.8334006227113198);
  graph.addEdge("(33.5847935, -101.8727293)", "(33.5847923, -101.8726076)",
      12.356101920065033);
  graph.addEdge("(33.5848975, -101.8725974)", "(33.5849457, -101.8725681)",
      6.559765975203024);
  graph.addEdge("(33.5849457, -101.8725681)", "(33.5849962, -101.8725373)",
      6.877478844988514);
  graph.addEdge("(33.5849962, -101.8725373)", "(33.5850334, -101.8725022)",
      5.749667584178804);
  graph.addEdge("(33.5850722, -101.8727062)", "(33.585118, -101.8727999)",
      11.01600724806446);
  graph.addEdge("(33.585118, -101.8727999)", "(33.5851257, -101.8728331)",
      3.4975372418015085);
  graph.addEdge("(33.5851257, -101.8728331)", "(33.5851219, -101.8730855)",
      25.62823588601392);
  graph.addEdge("(33.5850335, -101.8724419)", "(33.58483, -101.8724418)",
      24.684149607260267);
  graph.addEdge("(33.58483, -101.8724418)", "(33.5847954, -101.8724422)",
      4.197107947302902);
  graph.addEdge("(33.58483, -101.8724418)", "(33.5849466, -101.8723078)",
      19.624011731805233);
  graph.addEdge("(33.5849466, -101.8723078)", "(33.5849894, -101.8722751)",
      6.162231916466501);
  graph.addEdge("(33.5849894, -101.8722751)", "(33.5850707, -101.8721714)",
      14.42514112481445);
  graph.addEdge("(33.5850707, -101.8721714)", "(33.585127, -101.8720642)",
      12.848305222435213);
  graph.addEdge("(33.585127, -101.8720642)", "(33.5851284, -101.8718292)",
      23.858215323260172);
  graph.addEdge("(33.5851284, -101.8718292)", "(33.5851266, -101.8716998)",
      13.138728575568697);
  graph.addEdge("(33.5851266, -101.8716998)", "(33.5851283, -101.8714335)",
      27.036028161244847);
  graph.addEdge("(33.5851283, -101.8714335)", "(33.5851288, -101.8713724)",
      6.203275275023375);
  graph.addEdge("(33.5851288, -101.8713724)", "(33.5851316, -101.8712851)",
      8.869353613310421);
  graph.addEdge("(33.5851316, -101.8712851)", "(33.5851283, -101.8710127)",
      27.657420426817925);
  graph.addEdge("(33.5851283, -101.8710127)", "(33.5851283, -101.8709558)",
      5.776587462675185);
  graph.addEdge("(33.5851283, -101.8709558)", "(33.5851528, -101.8709194)",
      4.7421008471746);
  graph.addEdge("(33.5851528, -101.8709194)", "(33.5851638, -101.870903)",
      2.1336300882153343);
  graph.addEdge("(33.5851638, -101.870903)", "(33.58528, -101.8707716)",
      19.406657193218866);
  graph.addEdge("(33.584786, -101.8718338)", "(33.5847862, -101.8717222)",
      11.329897778749212);
  graph.addEdge("(33.5847862, -101.8717222)", "(33.5847862, -101.8716327)",
      9.086232305142756);
  graph.addEdge("(33.5847862, -101.8716327)", "(33.5847817, -101.8716091)",
      2.45731325324167);
  graph.addEdge("(33.5847817, -101.8716091)", "(33.5847709, -101.8715534)",
      5.804544301703663);
  graph.addEdge("(33.5847709, -101.8715534)", "(33.5847422, -101.8714356)",
      12.455693304900361);
  graph.addEdge("(33.5847422, -101.8714356)", "(33.5847168, -101.8713624)",
      8.044778964268458);
  graph.addEdge("(33.5847168, -101.8713624)", "(33.5847033, -101.8713391)",
      2.8769640055812675);
  graph.addEdge("(33.5847033, -101.8713391)", "(33.5846744, -101.8712892)",
      6.160566469787861);
  graph.addEdge("(33.5846744, -101.8712892)", "(33.5846034, -101.8711883)",
      13.382849911558328);
  graph.addEdge("(33.5846034, -101.8711883)", "(33.5845971, -101.8711352)",
      5.444731206483069);
  graph.addEdge("(33.5845971, -101.8711352)", "(33.5845907, -101.8710745)",
      6.211113147843193);
  graph.addEdge("(33.5845907, -101.8710745)", "(33.5845945, -101.8708887)",
      18.868488178430937);
  graph.addEdge("(33.5845945, -101.8708887)", "(33.584596, -101.8708547)",
      3.456552669781073);
  graph.addEdge("(33.584596, -101.8708547)", "(33.5846109, -101.8708252)",
      3.4979942174758794);
  graph.addEdge("(33.5846109, -101.8708252)", "(33.5846199, -101.8708153)",
      1.4838928960721036);
  graph.addEdge("(33.5846199, -101.8708153)", "(33.5846406, -101.8708054)",
      2.7045573940302723);
  graph.addEdge("(33.5846406, -101.8708054)", "(33.5847054, -101.8708048)",
      7.860347535183932);
  graph.addEdge("(33.5847054, -101.8708048)", "(33.5848404, -101.8708034)",
      16.37584938904215);
  graph.addEdge("(33.5851288, -101.8713724)", "(33.5849073, -101.8713714)",
      26.867704099822884);
  graph.addEdge("(33.5849073, -101.8713714)", "(33.5847168, -101.8713624)",
      23.12533029969139);
  graph.addEdge("(33.5846944, -101.8717824)", "(33.5847514, -101.8716668)",
      13.621166765505823);
  graph.addEdge("(33.5847514, -101.8716668)", "(33.5847817, -101.8716091)",
      6.915360771110338);
  graph.addEdge("(33.5847817, -101.8716091)", "(33.5849073, -101.8713714)",
      28.53856829582697);
  graph.addEdge("(33.5849073, -101.8713714)", "(33.5850859, -101.871029)",
      40.95919222201165);
  graph.addEdge("(33.5850859, -101.871029)", "(33.5851283, -101.8709558)",
      9.037501626655883);
  graph.addEdge("(33.5846944, -101.8717824)", "(33.5846936, -101.8719117)",
      13.127186451770342);
  graph.addEdge("(33.5846041, -101.8719128)", "(33.5846031, -101.8719478)",
      3.555352453317619);
  graph.addEdge("(33.5846031, -101.8719478)", "(33.584358, -101.8723892)",
      53.77731711385848);
  graph.addEdge("(33.584358, -101.8723892)", "(33.5843577, -101.8724406)",
      5.218391104891286);
  graph.addEdge("(33.5843577, -101.8724406)", "(33.5843134, -101.8724406)",
      5.373501864304567);
  graph.addEdge("(33.5843134, -101.8724406)", "(33.5842646, -101.8724406)",
      5.919342868585314);
  graph.addEdge("(33.5842646, -101.8724406)", "(33.5841582, -101.8724312)",
      12.941342334630015);
  graph.addEdge("(33.5841582, -101.8724312)", "(33.5839787, -101.8724312)",
      21.77299194305992);
  graph.addEdge("(33.5839787, -101.8724312)", "(33.5838816, -101.8724307)",
      11.778145434630204);
  graph.addEdge("(33.5838816, -101.8724307)", "(33.5836763, -101.8724296)",
      24.902729715863956);
  graph.addEdge("(33.5836763, -101.8724296)", "(33.5831318, -101.8724353)",
      66.04929186476664);
  graph.addEdge("(33.5841528, -101.8732941)", "(33.5841531, -101.8732197)",
      7.553390690028319);
  graph.addEdge("(33.5841531, -101.8732197)", "(33.5841546, -101.8731414)",
      7.951324209545437);
  graph.addEdge("(33.5841546, -101.8731414)", "(33.5841569, -101.8727532)",
      39.412172159436444);
  graph.addEdge("(33.5841569, -101.8727532)", "(33.5841572, -101.872701)",
      5.299619554802131);
  graph.addEdge("(33.5841572, -101.872701)", "(33.5841576, -101.8726437)",
      5.8174636493397385);
  graph.addEdge("(33.5841576, -101.8726437)", "(33.5841582, -101.8724312)",
      21.573735708744792);
  graph.addEdge("(33.5841582, -101.8724312)", "(33.5841591, -101.8721314)",
      30.436756277162164);
  graph.addEdge("(33.5841591, -101.8721314)", "(33.5841595, -101.8720059)",
      12.74121417626693);
  graph.addEdge("(33.5841595, -101.8720059)", "(33.5841605, -101.8716678)",
      34.325100728810796);
  graph.addEdge("(33.5841605, -101.8716678)", "(33.584161, -101.8714947)",
      17.573715376675704);
  graph.addEdge("(33.584161, -101.8714947)", "(33.5841615, -101.8713407)",
      15.634641236370994);
  graph.addEdge("(33.5842646, -101.872702)", "(33.5841872, -101.8727013)",
      9.3887348083772);
  graph.addEdge("(33.5841872, -101.8727013)", "(33.5841572, -101.872701)",
      3.639067674319972);
  graph.addEdge("(33.5841572, -101.872701)", "(33.5838816, -101.8726986)",
      33.430617921859564);
  graph.addEdge("(33.5838816, -101.8726986)", "(33.583753, -101.8726974)",
      15.599398574183201);
  graph.addEdge("(33.5817983, -101.8807256)", "(33.5817925, -101.8811861)",
      46.75785531169678);
  graph.addEdge("(33.5817925, -101.8811861)", "(33.581791, -101.8813014)",
      11.707321987936984);
  graph.addEdge("(33.5815428, -101.8813481)", "(33.5815519, -101.88125)",
      10.020674694833888);
  graph.addEdge("(33.5815519, -101.88125)", "(33.5815494, -101.8812135)",
      3.7180836011623417);
  graph.addEdge("(33.5858087, -101.8757772)", "(33.5857814, -101.8757195)",
      6.7289643664934475);
  graph.addEdge("(33.5857814, -101.8757195)", "(33.5857713, -101.8753629)",
      36.22310801237626);
  graph.addEdge("(33.5857713, -101.8753629)", "(33.5857735, -101.8752317)",
      13.322227320232399);
  graph.addEdge("(33.5857735, -101.8752317)", "(33.5858058, -101.8751413)",
      9.978806658357831);
  graph.addEdge("(33.5866859, -101.8748456)", "(33.586402, -101.874541)",
      46.28290039921019);
  graph.addEdge("(33.587474, -101.8751287)", "(33.5874731, -101.8750398)",
      9.02569946256754);
  graph.addEdge("(33.5874731, -101.8750398)", "(33.5874746, -101.8749484)",
      9.28062041276367);
  graph.addEdge("(33.5874746, -101.8749484)", "(33.5874747, -101.8749339)",
      1.4720754765754085);
  graph.addEdge("(33.5841595, -101.8720059)", "(33.5841285, -101.871967)",
      5.45306286326136);
  graph.addEdge("(33.5841285, -101.871967)", "(33.5840975, -101.8718638)",
      11.131505815891593);
  graph.addEdge("(33.5840975, -101.8718638)", "(33.5840439, -101.871686)",
      19.185967903731353);
  graph.addEdge("(33.5840439, -101.871686)", "(33.5840366, -101.8716679)",
      2.039783843333285);
  graph.addEdge("(33.5840366, -101.8716679)", "(33.5839692, -101.8715016)",
      18.758568828322204);
  graph.addEdge("(33.5839692, -101.8715016)", "(33.5839042, -101.8713383)",
      18.358038004044467);
  graph.addEdge("(33.5839042, -101.8713383)", "(33.5838931, -101.8713103)",
      3.145388509017687);
  graph.addEdge("(33.5838931, -101.8713103)", "(33.5838569, -101.871225)",
      9.709539919764305);
  graph.addEdge("(33.5838569, -101.871225)", "(33.5838169, -101.8711309)",
      10.714821986202448);
  graph.addEdge("(33.5838169, -101.8711309)", "(33.5837492, -101.8710192)",
      14.00121439980198);
  graph.addEdge("(33.5837492, -101.8710192)", "(33.5836773, -101.8709092)",
      14.169553637815);
  graph.addEdge("(33.5836773, -101.8709092)", "(33.5836379, -101.8708381)",
      8.657038464690348);
  graph.addEdge("(33.5836379, -101.8708381)", "(33.5836237, -101.8708055)",
      3.731040140539816);
  graph.addEdge("(33.5836237, -101.8708055)", "(33.5836226, -101.8707693)",
      3.67757236313702);
  graph.addEdge("(33.5843009, -101.871339)", "(33.5842595, -101.8713355)",
      5.034293151834135);
  graph.addEdge("(33.5842595, -101.8713355)", "(33.5841615, -101.8713407)",
      11.898921624306107);
  graph.addEdge("(33.5841615, -101.8713407)", "(33.5839042, -101.8713383)",
      31.2109276633054);
  graph.addEdge("(33.584801, -101.8738469)", "(33.5848007, -101.8736496)",
      20.030349604335996);
  graph.addEdge("(33.5848007, -101.8736496)", "(33.5847982, -101.8732655)",
      38.99583043215622);
  graph.addEdge("(33.5847982, -101.8732655)", "(33.5847967, -101.8732007)",
      6.58114997842742);
  graph.addEdge("(33.5847967, -101.8732007)", "(33.5847962, -101.8731217)",
      8.020478107225687);
  graph.addEdge("(33.5847962, -101.8731217)", "(33.5846549, -101.8731205)",
      17.139842932130495);
  graph.addEdge("(33.5846549, -101.8731205)", "(33.5843111, -101.8731267)",
      41.70700700703978);
  graph.addEdge("(33.5843111, -101.8731267)", "(33.5842543, -101.8731208)",
      6.915715386159887);
  graph.addEdge("(33.5842543, -101.8731208)", "(33.5842432, -101.8731108)",
      1.6862685641907897);
  graph.addEdge("(33.5838468, -101.874625)", "(33.5838548, -101.8745509)",
      7.585199673054351);
  graph.addEdge("(33.5838548, -101.8745509)", "(33.5838689, -101.8744782)",
      7.576307749191999);
  graph.addEdge("(33.5838689, -101.8744782)", "(33.5838889, -101.8744075)",
      7.576577762771735);
  graph.addEdge("(33.5838889, -101.8744075)", "(33.5839115, -101.8743481)",
      6.624316776778775);
  graph.addEdge("(33.5839115, -101.8743481)", "(33.5839147, -101.8743395)",
      0.9554923134135216);
  graph.addEdge("(33.5839147, -101.8743395)", "(33.583946, -101.874275)",
      7.569271409677384);
  graph.addEdge("(33.583946, -101.874275)", "(33.5839825, -101.8742145)",
      7.5715026935012935);
  graph.addEdge("(33.5839825, -101.8742145)", "(33.5840238, -101.8741587)",
      7.562291081097815);
  graph.addEdge("(33.5840238, -101.8741587)", "(33.5840695, -101.8741081)",
      7.557632942408231);
  graph.addEdge("(33.5840695, -101.8741081)", "(33.5841192, -101.8740631)",
      7.564022650700156);
  graph.addEdge("(33.5841192, -101.8740631)", "(33.5841388, -101.8740481)",
      2.8233452708746634);
  graph.addEdge("(33.5841388, -101.8740481)", "(33.5841724, -101.8740244)",
      4.732853512589532);
  graph.addEdge("(33.5841724, -101.8740244)", "(33.5842006, -101.8740081)",
      3.7998641897546097);
  graph.addEdge("(33.5842006, -101.8740081)", "(33.5842285, -101.8739921)",
      3.753860576262745);
  graph.addEdge("(33.5842285, -101.8739921)", "(33.584287, -101.8739667)",
      7.549957241452392);
  graph.addEdge("(33.584287, -101.8739667)", "(33.5843473, -101.8739484)",
      7.546536261927594);
  graph.addEdge("(33.5843473, -101.8739484)", "(33.5844088, -101.8739374)",
      7.542954154604619);
  graph.addEdge("(33.5844088, -101.8739374)", "(33.584471, -101.8739338)",
      7.553583491375132);
  graph.addEdge("(33.584471, -101.8739338)", "(33.5845331, -101.8739376)",
      7.542479261341934);
  graph.addEdge("(33.5845331, -101.8739376)", "(33.5845946, -101.8739489)",
      7.547523292129073);
  graph.addEdge("(33.5845946, -101.8739489)", "(33.5846549, -101.8739674)",
      7.551559329822186);
  graph.addEdge("(33.5846549, -101.8739674)", "(33.5847127, -101.8739926)",
      7.463222431324398);
  graph.addEdge("(33.5847127, -101.8739926)", "(33.5847433, -101.8740103)",
      4.123816870962655);
  graph.addEdge("(33.5847433, -101.8740103)", "(33.5847682, -101.8740246)",
      3.351113999334404);
  graph.addEdge("(33.5847682, -101.8740246)", "(33.5848208, -101.874063)",
      7.4770203364230134);
  graph.addEdge("(33.5848208, -101.874063)", "(33.58487, -101.8741075)",
      7.485004432015901);
  graph.addEdge("(33.58487, -101.8741075)", "(33.5849153, -101.8741575)",
      7.480617254846509);
  graph.addEdge("(33.5849153, -101.8741575)", "(33.5849563, -101.8742126)",
      7.484930482822002);
  graph.addEdge("(33.5849563, -101.8742126)", "(33.5849926, -101.8742723)",
      7.491425993571752);
  graph.addEdge("(33.5849926, -101.8742723)", "(33.5850238, -101.8743359)",
      7.484156077740162);
  graph.addEdge("(33.5850238, -101.8743359)", "(33.585033, -101.8743544)",
      2.184671710323866);
  graph.addEdge("(33.585033, -101.8743544)", "(33.5850497, -101.874403)",
      5.333605477695723);
  graph.addEdge("(33.5850497, -101.874403)", "(33.5850699, -101.8744728)",
      7.497875941783748);
  graph.addEdge("(33.5850699, -101.8744728)", "(33.5850843, -101.8745446)",
      7.495620555013735);
  graph.addEdge("(33.5850843, -101.8745446)", "(33.5850928, -101.8746178)",
      7.502577327801482);
  graph.addEdge("(33.5850928, -101.8746178)", "(33.5850952, -101.8746917)",
      7.508106044036009);
  graph.addEdge("(33.5850952, -101.8746917)", "(33.5850916, -101.8747654)",
      7.494887542589075);
  graph.addEdge("(33.5850916, -101.8747654)", "(33.5850819, -101.8748384)",
      7.503908194330301);
  graph.addEdge("(33.5850819, -101.8748384)", "(33.5850663, -101.8749099)",
      7.501394716980391);
  graph.addEdge("(33.5850663, -101.8749099)", "(33.585045, -101.8749792)",
      7.494863356056951);
  graph.addEdge("(33.585045, -101.8749792)", "(33.5850321, -101.8750109)",
      3.578478974307336);
  graph.addEdge("(33.5850321, -101.8750109)", "(33.585018, -101.8750456)",
      3.9160331477325183);
  graph.addEdge("(33.585018, -101.8750456)", "(33.5849858, -101.8751086)",
      7.494165675172497);
  graph.addEdge("(33.5849858, -101.8751086)", "(33.5849485, -101.8751674)",
      7.49033723489741);
  graph.addEdge("(33.5849485, -101.8751674)", "(33.5849066, -101.8752215)",
      7.483077560007266);
  graph.addEdge("(33.5849066, -101.8752215)", "(33.5848605, -101.8752705)",
      7.484323892863891);
  graph.addEdge("(33.5848605, -101.8752705)", "(33.5848114, -101.875313)",
      7.354406365170573);
  graph.addEdge("(33.5848114, -101.875313)", "(33.5847592, -101.8753497)",
      7.346645224564201);
  graph.addEdge("(33.5847592, -101.8753497)", "(33.5847361, -101.8753625)",
      3.088652538121634);
  graph.addEdge("(33.5847361, -101.8753625)", "(33.5847042, -101.8753802)",
      4.266299848384097);
  graph.addEdge("(33.5847042, -101.8753802)", "(33.5846471, -101.8754041)",
      7.338829977496354);
  graph.addEdge("(33.5846471, -101.8754041)", "(33.5845883, -101.8754212)",
      7.340561546095334);
  graph.addEdge("(33.5845883, -101.8754212)", "(33.5845283, -101.8754315)",
      7.35261849777717);
  graph.addEdge("(33.5845283, -101.8754315)", "(33.5844679, -101.8754348)",
      7.334056078939506);
  graph.addEdge("(33.5844679, -101.8754348)", "(33.5844074, -101.875431)",
      7.34866311617685);
  graph.addEdge("(33.5844074, -101.875431)", "(33.5843476, -101.8754202)",
      7.336021333778665);
  graph.addEdge("(33.5843476, -101.8754202)", "(33.5842889, -101.8754026)",
      7.340967476185614);
  graph.addEdge("(33.5842889, -101.8754026)", "(33.5842319, -101.8753782)",
      7.34435216102038);
  graph.addEdge("(33.5842319, -101.8753782)", "(33.5841948, -101.87536)",
      4.864715493111899);
  graph.addEdge("(33.5841948, -101.87536)", "(33.5841771, -101.8753473)",
      2.5043759095656353);
  graph.addEdge("(33.5841771, -101.8753473)", "(33.584125, -101.8753102)",
      7.356914560223908);
  graph.addEdge("(33.584125, -101.8753102)", "(33.584079, -101.8752696)",
      6.937048473856738);
  graph.addEdge("(33.584079, -101.8752696)", "(33.5840762, -101.8752672)",
      0.41799445852961475);
  graph.addEdge("(33.5840762, -101.8752672)", "(33.5840311, -101.8752187)",
      7.3601129562479395);
  graph.addEdge("(33.5840311, -101.8752187)", "(33.5839901, -101.8751653)",
      7.356883266335527);
  graph.addEdge("(33.5839901, -101.8751653)", "(33.5839536, -101.8751073)",
      7.367103595497758);
  graph.addEdge("(33.5839536, -101.8751073)", "(33.583922, -101.8750454)",
      7.360993480024501);
  graph.addEdge("(33.583922, -101.8750454)", "(33.5838955, -101.8749801)",
      7.3676409745696);
  graph.addEdge("(33.5838955, -101.8749801)", "(33.5838743, -101.874912)",
      7.376473975415095);
  graph.addEdge("(33.5838743, -101.874912)", "(33.5838588, -101.8748418)",
      7.370751999442223);
  graph.addEdge("(33.5838588, -101.8748418)", "(33.583849, -101.8747701)",
      7.3756387346700745);
  graph.addEdge("(33.583849, -101.8747701)", "(33.583845, -101.8746976)",
      7.376409853289311);
  graph.addEdge("(33.583845, -101.8746976)", "(33.5838454, -101.8746817)",
      1.614948701478742);
  graph.addEdge("(33.5872188, -101.8787488)", "(33.5872213, -101.8787328)",
      1.6523730280108895);
  graph.addEdge("(33.5872213, -101.8787328)", "(33.5873581, -101.8786764)",
      17.553638145324616);
  graph.addEdge("(33.5873581, -101.8786764)", "(33.5873628, -101.8786867)",
      1.1909630055244675);
  graph.addEdge("(33.5873628, -101.8786867)", "(33.5873725, -101.8786966)",
      1.547407870845358);
  graph.addEdge("(33.5873725, -101.8786966)", "(33.5873846, -101.8787019)",
      1.5632216759831044);
  graph.addEdge("(33.5873846, -101.8787019)", "(33.5874005, -101.8786958)",
      2.025621043342245);
  graph.addEdge("(33.5874005, -101.8786958)", "(33.5874118, -101.8786823)",
      1.9383039894281122);
  graph.addEdge("(33.5874118, -101.8786823)", "(33.5874141, -101.8786633)",
      1.9489338129715077);
  graph.addEdge("(33.5874141, -101.8786633)", "(33.5874479, -101.8786636)",
      4.099987928079501);
  graph.addEdge("(33.5874479, -101.8786636)", "(33.5877619, -101.8786685)",
      38.09084373205129);
  graph.addEdge("(33.5877619, -101.8786685)", "(33.5878967, -101.8786625)",
      16.36232252982989);
  graph.addEdge("(33.5878967, -101.8786625)", "(33.5879696, -101.8786593)",
      8.848595412009272);
  graph.addEdge("(33.5879696, -101.8786593)", "(33.5880844, -101.8786609)",
      13.925967229548693);
  graph.addEdge("(33.5872187, -101.8787792)", "(33.587333, -101.878989)",
      25.413713804030774);
  graph.addEdge("(33.587333, -101.878989)", "(33.5873482, -101.8789824)",
      1.9617028730095827);
  graph.addEdge("(33.5873482, -101.8789824)", "(33.5873837, -101.8789824)",
      4.306081484292281);
  graph.addEdge("(33.5873837, -101.8789824)", "(33.5875331, -101.8789824)",
      18.121931929889964);
  graph.addEdge("(33.5875331, -101.8789824)", "(33.5875331, -101.8790181)",
      3.624225861253286);
  graph.addEdge("(33.5875331, -101.8790181)", "(33.5875544, -101.8790181)",
      2.5836489659660105);
  graph.addEdge("(33.5875544, -101.8790181)", "(33.5875544, -101.8791243)",
      10.781307897064293);
  graph.addEdge("(33.5875544, -101.8791243)", "(33.5875544, -101.8792557)",
      13.339584346701344);
  graph.addEdge("(33.5875544, -101.8792557)", "(33.5875531, -101.8793838)",
      13.005528039748366);
  graph.addEdge("(33.5875531, -101.8793838)", "(33.587552, -101.8794894)",
      10.721227081999514);
  graph.addEdge("(33.587552, -101.8794894)", "(33.5875293, -101.8794894)",
      2.7534662672822594);
  graph.addEdge("(33.5875293, -101.8794894)", "(33.5875289, -101.8795229)",
      3.401230454579125);
  graph.addEdge("(33.5875289, -101.8795229)", "(33.5873819, -101.8795229)",
      17.830816549122986);
  graph.addEdge("(33.5873819, -101.8795229)", "(33.5873359, -101.8795229)",
      5.57971121396753);
  graph.addEdge("(33.5811021, -101.8797477)", "(33.5811511, -101.8798268)",
      9.99095462162351);
  graph.addEdge("(33.5811511, -101.8798268)", "(33.5811966, -101.8799002)",
      9.273231906408963);
  graph.addEdge("(33.5811966, -101.8799002)", "(33.5812835, -101.8800052)",
      14.991646696354021);
  graph.addEdge("(33.5812835, -101.8800052)", "(33.5813153, -101.8800462)",
      5.674998151166673);
  graph.addEdge("(33.5813153, -101.8800462)", "(33.5813409, -101.8800839)",
      4.928740490535509);
  graph.addEdge("(33.5813409, -101.8800839)", "(33.5813637, -101.880125)",
      5.006010899005415);
  graph.addEdge("(33.5813637, -101.880125)", "(33.5813832, -101.8801601)",
      4.277114263779398);
  graph.addEdge("(33.5813832, -101.8801601)", "(33.5814394, -101.8802611)",
      12.31332804072672);
  graph.addEdge("(33.5814394, -101.8802611)", "(33.5814905, -101.8803531)",
      11.20991643569219);
  graph.addEdge("(33.5814905, -101.8803531)", "(33.5815246, -101.8803954)",
      5.962533238984802);
  graph.addEdge("(33.5815271, -101.881172)", "(33.5815251, -101.8808994)",
      27.677041661187694);
  graph.addEdge("(33.5815251, -101.8808994)", "(33.5815251, -101.8808665)",
      3.3402043331853375);
  graph.addEdge("(33.5815251, -101.8808665)", "(33.5815251, -101.8808429)",
      2.3960128333173176);
  graph.addEdge("(33.5815251, -101.8808429)", "(33.5815248, -101.8804733)",
      37.5240153157092);
  graph.addEdge("(33.5815248, -101.8804733)", "(33.5815248, -101.8804511)",
      2.253876487771057);
  graph.addEdge("(33.5815248, -101.8804511)", "(33.5815246, -101.8803954)",
      5.655048454894409);
  graph.addEdge("(33.5815246, -101.8803954)", "(33.5815242, -101.8802994)",
      9.746613729708326);
  graph.addEdge("(33.5815242, -101.8802994)", "(33.5815254, -101.8801916)",
      10.94546722552336);
  graph.addEdge("(33.5815254, -101.8801916)", "(33.5815301, -101.8801118)",
      8.121805427735639);
  graph.addEdge("(33.5815301, -101.8801118)", "(33.5815396, -101.8800484)",
      6.53907943859782);
  graph.addEdge("(33.5815396, -101.8800484)", "(33.5815553, -101.8799897)",
      6.256449687629624);
  graph.addEdge("(33.5815553, -101.8799897)", "(33.581571, -101.879942)",
      5.203771377316067);
  graph.addEdge("(33.581571, -101.879942)", "(33.5815841, -101.8799021)",
      4.351389392947587);
  graph.addEdge("(33.5815841, -101.8799021)", "(33.5816102, -101.8798533)",
      5.879581591922306);
  graph.addEdge("(33.5816102, -101.8798533)", "(33.5816695, -101.8797732)",
      10.856877594889754);
  graph.addEdge("(33.5816695, -101.8797732)", "(33.5816869, -101.8797532)",
      2.928747360281797);
  graph.addEdge("(33.5814896, -101.881132)", "(33.5814673, -101.8810709)",
      6.767341432105795);
  graph.addEdge("(33.5814673, -101.8810709)", "(33.5814543, -101.880991)",
      8.263773436971606);
  graph.addEdge("(33.5814543, -101.880991)", "(33.5814457, -101.880911)",
      8.188799877453267);
  graph.addEdge("(33.5814457, -101.880911)", "(33.5814378, -101.8808373)",
      7.543581556767978);
  graph.addEdge("(33.5814378, -101.8808373)", "(33.5814376, -101.8805417)",
      30.011116065922547);
  graph.addEdge("(33.5814376, -101.8805417)", "(33.5814375, -101.8804025)",
      14.132434158389911);
  graph.addEdge("(33.5814375, -101.8804025)", "(33.5814374, -101.8803712)",
      3.177789147321962);
  graph.addEdge("(33.5814374, -101.8803712)", "(33.5814394, -101.8802611)",
      11.180652417461758);
  graph.addEdge("(33.5814394, -101.8802611)", "(33.5814413, -101.8801525)",
      11.028139257967638);
  graph.addEdge("(33.5814413, -101.8801525)", "(33.5814488, -101.8800768)",
      7.7391781504998125);
  graph.addEdge("(33.5814488, -101.8800768)", "(33.5814561, -101.8800316)",
      4.673626140947216);
  graph.addEdge("(33.5814561, -101.8800316)", "(33.581457, -101.8800282)",
      0.3620398184566077);
  graph.addEdge("(33.581457, -101.8800282)", "(33.5814671, -101.8799901)",
      4.057513621880914);
  graph.addEdge("(33.5814671, -101.8799901)", "(33.5814832, -101.8799496)",
      4.552003901025584);
  graph.addEdge("(33.5814832, -101.8799496)", "(33.5815096, -101.8799026)",
      5.746637187132939);
  graph.addEdge("(33.5815096, -101.8799026)", "(33.5815391, -101.8798616)",
      5.4891804461171105);
  graph.addEdge("(33.5815391, -101.8798616)", "(33.5816141, -101.8797918)",
      11.531709225691538);
  graph.addEdge("(33.5816141, -101.8797918)", "(33.5816497, -101.8797528)",
      5.858721416081323);
  graph.addEdge("(33.5816497, -101.8797528)", "(33.5816737, -101.8796943)",
      6.6143485250507705);
  graph.addEdge("(33.5816737, -101.8796943)", "(33.5816785, -101.8792445)",
      45.67001214046076);
  graph.addEdge("(33.5816785, -101.8792445)", "(33.5816775, -101.8789127)",
      33.68647501081632);
  graph.addEdge("(33.5816775, -101.8789127)", "(33.5816772, -101.878814)",
      10.02066147317791);
  graph.addEdge("(33.5806257, -101.8788659)", "(33.5808614, -101.8788653)",
      28.589989350762377);
  graph.addEdge("(33.5808614, -101.8788653)", "(33.5809811, -101.878865)",
      14.519395780575145);
  graph.addEdge("(33.5809811, -101.878865)", "(33.5809931, -101.878865)",
      1.455575337030917);
  graph.addEdge("(33.5809931, -101.878865)", "(33.581005, -101.8788637)",
      1.449467132183886);
  graph.addEdge("(33.581005, -101.8788637)", "(33.5810168, -101.8788612)",
      1.4536462994277122);
  graph.addEdge("(33.5810168, -101.8788612)", "(33.5810283, -101.8788575)",
      1.444621472665198);
  graph.addEdge("(33.5810283, -101.8788575)", "(33.5810396, -101.8788525)",
      1.46164920908752);
  graph.addEdge("(33.5810396, -101.8788525)", "(33.5810504, -101.8788465)",
      1.444721974174377);
  graph.addEdge("(33.5810504, -101.8788465)", "(33.5810607, -101.8788393)",
      1.4475048343955352);
  graph.addEdge("(33.5810607, -101.8788393)", "(33.5810705, -101.878831)",
      1.4571024867795428);
  graph.addEdge("(33.5810705, -101.878831)", "(33.5810797, -101.8788218)",
      1.4552533414158195);
  graph.addEdge("(33.5810797, -101.8788218)", "(33.5810882, -101.8788117)",
      1.4541351872693271);
  graph.addEdge("(33.5810882, -101.8788117)", "(33.5810906, -101.8788083)",
      0.4515574586918491);
  graph.addEdge("(33.5810906, -101.8788083)", "(33.5810959, -101.8788007)",
      1.0043216457114725);
  graph.addEdge("(33.5810959, -101.8788007)", "(33.5811011, -101.8787917)",
      1.110298254717546);
  graph.addEdge("(33.5811011, -101.8787917)", "(33.5811027, -101.8787889)",
      0.34420565615186605);
  graph.addEdge("(33.5811027, -101.8787889)", "(33.5811087, -101.8787765)",
      1.4541577766982638);
  graph.addEdge("(33.5811087, -101.8787765)", "(33.5811138, -101.8787635)",
      1.457627520096939);
  graph.addEdge("(33.5811138, -101.8787635)", "(33.5811179, -101.87875)",
      1.4580440304595021);
  graph.addEdge("(33.5811179, -101.87875)", "(33.581121, -101.8787361)",
      1.4604549823276147);
  graph.addEdge("(33.581121, -101.8787361)", "(33.5811231, -101.878722)",
      1.4540091800315236);
  graph.addEdge("(33.5811231, -101.878722)", "(33.5811241, -101.8787077)",
      1.4568863726255543);
  graph.addEdge("(33.5811241, -101.8787077)", "(33.5811263, -101.8781152)",
      60.15500513338568);
  graph.addEdge("(33.5811263, -101.8781152)", "(33.5811272, -101.8778683)",
      25.067114273150178);
  graph.addEdge("(33.5811272, -101.8778683)", "(33.5811335, -101.8776689)",
      20.258787905011534);
  graph.addEdge("(33.5811335, -101.8776689)", "(33.5811338, -101.8774263)",
      24.630337812726054);
  graph.addEdge("(33.5811338, -101.8774263)", "(33.5811348, -101.8771728)",
      25.73723461675939);
  graph.addEdge("(33.5811348, -101.8771728)", "(33.5811344, -101.8770484)",
      12.62998044206496);
  graph.addEdge("(33.5798438, -101.8792416)", "(33.580013, -101.8792421)",
      20.523671517789694);
  graph.addEdge("(33.580013, -101.8792421)", "(33.5800802, -101.8792423)",
      8.15124593845251);
  graph.addEdge("(33.580906, -101.8792443)", "(33.5811016, -101.8792442)",
      23.725880231176056);
  graph.addEdge("(33.5816785, -101.8792445)", "(33.5818696, -101.8792446)",
      23.18004242006671);
  graph.addEdge("(33.5811019, -101.8795374)", "(33.5808626, -101.8795378)",
      29.026626568239827);
  graph.addEdge("(33.5808626, -101.8795378)", "(33.5806247, -101.8795382)",
      28.85680849851225);
  graph.addEdge("(33.5811503, -101.8803463)", "(33.581151, -101.8799055)",
      44.752920322121106);
  graph.addEdge("(33.581151, -101.8799055)", "(33.5811511, -101.8798268)",
      7.990137324646591);
  graph.addEdge("(33.5811511, -101.8798268)", "(33.5811512, -101.8797479)",
      8.010442573415546);
  graph.addEdge("(33.5808629, -101.8792935)", "(33.5808626, -101.8795378)",
      24.8030100440199);
  graph.addEdge("(33.5808626, -101.8795378)", "(33.5808624, -101.8797466)",
      21.198797912380364);
  graph.addEdge("(33.5808624, -101.8797466)", "(33.5808625, -101.8798529)",
      10.792299650263926);
  graph.addEdge("(33.5808613, -101.8788096)", "(33.5808614, -101.8788653)",
      5.655052693939261);
  graph.addEdge("(33.5808614, -101.8788653)", "(33.5808615, -101.878947)",
      8.294743908006142);
  graph.addEdge("(33.5808615, -101.878947)", "(33.5808628, -101.8791958)",
      25.260346055780815);
  graph.addEdge("(33.5815246, -101.8803954)", "(33.5814752, -101.8803958)",
      5.992256580424942);
  graph.addEdge("(33.5814752, -101.8803958)", "(33.5814375, -101.8804025)",
      4.623247818146416);
  graph.addEdge("(33.5814375, -101.8804025)", "(33.5811195, -101.8804585)",
      38.98950475530209);
  graph.addEdge("(33.5811183, -101.8811958)", "(33.5813724, -101.8809748)",
      38.12370454515102);
  graph.addEdge("(33.5813724, -101.8809748)", "(33.5814457, -101.880911)",
      11.000392370111367);
  graph.addEdge("(33.5814457, -101.880911)", "(33.5815251, -101.8808429)",
      11.855782622126586);
  graph.addEdge("(33.5815251, -101.8808429)", "(33.5816554, -101.8807311)",
      19.458621106511668);
  graph.addEdge("(33.5816554, -101.8807311)", "(33.5816908, -101.8807295)",
      4.297019220847316);
  graph.addEdge("(33.5816908, -101.8807295)", "(33.5817983, -101.8807256)",
      13.045540866651761);
  graph.addEdge("(33.5817983, -101.8807256)", "(33.5818552, -101.8807242)",
      6.903317402261437);
  graph.addEdge("(33.5811429, -101.8789483)", "(33.5811013, -101.8789481)",
      5.046035466817673);
  graph.addEdge("(33.5811013, -101.8789481)", "(33.5808615, -101.878947)",
      29.08746152068664);
  graph.addEdge("(33.5808615, -101.878947)", "(33.5806256, -101.878946)",
      28.614364156740365);
  graph.addEdge("(33.5806256, -101.878946)", "(33.5805759, -101.878946)",
      6.028507478032229);
  graph.addEdge("(33.5811184, -101.8811514)", "(33.5812794, -101.8808439)",
      36.824294014002554);
  graph.addEdge("(33.5812794, -101.8808439)", "(33.5814376, -101.8805417)",
      36.187940530151465);
  graph.addEdge("(33.5814376, -101.8805417)", "(33.5814863, -101.8804486)",
      11.146158350508898);
  graph.addEdge("(33.5814863, -101.8804486)", "(33.5815246, -101.8803954)",
      7.1242832255862565);
  graph.addEdge("(33.5811202, -101.8812141)", "(33.5811183, -101.8811958)",
      1.8721733386117103);
  graph.addEdge("(33.5811183, -101.8811958)", "(33.5811184, -101.8811514)",
      4.5077904272873806);
  graph.addEdge("(33.5811184, -101.8811514)", "(33.5811192, -101.8806185)",
      54.1035286670957);
  graph.addEdge("(33.5811192, -101.8806185)", "(33.5811193, -101.8805624)",
      5.695646356334714);
  graph.addEdge("(33.5811193, -101.8805624)", "(33.5811194, -101.8805008)",
      6.2540406327286995);
  graph.addEdge("(33.5811194, -101.8805008)", "(33.5811195, -101.8804585)",
      4.294585649160377);
  graph.addEdge("(33.5811195, -101.8804585)", "(33.5811196, -101.8803781)",
      8.162734984870914);
  graph.addEdge("(33.5811011, -101.8787917)", "(33.5811011, -101.8788083)",
      1.6853393041010183);
  graph.addEdge("(33.5811011, -101.8788083)", "(33.5811013, -101.8789481)",
      14.193420389618685);
  graph.addEdge("(33.5811013, -101.8789481)", "(33.5811016, -101.8792442)",
      30.06200790689102);
  graph.addEdge("(33.5811016, -101.8792442)", "(33.5811019, -101.8795374)",
      29.767581277358186);
  graph.addEdge("(33.5811019, -101.8795374)", "(33.5811021, -101.8797477)",
      21.351028948603936);
  graph.addEdge("(33.5811021, -101.8797477)", "(33.5811027, -101.8799046)",
      15.929668225805688);
  graph.addEdge("(33.5806243, -101.8797455)", "(33.5806247, -101.8795382)",
      21.046607613522);
  graph.addEdge("(33.5806247, -101.8795382)", "(33.5806251, -101.8792438)",
      29.889594557171574);
  graph.addEdge("(33.5806251, -101.8792438)", "(33.5806256, -101.878946)",
      30.23480772239364);
  graph.addEdge("(33.5806256, -101.878946)", "(33.5806257, -101.8788659)",
      8.132323411330965);
  graph.addEdge("(33.5806257, -101.8788659)", "(33.5806259, -101.8787359)",
      13.198534973966108);
  graph.addEdge("(33.5818691, -101.8797549)", "(33.5816869, -101.8797532)",
      22.101162288305936);
  graph.addEdge("(33.5816869, -101.8797532)", "(33.5816497, -101.8797528)",
      4.51246678440682);
  graph.addEdge("(33.5816497, -101.8797528)", "(33.5811512, -101.8797479)",
      60.469075916656315);
  graph.addEdge("(33.5811512, -101.8797479)", "(33.5811021, -101.8797477)",
      5.955763836535168);
  graph.addEdge("(33.5811021, -101.8797477)", "(33.5808624, -101.8797466)",
      29.075331820090135);
  graph.addEdge("(33.5808624, -101.8797466)", "(33.5806243, -101.8797455)",
      28.881255435083403);
  graph.addEdge("(33.5806243, -101.8797455)", "(33.5803814, -101.8797404)",
      29.46781793865096);
  graph.addEdge("(33.5803814, -101.8797404)", "(33.5800148, -101.8797364)",
      44.46967526813627);
  graph.addEdge("(33.5800148, -101.8797364)", "(33.5798952, -101.8797351)",
      14.5078321613575);
  graph.addEdge("(33.5808629, -101.8792935)", "(33.580859, -101.879293)",
      0.4757778386158736);
  graph.addEdge("(33.580859, -101.879293)", "(33.5808552, -101.879292)",
      0.4719810974515228);
  graph.addEdge("(33.5808552, -101.879292)", "(33.5808515, -101.8792907)",
      0.46780718591026693);
  graph.addEdge("(33.5808515, -101.8792907)", "(33.5808479, -101.8792889)",
      0.4733707258261845);
  graph.addEdge("(33.5808479, -101.8792889)", "(33.5808444, -101.8792867)",
      0.479714264150767);
  graph.addEdge("(33.5808444, -101.8792867)", "(33.5808412, -101.8792841)",
      0.4694070926404047);
  graph.addEdge("(33.5808412, -101.8792841)", "(33.5808382, -101.8792812)",
      0.46808796912370265);
  graph.addEdge("(33.5808382, -101.8792812)", "(33.5808354, -101.8792779)",
      0.47707663163538916);
  graph.addEdge("(33.5808354, -101.8792779)", "(33.5808329, -101.8792744)",
      0.46714730037437147);
  graph.addEdge("(33.5808329, -101.8792744)", "(33.5808307, -101.8792705)",
      0.47748482639824397);
  graph.addEdge("(33.5808307, -101.8792705)", "(33.5808288, -101.8792665)",
      0.4669449838523897);
  graph.addEdge("(33.5808288, -101.8792665)", "(33.5808272, -101.8792622)",
      0.4777603121425544);
  graph.addEdge("(33.5808272, -101.8792622)", "(33.580826, -101.8792578)",
      0.4698338391694956);
  graph.addEdge("(33.580826, -101.8792578)", "(33.5808251, -101.8792532)",
      0.47961273244109054);
  graph.addEdge("(33.5808251, -101.8792532)", "(33.5808246, -101.8792486)",
      0.47094478134891826);
  graph.addEdge("(33.5808246, -101.8792486)", "(33.5808245, -101.8792439)",
      0.4773300466961882);
  graph.addEdge("(33.5808245, -101.8792439)", "(33.5808248, -101.8792391)",
      0.48868531099990176);
  graph.addEdge("(33.5808248, -101.8792391)", "(33.5808254, -101.8792343)",
      0.4927330852327013);
  graph.addEdge("(33.5808254, -101.8792343)", "(33.5808265, -101.8792296)",
      0.49547935990475245);
  graph.addEdge("(33.5808265, -101.8792296)", "(33.5808279, -101.879225)",
      0.4969391641068414);
  graph.addEdge("(33.5808279, -101.879225)", "(33.5808297, -101.8792206)",
      0.4972198418625117);
  graph.addEdge("(33.5808297, -101.8792206)", "(33.5808319, -101.8792165)",
      0.49445329753513373);
  graph.addEdge("(33.5808319, -101.8792165)", "(33.5808344, -101.8792127)",
      0.49071421139639926);
  graph.addEdge("(33.5808344, -101.8792127)", "(33.5808372, -101.8792091)",
      0.498937896137657);
  graph.addEdge("(33.5808372, -101.8792091)", "(33.5808403, -101.879206)",
      0.4903576429174151);
  graph.addEdge("(33.5808403, -101.879206)", "(33.5808436, -101.8792032)",
      0.49095711849072926);
  graph.addEdge("(33.5808436, -101.8792032)", "(33.5808472, -101.8792008)",
      0.5000552083191322);
  graph.addEdge("(33.5808472, -101.8792008)", "(33.5808509, -101.8791988)",
      0.4925995460834068);
  graph.addEdge("(33.5808509, -101.8791988)", "(33.5808547, -101.8791974)",
      0.48235000913810183);
  graph.addEdge("(33.5808547, -101.8791974)", "(33.5808587, -101.8791963)",
      0.4978788472856124);
  graph.addEdge("(33.5808587, -101.8791963)", "(33.5808628, -101.8791958)",
      0.4999056489000214);
  graph.addEdge("(33.5808628, -101.8791958)", "(33.5808667, -101.8791957)",
      0.47317091031670205);
  graph.addEdge("(33.5808667, -101.8791957)", "(33.5808705, -101.8791961)",
      0.4627177365803332);
  graph.addEdge("(33.5808705, -101.8791961)", "(33.5808744, -101.8791969)",
      0.4799839020959644);
  graph.addEdge("(33.5808744, -101.8791969)", "(33.5808781, -101.8791982)",
      0.46780717876181305);
  graph.addEdge("(33.5808781, -101.8791982)", "(33.5808818, -101.8791999)",
      0.48084588549565677);
  graph.addEdge("(33.5808818, -101.8791999)", "(33.5808852, -101.879202)",
      0.464264292087398);
  graph.addEdge("(33.5808852, -101.879202)", "(33.5808885, -101.8792045)",
      0.4739721615768371);
  graph.addEdge("(33.5808885, -101.8792045)", "(33.5808916, -101.8792073)",
      0.471387231488346);
  graph.addEdge("(33.5808916, -101.8792073)", "(33.5808945, -101.8792105)",
      0.47884078703753596);
  graph.addEdge("(33.5808945, -101.8792105)", "(33.5808971, -101.879214)",
      0.47511067077484825);
  graph.addEdge("(33.5808971, -101.879214)", "(33.5808993, -101.8792178)",
      0.46909979254804246);
  graph.addEdge("(33.5808993, -101.8792178)", "(33.5809013, -101.8792218)",
      0.47304914489156186);
  graph.addEdge("(33.5809013, -101.8792218)", "(33.580903, -101.8792261)",
      0.48281460585994745);
  graph.addEdge("(33.580903, -101.8792261)", "(33.5809043, -101.8792305)",
      0.4737317614572335);
  graph.addEdge("(33.5809043, -101.8792305)", "(33.5809052, -101.879235)",
      0.46973183096069815);
  graph.addEdge("(33.5809052, -101.879235)", "(33.5809058, -101.8792397)",
      0.48269365702292005);
  graph.addEdge("(33.5809058, -101.8792397)", "(33.580906, -101.8792443)",
      0.467652445867586);
  graph.addEdge("(33.580906, -101.8792443)", "(33.5809058, -101.879249)",
      0.4777917364528309);
  graph.addEdge("(33.5809058, -101.879249)", "(33.5809053, -101.8792537)",
      0.48101425550978144);
  graph.addEdge("(33.5809053, -101.8792537)", "(33.5809044, -101.8792583)",
      0.47961231497082285);
  graph.addEdge("(33.5809044, -101.8792583)", "(33.5809031, -101.8792627)",
      0.4737317606864972);
  graph.addEdge("(33.5809031, -101.8792627)", "(33.5809015, -101.879267)",
      0.47775997102353945);
  graph.addEdge("(33.5809015, -101.879267)", "(33.5808995, -101.8792711)",
      0.4817932202447852);
  graph.addEdge("(33.5808995, -101.8792711)", "(33.5808973, -101.8792749)",
      0.4690997933261423);
  graph.addEdge("(33.5808973, -101.8792749)", "(33.5808947, -101.8792785)",
      0.48275106903921516);
  graph.addEdge("(33.5808947, -101.8792785)", "(33.5808918, -101.8792817)",
      0.47884078974587724);
  graph.addEdge("(33.5808918, -101.8792817)", "(33.5808888, -101.8792846)",
      0.46808786339515424);
  graph.addEdge("(33.5808888, -101.8792846)", "(33.5808855, -101.8792871)",
      0.47397216274349635);
  graph.addEdge("(33.5808855, -101.8792871)", "(33.580882, -101.8792892)",
      0.47507203005473875);
  graph.addEdge("(33.580882, -101.8792892)", "(33.5808783, -101.879291)",
      0.48458275975944826);
  graph.addEdge("(33.5808783, -101.879291)", "(33.5808745, -101.8792923)",
      0.4794564113589758);
  graph.addEdge("(33.5808745, -101.8792923)", "(33.5808707, -101.8792931)",
      0.4680335341321817);
  graph.addEdge("(33.5808707, -101.8792931)", "(33.5808668, -101.8792935)",
      0.47480191841767533);
  graph.addEdge("(33.5811196, -101.8803781)", "(33.5811503, -101.8803463)",
      4.9285402373658584);
  graph.addEdge("(33.5811503, -101.8803463)", "(33.5813637, -101.880125)",
      34.27583455603145);
  graph.addEdge("(33.5813637, -101.880125)", "(33.581457, -101.8800282)",
      14.98869379450592);
  graph.addEdge("(33.581457, -101.8800282)", "(33.581503, -101.8799805)",
      7.388216586493083);
  graph.addEdge("(33.581503, -101.8799805)", "(33.5815302, -101.8799587)",
      3.9729028623837817);
  graph.addEdge("(33.5815302, -101.8799587)", "(33.5815547, -101.8799448)",
      3.28984958265138);
  graph.addEdge("(33.5815547, -101.8799448)", "(33.581571, -101.879942)",
      1.9974882852593785);
  graph.addEdge("(33.581571, -101.879942)", "(33.5816314, -101.8799391)",
      7.332310219966949);
  graph.addEdge("(33.5816314, -101.8799391)", "(33.5818689, -101.8799345)",
      28.81205066728719);
  graph.addEdge("(33.5818689, -101.8799345)", "(33.5819306, -101.8799333)",
      7.485075849452195);
  graph.addEdge("(33.5819306, -101.8799333)", "(33.5819719, -101.8799056)",
      5.744991919187663);
  graph.addEdge("(33.5819719, -101.8799056)", "(33.5820575, -101.8798444)",
      12.100192375548382);
  graph.addEdge("(33.5820575, -101.8798444)", "(33.582121, -101.879804)",
      8.726430743970884);
  graph.addEdge("(33.582121, -101.879804)", "(33.5821624, -101.8797925)",
      5.155674676951859);
  graph.addEdge("(33.5821624, -101.8797925)", "(33.5823201, -101.8797948)",
      19.130114955824258);
  graph.addEdge("(33.5823201, -101.8797948)", "(33.5825183, -101.8797959)",
      24.041517608733987);
  graph.addEdge("(33.5825183, -101.8797959)", "(33.5825332, -101.8797928)",
      1.8345381587198304);
  graph.addEdge("(33.5825332, -101.8797928)", "(33.582579, -101.8797864)",
      5.593315703165941);
  graph.addEdge("(33.582579, -101.8797864)", "(33.5826293, -101.879786)",
      6.101423365037384);
  graph.addEdge("(33.5826293, -101.879786)", "(33.5826731, -101.8797856)",
      5.313006614395104);
  graph.addEdge("(33.5826731, -101.8797856)", "(33.582726, -101.8797856)",
      6.41666305642076);
  graph.addEdge("(33.582726, -101.8797856)", "(33.5827674, -101.8797856)",
      5.0217363439672305);
  graph.addEdge("(33.5827674, -101.8797856)", "(33.5828097, -101.8797682)",
      5.4264902142533025);
  graph.addEdge("(33.5828097, -101.8797682)", "(33.5828684, -101.879759)",
      7.181192735024884);
  graph.addEdge("(33.5828684, -101.879759)", "(33.5829357, -101.8797555)",
      8.171084086149792);
  graph.addEdge("(33.5829357, -101.8797555)", "(33.5829858, -101.8797544)",
      6.078055021334998);
  graph.addEdge("(33.5829858, -101.8797544)", "(33.5829972, -101.8797548)",
      1.38339319965343);
  graph.addEdge("(33.5829972, -101.8797548)", "(33.5830444, -101.8796932)",
      8.478786435614126);
  graph.addEdge("(33.5830444, -101.8796932)", "(33.5830868, -101.879647)",
      6.960661633967992);
  graph.addEdge("(33.5830868, -101.879647)", "(33.5831522, -101.8795916)",
      9.724453103002727);
  graph.addEdge("(33.5831522, -101.8795916)", "(33.5831954, -101.8795639)",
      5.947009633572229);
  graph.addEdge("(33.5831954, -101.8795639)", "(33.5832609, -101.8795339)",
      8.508802539066137);
  graph.addEdge("(33.5832609, -101.8795339)", "(33.5832851, -101.8795279)",
      2.9979485702613906);
  graph.addEdge("(33.5832851, -101.8795279)", "(33.5833311, -101.8795165)",
      5.698477593186868);
  graph.addEdge("(33.5833311, -101.8795165)", "(33.5833897, -101.8795027)",
      7.2448209744352665);
  graph.addEdge("(33.5833897, -101.8795027)", "(33.5834176, -101.8794796)",
      4.117385432318738);
  graph.addEdge("(33.5834176, -101.8794796)", "(33.5834253, -101.8794403)",
      4.0977450112165705);
  graph.addEdge("(33.5834253, -101.8794403)", "(33.5834446, -101.8794288)",
      2.6160333995485194);
  graph.addEdge("(33.5834446, -101.8794288)", "(33.5834754, -101.8794219)",
      3.8010856712400316);
  graph.addEdge("(33.5834754, -101.8794219)", "(33.5836204, -101.8794075)",
      17.64886324339276);
  graph.addEdge("(33.5836204, -101.8794075)", "(33.5837197, -101.8793976)",
      12.08675278752773);
  graph.addEdge("(33.5837197, -101.8793976)", "(33.5838005, -101.8793826)",
      9.918482195137944);
  graph.addEdge("(33.5838005, -101.8793826)", "(33.5838745, -101.8793503)",
      9.556289632488758);
  graph.addEdge("(33.5838745, -101.8793503)", "(33.5839476, -101.8792995)",
      10.25768837969392);
  graph.addEdge("(33.5839476, -101.8792995)", "(33.5839967, -101.8792464)",
      8.033199550362415);
  graph.addEdge("(33.5839967, -101.8792464)", "(33.5840449, -101.8791695)",
      9.753638542710782);
  graph.addEdge("(33.5815494, -101.8812135)", "(33.5815444, -101.8811839)",
      3.065756654173614);
  graph.addEdge("(33.5815444, -101.8811839)", "(33.5815486, -101.881171)",
      1.4052809852002908);
  graph.addEdge("(33.5815486, -101.881171)", "(33.5816093, -101.8810592)",
      13.529473357332503);
  graph.addEdge("(33.5816093, -101.8810592)", "(33.581614, -101.8810494)",
      1.1467113446176105);
  graph.addEdge("(33.581614, -101.8810494)", "(33.5816882, -101.880906)",
      17.116199499592195);
  graph.addEdge("(33.5815271, -101.881172)", "(33.5815444, -101.8811839)",
      2.4213962245319056);
  graph.addEdge("(33.5815444, -101.8811839)", "(33.581684, -101.8811847)",
      16.933389596092628);
  graph.addEdge("(33.581684, -101.8811847)", "(33.5817925, -101.8811861)",
      13.161596113478002);
  graph.addEdge("(33.5817925, -101.8811861)", "(33.5820115, -101.8811831)",
      26.565999864377613);
  graph.addEdge("(33.5818651, -101.8813162)", "(33.5819386, -101.881235)",
      12.142726198924056);
  graph.addEdge("(33.5819386, -101.881235)", "(33.5820115, -101.8811831)",
      10.293498574822106);
  graph.addEdge("(33.5820115, -101.8811831)", "(33.5821102, -101.8811257)",
      13.315096362669077);
  graph.addEdge("(33.5821102, -101.8811257)", "(33.5821469, -101.8811028)",
      5.022185789705225);
  graph.addEdge("(33.5821469, -101.8811028)", "(33.5822615, -101.8810327)",
      15.61669766927423);
  graph.addEdge("(33.5822615, -101.8810327)", "(33.5825743, -101.8808084)",
      44.25111997487434);
  graph.addEdge("(33.5824947, -101.8813572)", "(33.5824375, -101.8812732)",
      10.993976910597898);
  graph.addEdge("(33.5824375, -101.8812732)", "(33.5822615, -101.8810327)",
      32.4335371864847);
  graph.addEdge("(33.5822615, -101.8810327)", "(33.5821483, -101.8808925)",
      19.777267997693347);
  graph.addEdge("(33.5821483, -101.8808925)", "(33.5821082, -101.8808036)",
      10.252821362205324);
  graph.addEdge("(33.5821458, -101.8813351)", "(33.5821469, -101.8811028)",
      23.584690697777397);
  graph.addEdge("(33.5821469, -101.8811028)", "(33.5821483, -101.8808925)",
      21.35143300270721);
  graph.addEdge("(33.5821483, -101.8808925)", "(33.5821467, -101.8807967)",
      9.728053997976371);
  graph.addEdge("(33.5821467, -101.8807967)", "(33.5821475, -101.880749)",
      4.843726032922035);
  graph.addEdge("(33.5821475, -101.880749)", "(33.582148, -101.8807192)",
      3.026059935852885);
  graph.addEdge("(33.582148, -101.8807192)", "(33.5821642, -101.8806988)",
      2.8549688903923935);
  graph.addEdge("(33.5821642, -101.8806988)", "(33.5821644, -101.88065)",
      4.954490083450058);
  graph.addEdge("(33.5821644, -101.88065)", "(33.582165, -101.8804672)",
      18.55895265800022);
  graph.addEdge("(33.5819651, -101.8807546)", "(33.582, -101.8807546)",
      4.233298954714372);
  graph.addEdge("(33.582, -101.8807546)", "(33.581999, -101.8808001)",
      4.6209985139299965);
  graph.addEdge("(33.581999, -101.8808001)", "(33.5821082, -101.8808036)",
      13.250503269521571);
  graph.addEdge("(33.5821082, -101.8808036)", "(33.5821467, -101.8807967)",
      4.722220909643591);
  graph.addEdge("(33.5821467, -101.8807967)", "(33.5821668, -101.8807961)",
      2.4388500092519623);
  graph.addEdge("(33.5821668, -101.8807961)", "(33.5823018, -101.8807914)",
      16.382176626436898);
  graph.addEdge("(33.5824947, -101.8813572)", "(33.5825124, -101.8813303)",
      3.4738963298077747);
  graph.addEdge("(33.5825124, -101.8813303)", "(33.5825239, -101.8812949)",
      3.8551911755993604);
  graph.addEdge("(33.5825239, -101.8812949)", "(33.5825267, -101.8812412)",
      5.462450370223485);
  graph.addEdge("(33.5825267, -101.8812412)", "(33.5825277, -101.8810779)",
      16.579442599587598);
  graph.addEdge("(33.5825277, -101.8810779)", "(33.5825724, -101.8808861)",
      20.213228812594902);
  graph.addEdge("(33.5825724, -101.8808861)", "(33.5825743, -101.8808084)",
      7.8918381814691765);
  graph.addEdge("(33.5825743, -101.8808084)", "(33.5825754, -101.8807462)",
      6.316248178513124);
  graph.addEdge("(33.5825754, -101.8807462)", "(33.5825758, -101.8807253)",
      2.1224216668056455);
  graph.addEdge("(33.5825758, -101.8807253)", "(33.5825778, -101.8806083)",
      11.880871157501879);
  graph.addEdge("(33.5825778, -101.8806083)", "(33.582579, -101.8800731)",
      54.336232669208115);
  graph.addEdge("(33.582579, -101.8800731)", "(33.582579, -101.8798661)",
      21.015619819917553);
  graph.addEdge("(33.582579, -101.8798661)", "(33.582579, -101.8797864)",
      8.09152125427033);
  graph.addEdge("(33.582579, -101.8797864)", "(33.582579, -101.8795147)",
      27.584270072280155);
  graph.addEdge("(33.582579, -101.8795147)", "(33.5825795, -101.8794517)",
      6.396345725047869);
  graph.addEdge("(33.5825795, -101.8794517)", "(33.58258, -101.8793902)",
      6.244065602517149);
  graph.addEdge("(33.58258, -101.8793902)", "(33.5825809, -101.8793331)",
      5.798089999196062);
  graph.addEdge("(33.5825809, -101.8793331)", "(33.5825695, -101.8792441)",
      9.140898863262779);
  graph.addEdge("(33.5825695, -101.8792441)", "(33.5825486, -101.8791538)",
      9.511746975033759);
  graph.addEdge("(33.5825486, -101.8791538)", "(33.582546, -101.8791452)",
      0.928325149699975);
  graph.addEdge("(33.582546, -101.8791452)", "(33.5825096, -101.8790374)",
      11.801427631779935);
  graph.addEdge("(33.5825096, -101.8790374)", "(33.582459, -101.8789185)",
      13.542062806383962);
  graph.addEdge("(33.582459, -101.8789185)", "(33.582423, -101.8788204)",
      10.874823302499498);
  graph.addEdge("(33.582423, -101.8788204)", "(33.5824109, -101.878781)",
      4.260846764023253);
  graph.addEdge("(33.5824109, -101.878781)", "(33.5823878, -101.8786994)",
      8.745454807212132);
  graph.addEdge("(33.5823878, -101.8786994)", "(33.5823802, -101.8786137)",
      8.749390110576881);
  graph.addEdge("(33.5823802, -101.8786137)", "(33.5823812, -101.8779757)",
      64.77304165480275);
  graph.addEdge("(33.5823812, -101.8779757)", "(33.5823812, -101.8779606)",
      1.533026972216146);
  graph.addEdge("(33.5823812, -101.8779606)", "(33.582371, -101.8779202)",
      4.284151736264577);
  graph.addEdge("(33.582371, -101.8779202)", "(33.5823669, -101.8779046)",
      1.6600357246654769);
  graph.addEdge("(33.5823669, -101.8779046)", "(33.5823583, -101.8778864)",
      2.121882601603744);
  graph.addEdge("(33.5823583, -101.8778864)", "(33.5823604, -101.8778083)",
      7.933192299586714);
  graph.addEdge("(33.5823604, -101.8778083)", "(33.5823614, -101.8777683)",
      4.0628106732483245);
  graph.addEdge("(33.5823614, -101.8777683)", "(33.5823621, -101.8777425)",
      2.6207205217803664);
  graph.addEdge("(33.5823621, -101.8777425)", "(33.5823783, -101.8777105)",
      3.796844549251012);
  graph.addEdge("(33.5823783, -101.8777105)", "(33.582385, -101.8776785)",
      3.348905720894268);
  graph.addEdge("(33.582385, -101.8776785)", "(33.582384, -101.877352)",
      33.14812176066163);
  graph.addEdge("(33.582384, -101.877352)", "(33.5823851, -101.8770921)",
      26.386674748518992);
  graph.addEdge("(33.5823851, -101.8770921)", "(33.5823865, -101.8767453)",
      35.20926553673263);
  graph.addEdge("(33.5823865, -101.8767453)", "(33.5823897, -101.8759874)",
      76.94674390655344);
  graph.addEdge("(33.5823897, -101.8759874)", "(33.5823916, -101.8756346)",
      35.81874521165753);
  graph.addEdge("(33.5823916, -101.8756346)", "(33.5823907, -101.8756253)",
      0.9504722332284254);
  graph.addEdge("(33.5823907, -101.8756253)", "(33.5823897, -101.8756152)",
      1.0325514716231405);
  graph.addEdge("(33.5823897, -101.8756152)", "(33.5823821, -101.8755935)",
      2.388189065614387);
  graph.addEdge("(33.5823821, -101.8755935)", "(33.5823748, -101.8755854)",
      1.2084409520794213);
  graph.addEdge("(33.5823748, -101.8755854)", "(33.5823593, -101.8755684)",
      2.5521876577043523);
  graph.addEdge("(33.5823593, -101.8755684)", "(33.5823241, -101.8755592)",
      4.370658178409387);
  graph.addEdge("(33.5823241, -101.8755592)", "(33.5823125, -101.8755591)",
      1.4070930873948382);
  graph.addEdge("(33.5823125, -101.8755591)", "(33.5822571, -101.8755584)",
      6.7202833346471955);
  graph.addEdge("(33.5822571, -101.8755584)", "(33.5822128, -101.8755581)",
      5.373586356785647);
  graph.addEdge("(33.5822128, -101.8755581)", "(33.5821595, -101.8755467)",
      6.567961606558326);
  graph.addEdge("(33.5821595, -101.8755467)", "(33.5821536, -101.8755425)",
      0.8330596806490441);
  graph.addEdge("(33.5821536, -101.8755425)", "(33.5821338, -101.8755284)",
      2.7959561767313916);
  graph.addEdge("(33.5821338, -101.8755284)", "(33.58211, -101.8754827)",
      5.464522266576416);
  graph.addEdge("(33.58211, -101.8754827)", "(33.5821015, -101.8754199)",
      6.4586145472010665);
  graph.addEdge("(33.5821015, -101.8754199)", "(33.5821034, -101.8752098)",
      21.331708744678558);
  graph.addEdge("(33.5821034, -101.8752098)", "(33.5821079, -101.8751946)",
      1.6368751453233672);
  graph.addEdge("(33.5821079, -101.8751946)", "(33.5821351, -101.8751025)",
      9.915484714783668);
  graph.addEdge("(33.5821351, -101.8751025)", "(33.5821369, -101.8746737)",
      43.53457564530426);
  graph.addEdge("(33.5821369, -101.8746737)", "(33.5821369, -101.8746642)",
      0.964489886216817);
  graph.addEdge("(33.5821369, -101.8746642)", "(33.5821313, -101.874629)",
      3.637672141898242);
  graph.addEdge("(33.5821313, -101.874629)", "(33.5821029, -101.8745722)",
      6.717228737340492);
  graph.addEdge("(33.5821029, -101.8745722)", "(33.5821001, -101.8745199)",
      5.320623899812785);
  graph.addEdge("(33.5821001, -101.8745199)", "(33.5821019, -101.8741929)",
      33.19948881917341);
  graph.addEdge("(33.5821019, -101.8741929)", "(33.5821237, -101.8741407)",
      5.922690887462214);
  graph.addEdge("(33.5821237, -101.8741407)", "(33.5821284, -101.8740203)",
      12.236929048362587);
  graph.addEdge("(33.5821284, -101.8740203)", "(33.5820887, -101.8739249)",
      10.816582979246432);
  graph.addEdge("(33.5820887, -101.8739249)", "(33.5820879, -101.8738561)",
      6.9856152150943265);
  graph.addEdge("(33.5820879, -101.8738561)", "(33.582087, -101.8737847)",
      7.249729051929398);
  graph.addEdge("(33.582087, -101.8737847)", "(33.5820868, -101.8737671)",
      1.7870101270127448);
  graph.addEdge("(33.5820868, -101.8737671)", "(33.5821001, -101.8737307)",
      4.032306135878467);
  graph.addEdge("(33.5821001, -101.8737307)", "(33.5820982, -101.8736217)",
      11.068656777858969);
  graph.addEdge("(33.5820982, -101.8736217)", "(33.5820953, -101.873585)",
      3.7425463700005075);
  graph.addEdge("(33.5820953, -101.873585)", "(33.5820906, -101.8735161)",
      7.018286505835569);
  graph.addEdge("(33.5820906, -101.8735161)", "(33.5820896, -101.8734355)",
      8.183838626068184);
  graph.addEdge("(33.5820896, -101.8734355)", "(33.5820915, -101.873369)",
      6.7553652474701655);
  graph.addEdge("(33.5820915, -101.873369)", "(33.5820915, -101.8733072)",
      6.274263805295243);
  graph.addEdge("(33.5820915, -101.8733072)", "(33.5820918, -101.8732531)",
      5.4926394962808285);
  graph.addEdge("(33.5821741, -101.8803412)", "(33.582579, -101.8798661)",
      68.838281317076);
  graph.addEdge("(33.582165, -101.8804672)", "(33.5821904, -101.8804794)",
      3.3206196270750343);
  graph.addEdge("(33.5821904, -101.8804794)", "(33.5823007, -101.8806106)",
      18.87927562179192);
  graph.addEdge("(33.5823007, -101.8806106)", "(33.5825778, -101.8806083)",
      33.61247949714565);
  graph.addEdge("(33.5818687, -101.880101)", "(33.5818689, -101.8799345)",
      16.904023992775326);
  graph.addEdge("(33.5818689, -101.8799345)", "(33.5818691, -101.8797549)",
      18.234007585352252);
  graph.addEdge("(33.5818691, -101.8797549)", "(33.5818696, -101.8792446)",
      51.80853102894827);
  graph.addEdge("(33.5818696, -101.8792446)", "(33.5818699, -101.8789436)",
      30.559216420680038);
  graph.addEdge("(33.5818699, -101.8789436)", "(33.5818699, -101.8789149)",
      2.913783680950731);
  graph.addEdge("(33.5818699, -101.8789149)", "(33.5817087, -101.8789121)",
      19.55529754973162);
  graph.addEdge("(33.5817087, -101.8789121)", "(33.5816775, -101.8789127)",
      3.7849865272515926);
  graph.addEdge("(33.5816775, -101.8789127)", "(33.5816545, -101.8789127)",
      2.789853034909286);
  graph.addEdge("(33.5817087, -101.8789121)", "(33.5816772, -101.878814)",
      10.667443744098453);
  graph.addEdge("(33.5816772, -101.878814)", "(33.5816748, -101.8788048)",
      0.9783525114350529);
  graph.addEdge("(33.5816748, -101.8788048)", "(33.5816445, -101.8786906)",
      12.162837332795485);
  graph.addEdge("(33.5816445, -101.8786906)", "(33.581645, -101.8780003)",
      70.08330492477049);
  graph.addEdge("(33.581645, -101.8780003)", "(33.5816451, -101.8779221)",
      7.939328943416617);
  graph.addEdge("(33.5816451, -101.8779221)", "(33.5816451, -101.8778712)",
      5.167664596386772);
  graph.addEdge("(33.5816451, -101.8778712)", "(33.5816432, -101.8778089)",
      6.32925644666393);
  graph.addEdge("(33.5816432, -101.8778089)", "(33.5816438, -101.8777048)",
      10.569089369477698);
  graph.addEdge("(33.5816438, -101.8777048)", "(33.5816455, -101.8774282)",
      28.082800980498952);
  graph.addEdge("(33.5816455, -101.8774282)", "(33.5816456, -101.8772901)",
      14.020721887229328);
  graph.addEdge("(33.5816456, -101.8772901)", "(33.5816573, -101.8771779)",
      11.479262055318607);
  graph.addEdge("(33.5816573, -101.8771779)", "(33.5816755, -101.8770489)",
      13.281585543243256);
  graph.addEdge("(33.5816755, -101.8770489)", "(33.5816889, -101.8769536)",
      9.810983910068945);
  graph.addEdge("(33.5816889, -101.8769536)", "(33.5816959, -101.8768218)",
      13.408008632172375);
  graph.addEdge("(33.5816959, -101.8768218)", "(33.5817099, -101.8767321)",
      9.263838104191843);
  graph.addEdge("(33.5817099, -101.8767321)", "(33.5817566, -101.8766003)",
      14.530706795676972);
  graph.addEdge("(33.5817566, -101.8766003)", "(33.581822, -101.8765036)",
      12.621989061037825);
  graph.addEdge("(33.581822, -101.8765036)", "(33.5818901, -101.8764242)",
      11.541919105001046);
  graph.addEdge("(33.5818901, -101.8764242)", "(33.5819131, -101.8763971)",
      3.918311129105392);
  graph.addEdge("(33.5819131, -101.8763971)", "(33.5819516, -101.8763424)",
      7.255989158583268);
  graph.addEdge("(33.5819516, -101.8763424)", "(33.5819575, -101.8763127)",
      3.099070575948784);
  graph.addEdge("(33.5819575, -101.8763127)", "(33.5819577, -101.876201)",
      11.340419953019648);
  graph.addEdge("(33.5819577, -101.876201)", "(33.5819584, -101.875921)",
      28.427255763604194);
  graph.addEdge("(33.5819584, -101.875921)", "(33.5819583, -101.8758408)",
      8.142350944248923);
  graph.addEdge("(33.5819583, -101.8758408)", "(33.5819584, -101.8758341)",
      0.6803287250887147);
  graph.addEdge("(33.5819584, -101.8758341)", "(33.5819586, -101.8758188)",
      1.5535289667452032);
  graph.addEdge("(33.5819586, -101.8758188)", "(33.5819587, -101.8757956)",
      2.3554219018063973);
  graph.addEdge("(33.5819587, -101.8757956)", "(33.5819652, -101.8757764)",
      2.102702827995806);
  graph.addEdge("(33.5819652, -101.8757764)", "(33.5819678, -101.8755591)",
      22.063734498770152);
  graph.addEdge("(33.5819678, -101.8755591)", "(33.5819832, -101.8754788)",
      8.363762380203248);
  graph.addEdge("(33.5819832, -101.8754788)", "(33.5820324, -101.8753925)",
      10.601024751101459);
  graph.addEdge("(33.5820324, -101.8753925)", "(33.5820331, -101.8752536)",
      14.102129942288142);
  graph.addEdge("(33.5820331, -101.8752536)", "(33.5820448, -101.875194)",
      6.2151124793315615);
  graph.addEdge("(33.5820448, -101.875194)", "(33.5820484, -101.8751775)",
      1.7311476404650419);
  graph.addEdge("(33.5820484, -101.8751775)", "(33.582066, -101.8750996)",
      8.191890019947449);
  graph.addEdge("(33.582066, -101.8750996)", "(33.5820871, -101.8750036)",
      10.076873395062556);
  graph.addEdge("(33.5820871, -101.8750036)", "(33.5820848, -101.8747292)",
      27.859942175780727);
  graph.addEdge("(33.5820848, -101.8747292)", "(33.5820868, -101.8746423)",
      8.825884255669633);
  graph.addEdge("(33.5820868, -101.8746423)", "(33.5821029, -101.8745722)",
      7.380000584545752);
  graph.addEdge("(33.5836204, -101.8794075)", "(33.5836725, -101.8801773)",
      78.40787143528668);
  graph.addEdge("(33.5834336, -101.8800693)", "(33.5834133, -101.8800322)",
      4.499991002226784);
  graph.addEdge("(33.5834133, -101.8800322)", "(33.5834007, -101.8799486)",
      8.623897048899048);
  graph.addEdge("(33.5834007, -101.8799486)", "(33.5833804, -101.8798244)",
      12.847429571635194);
  graph.addEdge("(33.5833804, -101.8798244)", "(33.5833533, -101.8796966)",
      13.384673316955835);
  graph.addEdge("(33.5833533, -101.8796966)", "(33.5833281, -101.87962)",
      8.355892736963288);
  graph.addEdge("(33.5833281, -101.87962)", "(33.5832851, -101.8795279)",
      10.706715026892626);
  graph.addEdge("(33.5832851, -101.8795279)", "(33.5832546, -101.8794668)",
      7.222572409127732);
  graph.addEdge("(33.5832546, -101.8794668)", "(33.5831918, -101.8793634)",
      12.970184608927108);
  graph.addEdge("(33.5831918, -101.8793634)", "(33.5831734, -101.8793437)",
      2.9968975473107844);
  graph.addEdge("(33.5831734, -101.8793437)", "(33.5831296, -101.8793097)",
      6.335727519263515);
  graph.addEdge("(33.5831296, -101.8793097)", "(33.5830907, -101.879276)",
      5.828369016045854);
  graph.addEdge("(33.5830907, -101.879276)", "(33.5830728, -101.8792613)",
      2.6346782194120864);
  graph.addEdge("(33.5830728, -101.8792613)", "(33.5829645, -101.879216)",
      13.91836022204986);
  graph.addEdge("(33.5829645, -101.879216)", "(33.5828387, -101.8791544)",
      16.49112136094291);
  graph.addEdge("(33.5828387, -101.8791544)", "(33.5826762, -101.8790743)",
      21.322563586731086);
  graph.addEdge("(33.5826762, -101.8790743)", "(33.5826027, -101.8790383)",
      9.635485768556725);
  graph.addEdge("(33.5831798, -101.881535)", "(33.5832111, -101.8814564)",
      8.836932854021503);
  graph.addEdge("(33.5833285, -101.8816039)", "(33.5832717, -101.8815315)",
      10.074505789120508);
  graph.addEdge("(33.5832717, -101.8815315)", "(33.5832111, -101.8814564)",
      10.590769613097374);
  graph.addEdge("(33.5832111, -101.8814564)", "(33.5831651, -101.8813484)",
      12.302660713909077);
  graph.addEdge("(33.5831651, -101.8813484)", "(33.5831318, -101.8812591)",
      9.925194001991462);
  graph.addEdge("(33.5831318, -101.8812591)", "(33.5830593, -101.8810496)",
      23.01563809886819);
  graph.addEdge("(33.5830593, -101.8810496)", "(33.5830497, -101.881022)",
      3.034394444379718);
  graph.addEdge("(33.5830497, -101.881022)", "(33.5830096, -101.8809128)",
      12.106535372811319);
  graph.addEdge("(33.5830096, -101.8809128)", "(33.5829392, -101.8806463)",
      28.371815478865887);
  graph.addEdge("(33.5829392, -101.8806463)", "(33.5829069, -101.8804784)",
      17.490398461825862);
  graph.addEdge("(33.5829069, -101.8804784)", "(33.5828942, -101.8803399)",
      14.1452565974123);
  graph.addEdge("(33.5828942, -101.8803399)", "(33.5828934, -101.8803284)",
      1.1715558905970185);
  graph.addEdge("(33.5828934, -101.8803284)", "(33.5828795, -101.8801345)",
      19.757647632610787);
  graph.addEdge("(33.5828795, -101.8801345)", "(33.5828633, -101.880079)",
      5.967419138482269);
  graph.addEdge("(33.5828633, -101.880079)", "(33.582859, -101.880064)",
      1.6097105538980954);
  graph.addEdge("(33.582859, -101.880064)", "(33.5828423, -101.8799948)",
      7.311693901082469);
  graph.addEdge("(33.5828423, -101.8799948)", "(33.5828032, -101.8798868)",
      11.946423158217796);
  graph.addEdge("(33.5828032, -101.8798868)", "(33.5827631, -101.8798281)",
      7.692494245640652);
  graph.addEdge("(33.5827631, -101.8798281)", "(33.582726, -101.8797856)",
      6.234487416579173);
  graph.addEdge("(33.582726, -101.8797856)", "(33.5826956, -101.8797353)",
      6.298856708092741);
  graph.addEdge("(33.5826956, -101.8797353)", "(33.5826751, -101.8796567)",
      8.358287914661833);
  graph.addEdge("(33.5826751, -101.8796567)", "(33.5826722, -101.8795099)",
      14.907965237340145);
  graph.addEdge("(33.5826722, -101.8795099)", "(33.5826717, -101.8794524)",
      5.83798095345339);
  graph.addEdge("(33.5826717, -101.8794524)", "(33.5826712, -101.879396)",
      5.726310044406357);
  graph.addEdge("(33.5826712, -101.879396)", "(33.5826653, -101.8792951)",
      10.268803395220324);
  graph.addEdge("(33.5826653, -101.8792951)", "(33.5826506, -101.879207)",
      9.12032077694007);
  graph.addEdge("(33.5826506, -101.879207)", "(33.5826321, -101.8791213)",
      8.9853845778431);
  graph.addEdge("(33.5826321, -101.8791213)", "(33.5826027, -101.8790383)",
      9.150094604045272);
  graph.addEdge("(33.5826027, -101.8790383)", "(33.5825636, -101.8789499)",
      10.150885165659226);
  graph.addEdge("(33.5825636, -101.8789499)", "(33.5825274, -101.8788595)",
      10.17415849974569);
  graph.addEdge("(33.5825274, -101.8788595)", "(33.5825039, -101.8787809)",
      8.47368680521581);
  graph.addEdge("(33.5825039, -101.8787809)", "(33.5824814, -101.8786952)",
      9.11868192322374);
  graph.addEdge("(33.5824814, -101.8786952)", "(33.5824678, -101.8786118)",
      8.626376481183877);
  graph.addEdge("(33.5824678, -101.8786118)", "(33.5824638, -101.8784897)",
      12.40567780966451);
  graph.addEdge("(33.5824638, -101.8784897)", "(33.5824649, -101.878169)",
      32.55929846117968);
  graph.addEdge("(33.5824649, -101.878169)", "(33.5824654, -101.878028)",
      14.31513468793488);
  graph.addEdge("(33.5824654, -101.878028)", "(33.5824658, -101.8779063)",
      12.355671483355543);
  graph.addEdge("(33.5824658, -101.8779063)", "(33.5824766, -101.8778673)",
      4.170557085962061);
  graph.addEdge("(33.5824766, -101.8778673)", "(33.5824766, -101.8778081)",
      6.010271318735102);
  graph.addEdge("(33.5824766, -101.8778081)", "(33.5824766, -101.8777601)",
      4.873192959576857);
  graph.addEdge("(33.5824766, -101.8777601)", "(33.5824766, -101.8777525)",
      0.7715888857472608);
  graph.addEdge("(33.5824766, -101.8777525)", "(33.5824697, -101.8776891)",
      6.490862250429893);
  graph.addEdge("(33.5824697, -101.8776891)", "(33.5824702, -101.8774096)",
      28.376263498700713);
  graph.addEdge("(33.5824702, -101.8774096)", "(33.5824707, -101.8770915)",
      32.29511508541259);
  graph.addEdge("(33.5824707, -101.8770915)", "(33.5824713, -101.8768872)",
      20.741656562191952);
  graph.addEdge("(33.5824713, -101.8768872)", "(33.5824717, -101.8767532)",
      13.604417668560853);
  graph.addEdge("(33.5824717, -101.8767532)", "(33.5824717, -101.8767463)",
      0.7005215278919733);
  graph.addEdge("(33.5824717, -101.8767463)", "(33.5824746, -101.8757226)",
      103.93159178641038);
  graph.addEdge("(33.5824746, -101.8757226)", "(33.5824775, -101.8756792)",
      4.4201977809970225);
  graph.addEdge("(33.5824775, -101.8756792)", "(33.5824912, -101.8756346)",
      4.823315993283147);
  graph.addEdge("(33.5824912, -101.8756346)", "(33.5825229, -101.8755895)",
      5.979153306819349);
  graph.addEdge("(33.5825229, -101.8755895)", "(33.582545, -101.8755771)",
      2.961574096994608);
  graph.addEdge("(33.582545, -101.8755771)", "(33.5825812, -101.8755653)",
      4.551477713765192);
  graph.addEdge("(33.5825812, -101.8755653)", "(33.5826311, -101.8755642)",
      6.053799197115135);
  graph.addEdge("(33.5826311, -101.8755642)", "(33.5828492, -101.8755642)",
      26.45508925922326);
  graph.addEdge("(33.5825229, -101.8755895)", "(33.5825059, -101.8755853)",
      2.1056910875813863);
  graph.addEdge("(33.5825059, -101.8755853)", "(33.5824395, -101.875586)",
      8.054499000374301);
  graph.addEdge("(33.5824395, -101.875586)", "(33.5823954, -101.8755865)",
      5.349481455901458);
  graph.addEdge("(33.5823954, -101.8755865)", "(33.5823748, -101.8755854)",
      2.501232614493794);
  graph.addEdge("(33.5824678, -101.8786118)", "(33.582495, -101.8786755)",
      7.26011153235693);
  graph.addEdge("(33.582495, -101.8786755)", "(33.5825293, -101.8787183)",
      6.015914928899475);
  graph.addEdge("(33.5825293, -101.8787183)", "(33.5825732, -101.8787512)",
      6.2858670714230716);
  graph.addEdge("(33.582423, -101.8788204)", "(33.5824648, -101.8788)",
      5.476949530334203);
  graph.addEdge("(33.5824648, -101.8788)", "(33.5825039, -101.8787809)",
      5.1238548933433075);
  graph.addEdge("(33.5825039, -101.8787809)", "(33.5825444, -101.8787595)",
      5.371559200491425);
  graph.addEdge("(33.5825444, -101.8787595)", "(33.5825732, -101.8787512)",
      3.593575371059523);
  graph.addEdge("(33.5825732, -101.8787512)", "(33.5826665, -101.8787529)",
      11.318417222463863);
  graph.addEdge("(33.5835807, -101.8816787)", "(33.5839049, -101.8814961)",
      43.47533129840479);
  graph.addEdge("(33.5839049, -101.8814961)", "(33.5840812, -101.8813968)",
      23.64196969930293);
  graph.addEdge("(33.5839049, -101.8814961)", "(33.5838317, -101.8814509)",
      9.994719899821996);
  graph.addEdge("(33.5838317, -101.8814509)", "(33.5831318, -101.8812591)",
      87.10096487757157);
  graph.addEdge("(33.5831318, -101.8812591)", "(33.5831007, -101.8812646)",
      3.8134691239341354);
  graph.addEdge("(33.5831007, -101.8812646)", "(33.58309, -101.8812566)",
      1.5310688916282496);
  graph.addEdge("(33.58309, -101.8812566)", "(33.5830595, -101.8811945)",
      7.3099634638856985);
  graph.addEdge("(33.5830595, -101.8811945)", "(33.5830038, -101.8810352)",
      17.52732724152686);
  graph.addEdge("(33.5830038, -101.8810352)", "(33.5829494, -101.8808553)",
      19.41966107611491);
  graph.addEdge("(33.5829494, -101.8808553)", "(33.5829109, -101.8807088)",
      15.589229852310497);
  graph.addEdge("(33.5829109, -101.8807088)", "(33.5828817, -101.880575)",
      14.038127444356846);
  graph.addEdge("(33.5828817, -101.880575)", "(33.5828698, -101.8804746)",
      10.294744819407521);
  graph.addEdge("(33.5828698, -101.8804746)", "(33.5828578, -101.8803424)",
      13.50022415115143);
  graph.addEdge("(33.5828578, -101.8803424)", "(33.5828459, -101.8801752)",
      17.036142622381924);
  graph.addEdge("(33.5828459, -101.8801752)", "(33.5828459, -101.8801211)",
      5.492471169669221);
  graph.addEdge("(33.5828459, -101.8801211)", "(33.5828633, -101.880079)",
      4.766881943318228);
  graph.addEdge("(33.5828633, -101.880079)", "(33.5828884, -101.8800446)",
      4.633205439000436);
  graph.addEdge("(33.5828884, -101.8800446)", "(33.5829229, -101.8799268)",
      12.67058272322003);
  graph.addEdge("(33.5829229, -101.8799268)", "(33.5829653, -101.8798169)",
      12.285808213725627);
  graph.addEdge("(33.5829653, -101.8798169)", "(33.5829972, -101.8797548)",
      7.39736415226703);
  graph.addEdge("(33.5828884, -101.8800446)", "(33.5828821, -101.8800855)",
      4.222079104227015);
  graph.addEdge("(33.5828821, -101.8800855)", "(33.5828795, -101.8801345)",
      4.984681313117008);
  graph.addEdge("(33.5842646, -101.8818238)", "(33.5840812, -101.8813968)",
      48.725068967690945);
  graph.addEdge("(33.5840812, -101.8813968)", "(33.5839359, -101.8810613)",
      38.3507147324524);
  graph.addEdge("(33.5839359, -101.8810613)", "(33.5838624, -101.8808917)",
      19.389569118391513);
  graph.addEdge("(33.5838624, -101.8808917)", "(33.5838597, -101.8808847)",
      0.7824964093879144);
  graph.addEdge("(33.5838597, -101.8808847)", "(33.583801, -101.8807309)",
      17.161085049590266);
  graph.addEdge("(33.583801, -101.8807309)", "(33.5837128, -101.8806981)",
      11.204741109674725);
  graph.addEdge("(33.5839359, -101.8810613)", "(33.5840168, -101.8808194)",
      26.44639809528172);
  graph.addEdge("(33.583801, -101.8807309)", "(33.5839948, -101.8808098)",
      24.834814566521683);
  graph.addEdge("(33.5839948, -101.8808098)", "(33.5840168, -101.8808194)",
      2.8409643559829885);
  graph.addEdge("(33.5840168, -101.8808194)", "(33.5841538, -101.8807414)",
      18.40813480851502);
  graph.addEdge("(33.5841538, -101.8807414)", "(33.584664, -101.8804262)",
      69.66995277874668);
  graph.addEdge("(33.584664, -101.8804262)", "(33.5849983, -101.8802197)",
      45.648648245573874);
  graph.addEdge("(33.5849983, -101.8802197)", "(33.5850197, -101.8801964)",
      3.5119030231541553);
  graph.addEdge("(33.5850197, -101.8801964)", "(33.5850393, -101.880175)",
      3.220602152105594);
  graph.addEdge("(33.5850393, -101.880175)", "(33.5850805, -101.8801412)",
      6.062141357454411);
  graph.addEdge("(33.5850805, -101.8801412)", "(33.5851311, -101.8800996)",
      7.4503307976236925);
  graph.addEdge("(33.5851311, -101.8800996)", "(33.5852041, -101.8798816)",
      23.837370281403704);
  graph.addEdge("(33.5852041, -101.8798816)", "(33.5852754, -101.8796817)",
      22.06016313320058);
  graph.addEdge("(33.5838597, -101.8808847)", "(33.5839948, -101.8808098)",
      18.065648893260466);
  graph.addEdge("(33.5816455, -101.8774282)", "(33.5815327, -101.8774278)",
      13.682469770762465);
  graph.addEdge("(33.5815327, -101.8774278)", "(33.5814038, -101.8774273)",
      15.635388702459396);
  graph.addEdge("(33.5814038, -101.8774273)", "(33.5811338, -101.8774263)",
      32.75060394560455);
  graph.addEdge("(33.5811338, -101.8774263)", "(33.5808631, -101.8774228)",
      32.837276406968506);
  graph.addEdge("(33.5808631, -101.8774228)", "(33.5808635, -101.8778691)",
      45.31141115532925);
  graph.addEdge("(33.5808635, -101.8778691)", "(33.5808637, -101.8781152)",
      24.98574302060469);
  graph.addEdge("(33.5808637, -101.8781152)", "(33.5808633, -101.878179)",
      6.477587871941109);
  graph.addEdge("(33.5808631, -101.8774228)", "(33.5808652, -101.8771842)",
      24.225619745980378);
  graph.addEdge("(33.5808631, -101.8774228)", "(33.5806016, -101.8774186)",
      31.722277312992336);
  graph.addEdge("(33.5806016, -101.8774186)", "(33.5801917, -101.8774121)",
      49.7244021803977);
  graph.addEdge("(33.5801917, -101.8774121)", "(33.5800933, -101.8774106)",
      11.936687658788761);
  graph.addEdge("(33.5800933, -101.8774106)", "(33.5799, -101.8774075)",
      23.44900127530436);
  graph.addEdge("(33.5801917, -101.8774121)", "(33.580193, -101.8771587)",
      25.72755888225285);
  graph.addEdge("(33.580193, -101.8771587)", "(33.5801951, -101.8767733)",
      39.1295377001988);
  graph.addEdge("(33.5803678, -101.8771609)", "(33.580193, -101.8771587)",
      21.204054773658747);
  graph.addEdge("(33.580193, -101.8771587)", "(33.5800933, -101.8771587)",
      12.093403442699051);
  graph.addEdge("(33.5800933, -101.8771587)", "(33.5800933, -101.8774106)",
      25.574813559507128);
  graph.addEdge("(33.5800933, -101.8771587)", "(33.5800946, -101.8767729)",
      39.16968222007835);
  graph.addEdge("(33.5850691, -101.8774133)", "(33.5850704, -101.8772732)",
      14.2240805911533);
  graph.addEdge("(33.5850704, -101.8772732)", "(33.5850726, -101.8770214)",
      25.564585729775576);
  graph.addEdge("(33.5850726, -101.8770214)", "(33.5850751, -101.8767465)",
      27.90999351107954);
  graph.addEdge("(33.5850751, -101.8767465)", "(33.584875, -101.8767426)",
      24.274963570768396);
  graph.addEdge("(33.584875, -101.8767426)", "(33.5848651, -101.8767424)",
      1.201022052104304);
  graph.addEdge("(33.5848651, -101.8767424)", "(33.5847482, -101.8767418)",
      14.179869344746004);
  graph.addEdge("(33.5816573, -101.8771779)", "(33.5814038, -101.8771745)",
      30.750969180837185);
  graph.addEdge("(33.5814038, -101.8771745)", "(33.5811348, -101.8771728)",
      32.629605106264755);
  graph.addEdge("(33.5811348, -101.8771728)", "(33.5808633, -101.8771676)",
      32.93662347717997);
  graph.addEdge("(33.5808633, -101.8771676)", "(33.5808652, -101.8771842)",
      1.701028718525843);
  graph.addEdge("(33.5808633, -101.8771676)", "(33.5808486, -101.8771239)",
      4.7816157413685705);
  graph.addEdge("(33.5808486, -101.8771239)", "(33.5808155, -101.8770629)",
      7.380706041943867);
  graph.addEdge("(33.5808155, -101.8770629)", "(33.5807991, -101.8770481)",
      2.493001555694831);
  graph.addEdge("(33.5807991, -101.8770481)", "(33.5807742, -101.8770257)",
      3.780782404411942);
  graph.addEdge("(33.5807742, -101.8770257)", "(33.5807536, -101.8769938)",
      4.090588122878502);
  graph.addEdge("(33.5807536, -101.8769938)", "(33.5807432, -101.8769638)",
      3.2967127182837404);
  graph.addEdge("(33.5807432, -101.8769638)", "(33.5807379, -101.8769316)",
      3.3317770217120244);
  graph.addEdge("(33.5807379, -101.8769316)", "(33.5807359, -101.8769204)",
      1.162691636041936);
  graph.addEdge("(33.5841481, -101.8738617)", "(33.5841484, -101.8737951)",
      6.761522780688709);
  graph.addEdge("(33.5841484, -101.8737951)", "(33.5841493, -101.8736121)",
      18.579010528653676);
  graph.addEdge("(33.5841493, -101.8736121)", "(33.5841528, -101.8732941)",
      32.2870710923126);
  graph.addEdge("(33.5836138, -101.8737827)", "(33.5836364, -101.873787)",
      2.775876961356164);
  graph.addEdge("(33.5836364, -101.873787)", "(33.5837321, -101.8737888)",
      11.609656700766017);
  graph.addEdge("(33.5837321, -101.8737888)", "(33.5841484, -101.8737951)",
      50.50040899516559);
  graph.addEdge("(33.5841484, -101.8737951)", "(33.5842054, -101.8738018)",
      6.947365299442376);
  graph.addEdge("(33.5843577, -101.8724406)", "(33.5846527, -101.8724396)",
      35.78305810045529);
  graph.addEdge("(33.5846527, -101.8724396)", "(33.5846949, -101.8724361)",
      5.131094328872745);
  graph.addEdge("(33.5846949, -101.8724361)", "(33.5847954, -101.8724422)",
      12.206170843272506);
  graph.addEdge("(33.5838826, -101.8733415)", "(33.5838825, -101.8732771)",
      6.538105777322651);
  graph.addEdge("(33.5838825, -101.8732771)", "(33.5838824, -101.8731964)",
      8.192931786705607);
  graph.addEdge("(33.5838824, -101.8731964)", "(33.5838816, -101.8726986)",
      50.538345884699005);
  graph.addEdge("(33.5838816, -101.8726986)", "(33.5838816, -101.8724307)",
      27.198067432381336);
  graph.addEdge("(33.5838816, -101.8724307)", "(33.5838819, -101.87213)",
      30.528050289529656);
  graph.addEdge("(33.5838819, -101.87213)", "(33.5838828, -101.8713448)",
      79.71609700577785);
  graph.addEdge("(33.5838828, -101.8713448)", "(33.5839042, -101.8713383)",
      2.678344354624248);
  graph.addEdge("(33.5841591, -101.8721314)", "(33.5838819, -101.87213)",
      33.62410720209388);
  graph.addEdge("(33.5838819, -101.87213)", "(33.5836763, -101.8721276)",
      24.940058958764904);
  graph.addEdge("(33.5836763, -101.8721276)", "(33.5836763, -101.8724296)",
      30.660081431838645);
  graph.addEdge("(33.5838569, -101.871225)", "(33.5838067, -101.8711931)",
      6.8968358271172105);
  graph.addEdge("(33.5838067, -101.8711931)", "(33.583772, -101.8711606)",
      5.348156153764812);
  graph.addEdge("(33.583772, -101.8711606)", "(33.5837008, -101.871125)",
      9.362178283491236);
  graph.addEdge("(33.5837008, -101.871125)", "(33.5836325, -101.8710902)",
      9.006535619765238);
  graph.addEdge("(33.5836325, -101.8710902)", "(33.5835459, -101.8710467)",
      11.39500042387726);
  graph.addEdge("(33.5835459, -101.8710467)", "(33.583446, -101.8709827)",
      13.749749363638678);
  graph.addEdge("(33.583446, -101.8709827)", "(33.5832977, -101.8708587)",
      21.95603693102472);
  graph.addEdge("(33.5832977, -101.8708587)", "(33.5832126, -101.870854)",
      10.33348158146655);
  graph.addEdge("(33.5832126, -101.870854)", "(33.5831271, -101.8708459)",
      10.403529897795591);
  graph.addEdge("(33.5831271, -101.8708459)", "(33.5830317, -101.870826)",
      11.746869167246565);
  graph.addEdge("(33.5830317, -101.870826)", "(33.5829403, -101.870777)",
      12.151585021217128);
  graph.addEdge("(33.5829403, -101.870777)", "(33.5828992, -101.8707594)",
      5.29588905904472);
  graph.addEdge("(33.5828992, -101.8707594)", "(33.5826996, -101.8707585)",
      24.211249294902164);
  graph.addEdge("(33.5826996, -101.8707585)", "(33.5825583, -101.8707668)",
      17.160106109587833);
  graph.addEdge("(33.5825583, -101.8707668)", "(33.5822987, -101.8707975)",
      31.642830875434548);
  graph.addEdge("(33.5822987, -101.8707975)", "(33.5818181, -101.8707922)",
      58.29828563440667);
  graph.addEdge("(33.5818181, -101.8707922)", "(33.5817833, -101.8708018)",
      4.3322284339868915);
  graph.addEdge("(33.5866844, -101.8750285)", "(33.5866847, -101.8751596)",
      13.309311978005454);
  graph.addEdge("(33.5866847, -101.8751596)", "(33.58694, -101.875159)",
      30.96745440210118);
  graph.addEdge("(33.58694, -101.875159)", "(33.5870882, -101.8751586)",
      17.97641881588853);
  graph.addEdge("(33.5870882, -101.8751586)", "(33.587139, -101.8751585)",
      6.161950068041226);
  graph.addEdge("(33.5864245, -101.8751559)", "(33.5866847, -101.8751596)",
      31.563988788159715);
  graph.addEdge("(33.5861639, -101.8751429)", "(33.5860776, -101.8751407)",
      10.470403703298398);
  graph.addEdge("(33.5860776, -101.8751407)", "(33.5858058, -101.8751413)",
      32.968864096137615);
  graph.addEdge("(33.5858058, -101.8751413)", "(33.5855685, -101.8751387)",
      28.785234421470278);
  graph.addEdge("(33.5861639, -101.8751429)", "(33.586076, -101.8750278)",
      15.818344398950588);
  graph.addEdge("(33.5823125, -101.8755591)", "(33.5823124, -101.8756243)",
      6.619444083748428);
  graph.addEdge("(33.5823124, -101.8756243)", "(33.5823123, -101.8757732)",
      15.117084168030043);
  graph.addEdge("(33.5823123, -101.8757732)", "(33.5823121, -101.8759241)",
      15.320148628063572);
  graph.addEdge("(33.5823121, -101.8759241)", "(33.5823121, -101.8759506)",
      2.6904137172463205);
  graph.addEdge("(33.5823121, -101.8759506)", "(33.5823114, -101.8766343)",
      69.41272614436166);
  graph.addEdge("(33.5823114, -101.8766343)", "(33.5823103, -101.8777111)",
      109.32225250231049);
  graph.addEdge("(33.5823103, -101.8777111)", "(33.582321, -101.8777426)",
      3.451371652994407);
  graph.addEdge("(33.582321, -101.8777426)", "(33.5823614, -101.8777683)",
      5.551772699777822);
  graph.addEdge("(33.5823121, -101.8759241)", "(33.5822184, -101.875923)",
      11.366168430457893);
  graph.addEdge("(33.5822184, -101.875923)", "(33.5820413, -101.8759217)",
      21.482275433115788);
  graph.addEdge("(33.5820413, -101.8759217)", "(33.5819584, -101.875921)",
      10.055852402391327);
  graph.addEdge("(33.5818023, -101.8710717)", "(33.5825651, -101.8710837)",
      92.53411060694643);
  graph.addEdge("(33.5825651, -101.8710837)", "(33.5827523, -101.8710854)",
      22.70763731533615);
  graph.addEdge("(33.5827523, -101.8710854)", "(33.5828959, -101.8710962)",
      17.45286638901935);
  graph.addEdge("(33.5828959, -101.8710962)", "(33.5828962, -101.8711958)",
      10.111891947412294);
  graph.addEdge("(33.5828962, -101.8711958)", "(33.5828944, -101.8713033)",
      10.916052761059882);
  graph.addEdge("(33.5828944, -101.8713033)", "(33.5828931, -101.8714854)",
      18.488259313490843);
  graph.addEdge("(33.5825651, -101.8710837)", "(33.5826933, -101.8707889)",
      33.72815410752284);
  graph.addEdge("(33.5826933, -101.8707889)", "(33.5826996, -101.8707585)",
      3.179545424271725);
  graph.addEdge("(33.5826996, -101.8707585)", "(33.5826983, -101.8707021)",
      5.7281578989120865);
  graph.addEdge("(33.5826983, -101.8707021)", "(33.5826969, -101.8705612)",
      14.305823314145067);
  graph.addEdge("(33.5827523, -101.8710854)", "(33.5826933, -101.8707889)",
      30.941058011182466);
  graph.addEdge("(33.5807991, -101.8770481)", "(33.5811344, -101.8770484)",
      40.67121214925365);
  graph.addEdge("(33.5811344, -101.8770484)", "(33.5814038, -101.8770487)",
      32.67768200671563);
  graph.addEdge("(33.5814038, -101.8770487)", "(33.5816755, -101.8770489)",
      32.956660794220554);
  graph.addEdge("(33.5816748, -101.8788048)", "(33.5811011, -101.8788083)",
      69.58954266346916);
  graph.addEdge("(33.5811011, -101.8788083)", "(33.5810906, -101.8788083)",
      1.2736284414245627);
  graph.addEdge("(33.5808635, -101.8778691)", "(33.5811272, -101.8778683)",
      31.986371196778133);
  graph.addEdge("(33.5811272, -101.8778683)", "(33.5812593, -101.877869)",
      16.02361664282806);
  graph.addEdge("(33.5812593, -101.877869)", "(33.5816451, -101.8778712)",
      46.79728364343611);
  graph.addEdge("(33.5814038, -101.8770487)", "(33.5814038, -101.8771745)",
      12.77198458566941);
  graph.addEdge("(33.5814038, -101.8771745)", "(33.5814038, -101.8774273)",
      25.665800504266198);
  graph.addEdge("(33.5815327, -101.8774278)", "(33.5812593, -101.877869)",
      55.73344723047324);
  graph.addEdge("(33.5807509, -101.8781147)", "(33.5808637, -101.8781152)",
      13.682501941063588);
  graph.addEdge("(33.5808637, -101.8781152)", "(33.5811263, -101.8781152)",
      31.852840335754536);
  graph.addEdge("(33.5802472, -101.8807745)", "(33.5802069, -101.8806954)",
      9.401578565094269);
  graph.addEdge("(33.5802069, -101.8806954)", "(33.5801712, -101.8806484)",
      6.443743359469201);
  graph.addEdge("(33.5801712, -101.8806484)", "(33.5801575, -101.8806375)",
      1.996545340553717);
  graph.addEdge("(33.5801575, -101.8806375)", "(33.5801477, -101.8806296)",
      1.434003954354556);
  graph.addEdge("(33.5801477, -101.8806296)", "(33.580112, -101.8806082)",
      4.844831766266427);
  graph.addEdge("(33.580112, -101.8806082)", "(33.5800673, -101.8805907)",
      5.70570374585516);
  graph.addEdge("(33.5800673, -101.8805907)", "(33.5800326, -101.8805747)",
      4.511631269385161);
  graph.addEdge("(33.5800326, -101.8805747)", "(33.5799991, -101.8805532)",
      4.612666455030774);
  graph.addEdge("(33.5799991, -101.8805532)", "(33.5799712, -101.8805304)",
      4.10016392754784);
  graph.addEdge("(33.5799712, -101.8805304)", "(33.5799343, -101.8804808)",
      6.7374101208021795);
  graph.addEdge("(33.5799343, -101.8804808)", "(33.5799086, -101.8804325)",
      5.810775952437988);
  graph.addEdge("(33.5799086, -101.8804325)", "(33.5798773, -101.8803668)",
      7.675177684064742);
  graph.addEdge("(33.5798773, -101.8803668)", "(33.5798539, -101.8802796)",
      9.29710176438103);
  graph.addEdge("(33.5798539, -101.8802796)", "(33.5798494, -101.8802313)",
      4.934084054613545);
  graph.addEdge("(33.5798494, -101.8802313)", "(33.5798494, -101.8801951)",
      3.6753110573766885);
  graph.addEdge("(33.5798494, -101.8801951)", "(33.5798561, -101.8801589)",
      3.7640915553930117);
  graph.addEdge("(33.5798561, -101.8801589)", "(33.5798556, -101.8801113)",
      4.833109641953171);
  graph.addEdge("(33.5798556, -101.8801113)", "(33.579855, -101.8800516)",
      6.061653913722749);
  graph.addEdge("(33.579855, -101.8800516)", "(33.5798796, -101.8799953)",
      6.448002076032515);
  graph.addEdge("(33.5798796, -101.8799953)", "(33.5798874, -101.8799497)",
      4.725358293221539);
  graph.addEdge("(33.5798874, -101.8799497)", "(33.5798896, -101.8798947)",
      5.590406359319309);
  graph.addEdge("(33.5798896, -101.8798947)", "(33.5798941, -101.8798424)",
      5.3378896868342975);
  graph.addEdge("(33.5798941, -101.8798424)", "(33.5798949, -101.8797649)",
      7.869008808883367);
  graph.addEdge("(33.5798949, -101.8797649)", "(33.5798952, -101.8797351)",
      3.0257495399327374);
  graph.addEdge("(33.5798952, -101.8797351)", "(33.5798863, -101.8796882)",
      4.882500886314247);
  graph.addEdge("(33.5798863, -101.8796882)", "(33.5798729, -101.8796466)",
      4.5255234168756795);
  graph.addEdge("(33.5798729, -101.8796466)", "(33.579855, -101.8796171)",
      3.6992859808011525);
  graph.addEdge("(33.579855, -101.8796171)", "(33.5798461, -101.8795889)",
      3.059853257841257);
  graph.addEdge("(33.5798461, -101.8795889)", "(33.5798438, -101.87955)",
      3.959278060986029);
  graph.addEdge("(33.5798438, -101.87955)", "(33.5798438, -101.8793644)",
      18.843584974583976);
  graph.addEdge("(33.5798438, -101.8793644)", "(33.5798438, -101.8792416)",
      12.467630576189853);
  graph.addEdge("(33.5798438, -101.8792416)", "(33.5798438, -101.8791254)",
      11.797546196069856);
  graph.addEdge("(33.5798438, -101.8791254)", "(33.5798439, -101.8787446)",
      38.661840019320294);
  graph.addEdge("(33.5801575, -101.8806375)", "(33.5801466, -101.8805653)",
      7.448572955288714);
  graph.addEdge("(33.5801466, -101.8805653)", "(33.5801254, -101.8804821)",
      8.829842746739878);
  graph.addEdge("(33.5801254, -101.8804821)", "(33.5800952, -101.8803869)",
      10.336321831127377);
  graph.addEdge("(33.5800952, -101.8803869)", "(33.580065, -101.8803131)",
      8.340274998049024);
  graph.addEdge("(33.580065, -101.8803131)", "(33.580017, -101.8802193)",
      11.162096666060723);
  graph.addEdge("(33.580017, -101.8802193)", "(33.579935, -101.8801116)",
      14.781599263669719);
  graph.addEdge("(33.5873059, -101.8800821)", "(33.5873662, -101.880018)",
      9.79002403450576);
  graph.addEdge("(33.5873662, -101.880018)", "(33.5873793, -101.8799963)",
      2.7162456284436924);
  graph.addEdge("(33.5873793, -101.8799963)", "(33.5873802, -101.8798586)",
      13.979607884488132);
  graph.addEdge("(33.5873802, -101.8798586)", "(33.5873803, -101.8798435)",
      1.532986561036458);
  graph.addEdge("(33.5873803, -101.8798435)", "(33.5873806, -101.8797904)",
      5.390787587471885);
  graph.addEdge("(33.5873806, -101.8797904)", "(33.5873819, -101.8795229)",
      27.156819615739437);
  graph.addEdge("(33.5873819, -101.8795229)", "(33.5873828, -101.8792546)",
      27.237795515480546);
  graph.addEdge("(33.5873828, -101.8792546)", "(33.5873837, -101.8789824)",
      27.633716615812663);
  graph.addEdge("(33.5873837, -101.8789824)", "(33.5873846, -101.8787019)",
      28.47631852967143);
  graph.addEdge("(33.5885775, -101.8800243)", "(33.5885555, -101.8800618)",
      4.649064476684747);
  graph.addEdge("(33.5885555, -101.8800618)", "(33.5885279, -101.8800945)",
      4.71464678976325);
  graph.addEdge("(33.5885279, -101.8800945)", "(33.5880792, -101.8800925)",
      54.42683097704553);
  graph.addEdge("(33.5880792, -101.8800925)", "(33.5879961, -101.8800629)",
      10.518244879909673);
  graph.addEdge("(33.5887132, -101.878172)", "(33.5886708, -101.878172)",
      5.14303927232103);
  graph.addEdge("(33.5886708, -101.878172)", "(33.5884933, -101.878172)",
      21.530411662713792);
  graph.addEdge("(33.5884933, -101.878172)", "(33.5884758, -101.8781731)",
      2.125651877646876);
  graph.addEdge("(33.5884758, -101.8781731)", "(33.5884638, -101.8781808)",
      1.6521924136280428);
  graph.addEdge("(33.5884638, -101.8781808)", "(33.5884555, -101.8781941)",
      1.684220922037931);
  graph.addEdge("(33.5884555, -101.8781941)", "(33.588427, -101.8782482)",
      6.4895426646212675);
  graph.addEdge("(33.588427, -101.8782482)", "(33.5883884, -101.8783122)",
      8.008434703711425);
  graph.addEdge("(33.5883884, -101.8783122)", "(33.588346, -101.8783608)",
      7.126918148508605);
  graph.addEdge("(33.588346, -101.8783608)", "(33.5882807, -101.8784238)",
      10.180504396816971);
  graph.addEdge("(33.5882807, -101.8784238)", "(33.5882154, -101.8784702)",
      9.21557164855131);
  graph.addEdge("(33.5882154, -101.8784702)", "(33.5881482, -101.8785033)",
      8.816680958358964);
  graph.addEdge("(33.5881482, -101.8785033)", "(33.5881133, -101.8785144)",
      4.380713638079065);
  graph.addEdge("(33.5881133, -101.8785144)", "(33.5880985, -101.8785265)",
      2.175242533258768);
  graph.addEdge("(33.5880985, -101.8785265)", "(33.5880875, -101.8785486)",
      2.6103322302618563);
  graph.addEdge("(33.5880875, -101.8785486)", "(33.5880847, -101.8785806)",
      3.266290980267352);
  graph.addEdge("(33.5880847, -101.8785806)", "(33.5880844, -101.8786609)",
      8.151999571793814);
  graph.addEdge("(33.5880844, -101.8786609)", "(33.5880827, -101.8791392)",
      48.55663453320753);
  graph.addEdge("(33.5880827, -101.8791392)", "(33.5880822, -101.8792563)",
      11.887946268527656);
  graph.addEdge("(33.5880822, -101.8792563)", "(33.5880819, -101.8793535)",
      9.867644766426285);
  graph.addEdge("(33.5880819, -101.8793535)", "(33.5880801, -101.8798447)",
      49.8662620398134);
  graph.addEdge("(33.5880801, -101.8798447)", "(33.5880792, -101.8800925)",
      25.15646952690631);
  graph.addEdge("(33.5880792, -101.8800925)", "(33.5880565, -101.8809825)",
      90.39323818344519);
  graph.addEdge("(33.5880565, -101.8809825)", "(33.5880921, -101.8810283)",
      6.345483199832902);
  graph.addEdge("(33.5880921, -101.8810283)", "(33.5880861, -101.8811054)",
      7.8608228187103375);
  graph.addEdge("(33.5880861, -101.8811054)", "(33.588082, -101.8811586)",
      5.423622090250626);
  graph.addEdge("(33.588082, -101.8811586)", "(33.5880682, -101.8811939)",
      3.9552681358372213);
  graph.addEdge("(33.5880682, -101.8811939)", "(33.5880525, -101.8812238)",
      3.583336630695061);
  graph.addEdge("(33.5880525, -101.8812238)", "(33.5878023, -101.8817837)",
      64.43489571949598);
  graph.addEdge("(33.5878023, -101.8817837)", "(33.5878367, -101.8818607)",
      8.860895284909363);
  graph.addEdge("(33.5880819, -101.8793535)", "(33.5881535, -101.87939)",
      9.442369431134509);
  graph.addEdge("(33.5881535, -101.87939)", "(33.5881986, -101.8794098)",
      5.828137698798462);
  graph.addEdge("(33.5881986, -101.8794098)", "(33.5882759, -101.8794121)",
      9.379248912800273);
  graph.addEdge("(33.5882759, -101.8794121)", "(33.5883431, -101.8794054)",
      8.179560380785492);
  graph.addEdge("(33.5883431, -101.8794054)", "(33.5883799, -101.8793922)",
      4.660572850428238);
  graph.addEdge("(33.5883799, -101.8793922)", "(33.5884075, -101.8793767)",
      3.6991806333245645);
  graph.addEdge("(33.5884075, -101.8793767)", "(33.5884277, -101.879356)",
      3.2279332288095564);
  graph.addEdge("(33.5884277, -101.879356)", "(33.5884856, -101.8793566)",
      7.0234236229459786);
  graph.addEdge("(33.5884856, -101.8793566)", "(33.5885335, -101.8793571)",
      5.810400343636576);
  graph.addEdge("(33.5884277, -101.8791572)", "(33.5884277, -101.8792268)",
      7.065644723162231);
  graph.addEdge("(33.5884277, -101.8792268)", "(33.5884277, -101.879288)",
      6.212894498127136);
  graph.addEdge("(33.5884277, -101.879288)", "(33.5884277, -101.879356)",
      6.903216108388948);
  graph.addEdge("(33.5880822, -101.8792563)", "(33.5879787, -101.8792552)",
      12.554848235838746);
  graph.addEdge("(33.587333, -101.878989)", "(33.5872175, -101.8792233)",
      27.60524905737383);
  graph.addEdge("(33.5875531, -101.8793838)", "(33.587579, -101.879381)",
      3.154453463748382);
  graph.addEdge("(33.587579, -101.879381)", "(33.5876069, -101.8793668)",
      3.6784558754605334);
  graph.addEdge("(33.5876069, -101.8793668)", "(33.5876269, -101.8793482)",
      3.0742118352148196);
  graph.addEdge("(33.5876269, -101.8793482)", "(33.5876462, -101.8793242)",
      3.378879125775498);
  graph.addEdge("(33.5876462, -101.8793242)", "(33.5876561, -101.8793009)",
      2.6527538237553965);
  graph.addEdge("(33.5876561, -101.8793009)", "(33.5876641, -101.8792555)",
      4.709999119091253);
  graph.addEdge("(33.5876641, -101.8792555)", "(33.5876599, -101.8792208)",
      3.5593494440986744);
  graph.addEdge("(33.5876599, -101.8792208)", "(33.5876462, -101.8791868)",
      3.830840110199646);
  graph.addEdge("(33.5876462, -101.8791868)", "(33.5876315, -101.8791641)",
      2.9137594848919344);
  graph.addEdge("(33.5876315, -101.8791641)", "(33.5876097, -101.8791436)",
      3.365031817707868);
  graph.addEdge("(33.5876097, -101.8791436)", "(33.5875899, -101.8791328)",
      2.640127422672924);
  graph.addEdge("(33.5875899, -101.8791328)", "(33.5875733, -101.8791266)",
      2.1096306463681693);
  graph.addEdge("(33.5875733, -101.8791266)", "(33.5875544, -101.8791243)",
      2.304393517879977);
  graph.addEdge("(33.5880801, -101.8798447)", "(33.5880395, -101.8798446)",
      4.924712658713918);
  graph.addEdge("(33.5880395, -101.8798446)", "(33.5879978, -101.8798446)",
      5.058130053442597);
  graph.addEdge("(33.5879978, -101.8798446)", "(33.5879961, -101.8800629)",
      22.16242352633738);
  graph.addEdge("(33.5880399, -101.8797554)", "(33.5880395, -101.8798446)",
      9.05556576599727);
  graph.addEdge("(33.5870865, -101.8789005)", "(33.5870876, -101.8788074)",
      9.452402941084848);
  graph.addEdge("(33.5870876, -101.8788074)", "(33.5870884, -101.8787433)",
      6.508120415937025);
  graph.addEdge("(33.5870884, -101.8787433)", "(33.5870888, -101.8786838)",
      6.0406022704788045);
  graph.addEdge("(33.5870888, -101.8786838)", "(33.5870896, -101.8785785)",
      10.690438675128702);
  graph.addEdge("(33.5869591, -101.8787385)", "(33.5869569, -101.878749)",
      1.0988511592567525);
  graph.addEdge("(33.5869569, -101.878749)", "(33.5869522, -101.8787605)",
      1.2992359626661545);
  graph.addEdge("(33.5869522, -101.8787605)", "(33.5869446, -101.8787705)",
      1.3712982281788275);
  graph.addEdge("(33.5869446, -101.8787705)", "(33.5869341, -101.8787764)",
      1.4074418316920847);
  graph.addEdge("(33.5869341, -101.8787764)", "(33.5869236, -101.878778)",
      1.2839456517584866);
  graph.addEdge("(33.5869236, -101.878778)", "(33.5869139, -101.8787759)",
      1.195749703416673);
  graph.addEdge("(33.5869139, -101.8787759)", "(33.5869082, -101.878773)",
      0.7514705540091707);
  graph.addEdge("(33.5869082, -101.878773)", "(33.5869064, -101.8787714)",
      0.27213013838055394);
  graph.addEdge("(33.5869064, -101.8787714)", "(33.5869016, -101.8787673)",
      0.7157098060647984);
  graph.addEdge("(33.5869016, -101.8787673)", "(33.5868957, -101.8787586)",
      1.136770341501574);
  graph.addEdge("(33.5868957, -101.8787586)", "(33.5868924, -101.8787467)",
      1.2726721418053528);
  graph.addEdge("(33.5868924, -101.8787467)", "(33.586892, -101.8787324)",
      1.452542025215901);
  graph.addEdge("(33.586892, -101.8787324)", "(33.5868953, -101.8787205)",
      1.272672148344855);
  graph.addEdge("(33.5868953, -101.8787205)", "(33.5869006, -101.8787105)",
      1.2016317192196917);
  graph.addEdge("(33.5869006, -101.8787105)", "(33.586909, -101.8787037)",
      1.2307418276593818);
  graph.addEdge("(33.586909, -101.8787037)", "(33.5869132, -101.8787018)",
      0.5447446429061961);
  graph.addEdge("(33.5869132, -101.8787018)", "(33.5869187, -101.8786995)",
      0.7068202767586496);
  graph.addEdge("(33.5869187, -101.8786995)", "(33.5869287, -101.8786988)",
      1.215060503932373);
  graph.addEdge("(33.5869287, -101.8786988)", "(33.5869378, -101.8787009)",
      1.1242118240129273);
  graph.addEdge("(33.5869378, -101.8787009)", "(33.5869462, -101.8787079)",
      1.242244040781502);
  graph.addEdge("(33.5869462, -101.8787079)", "(33.5869522, -101.8787163)",
      1.1211082302926825);
  graph.addEdge("(33.5869522, -101.8787163)", "(33.5869573, -101.8787266)",
      1.214939873381565);
  graph.addEdge("(33.5869064, -101.8787714)", "(33.586899, -101.8787839)",
      1.5543636749032899);
  graph.addEdge("(33.586899, -101.8787839)", "(33.5868909, -101.8787929)",
      1.3416930327096708);
  graph.addEdge("(33.5868909, -101.8787929)", "(33.5868735, -101.8788069)",
      2.544523333982174);
  graph.addEdge("(33.5868735, -101.8788069)", "(33.5868569, -101.8788183)",
      2.3224502764641284);
  graph.addEdge("(33.5868569, -101.8788183)", "(33.5868341, -101.8788315)",
      3.0731550803791565);
  graph.addEdge("(33.5868341, -101.8788315)", "(33.5868149, -101.8788392)",
      2.456611363782251);
  graph.addEdge("(33.5868149, -101.8788392)", "(33.5868, -101.8788433)",
      1.854650941809965);
  graph.addEdge("(33.5868, -101.8788433)", "(33.5867874, -101.8788452)",
      1.5404792401167282);
  graph.addEdge("(33.5867874, -101.8788452)", "(33.5867707, -101.8788454)",
      2.025779329901471);
  graph.addEdge("(33.5869132, -101.8787018)", "(33.5869007, -101.8786737)",
      3.2306118023680668);
  graph.addEdge("(33.5869007, -101.8786737)", "(33.5868891, -101.8786497)",
      2.813575674808659);
  graph.addEdge("(33.5868891, -101.8786497)", "(33.58688, -101.8786333)",
      1.9975910725824586);
  graph.addEdge("(33.58688, -101.8786333)", "(33.5868727, -101.8786228)",
      1.3857602573467316);
  graph.addEdge("(33.5868727, -101.8786228)", "(33.5868634, -101.8786122)",
      1.559024303010762);
  graph.addEdge("(33.5868634, -101.8786122)", "(33.5868558, -101.8786059)",
      1.122003012559858);
  graph.addEdge("(33.5868558, -101.8786059)", "(33.5868443, -101.8785979)",
      1.6141324700132995);
  graph.addEdge("(33.5868443, -101.8785979)", "(33.5868293, -101.8785899)",
      1.9925046863953066);
  graph.addEdge("(33.5868293, -101.8785899)", "(33.5868149, -101.8785831)",
      1.8781625885990147);
  graph.addEdge("(33.5868149, -101.8785831)", "(33.5867975, -101.8785769)",
      2.202441169222184);
  graph.addEdge("(33.5867975, -101.8785769)", "(33.5867818, -101.8785712)",
      1.9903547630675444);
  graph.addEdge("(33.5867818, -101.8785712)", "(33.5867688, -101.878568)",
      1.6099907604093524);
  graph.addEdge("(33.5867688, -101.878568)", "(33.5867538, -101.8785661)",
      1.8296666115459874);
  graph.addEdge("(33.5866537, -101.8792919)", "(33.5866534, -101.8793419)",
      5.076128524261111);
  graph.addEdge("(33.5866534, -101.8793419)", "(33.586653, -101.8794045)",
      6.355334844760519);
  graph.addEdge("(33.586653, -101.8794045)", "(33.586649, -101.879859)",
      46.143374929187125);
  graph.addEdge("(33.586649, -101.879859)", "(33.5866487, -101.8798915)",
      3.2995996026059253);
  graph.addEdge("(33.5866487, -101.8798915)", "(33.5866471, -101.8800775)",
      18.883711459859985);
  graph.addEdge("(33.5866471, -101.8800775)", "(33.5866609, -101.8800895)",
      2.0702881137933407);
  graph.addEdge("(33.5866609, -101.8800895)", "(33.5866909, -101.8801713)",
      9.066631436063503);
  graph.addEdge("(33.5866909, -101.8801713)", "(33.5867654, -101.8802334)",
      11.018498194828707);
  graph.addEdge("(33.5867654, -101.8802334)", "(33.5867947, -101.8801767)",
      6.764960011979927);
  graph.addEdge("(33.5867947, -101.8801767)", "(33.5869348, -101.8802611)",
      19.03171993553773);
  graph.addEdge("(33.5869348, -101.8802611)", "(33.5871751, -101.8804075)",
      32.71840527769151);
  graph.addEdge("(33.5871751, -101.8804075)", "(33.587228, -101.8804493)",
      7.692917609156452);
  graph.addEdge("(33.587228, -101.8804493)", "(33.5872398, -101.8804586)",
      1.7146571343631176);
  graph.addEdge("(33.5872398, -101.8804586)", "(33.5873343, -101.8805192)",
      13.009252318023178);
  graph.addEdge("(33.5873343, -101.8805192)", "(33.5873789, -101.8805478)",
      6.13978490877915);
  graph.addEdge("(33.5873789, -101.8805478)", "(33.5879168, -101.8808928)",
      74.05235100698566);
  graph.addEdge("(33.5879168, -101.8808928)", "(33.5880565, -101.8809825)",
      19.237138723604065);
  graph.addEdge("(33.5866939, -101.879251)", "(33.5867332, -101.879251)",
      4.7670136473330516);
  graph.addEdge("(33.5867332, -101.879251)", "(33.5870365, -101.8792526)",
      36.790060343330765);
  graph.addEdge("(33.5870365, -101.8792526)", "(33.5872174, -101.8792536)",
      21.943054855887333);
  graph.addEdge("(33.5872174, -101.8792536)", "(33.5873828, -101.8792546)",
      20.062957411132054);
  graph.addEdge("(33.5873828, -101.8792546)", "(33.5875544, -101.8792557)",
      20.81504871233645);
  graph.addEdge("(33.5875544, -101.8792557)", "(33.5876641, -101.8792555)",
      13.30641429388579);
  graph.addEdge("(33.5876641, -101.8792555)", "(33.5877005, -101.8792554)",
      4.415261644373166);
  graph.addEdge("(33.5867332, -101.879251)", "(33.5867322, -101.8792706)",
      1.9934831856676172);
  graph.addEdge("(33.5867322, -101.8792706)", "(33.5867279, -101.8792871)",
      1.754403988694757);
  graph.addEdge("(33.5867279, -101.8792871)", "(33.5867197, -101.879303)",
      1.8960086942505336);
  graph.addEdge("(33.5867197, -101.879303)", "(33.58671, -101.8793154)",
      1.7230965171104649);
  graph.addEdge("(33.58671, -101.8793154)", "(33.586696, -101.8793284)",
      2.1507101167083125);
  graph.addEdge("(33.586696, -101.8793284)", "(33.5866791, -101.8793382)",
      2.2786089797428346);
  graph.addEdge("(33.5866791, -101.8793382)", "(33.5866645, -101.879342)",
      1.812482440658154);
  graph.addEdge("(33.5866645, -101.879342)", "(33.5866534, -101.8793419)",
      1.34644669541981);
  graph.addEdge("(33.5866534, -101.8793419)", "(33.5866402, -101.8793417)",
      1.601263071164622);
  graph.addEdge("(33.5866402, -101.8793417)", "(33.5866217, -101.8793366)",
      2.3029689587727002);
  graph.addEdge("(33.5866217, -101.8793366)", "(33.5866077, -101.8793284)",
      1.8912395887796236);
  graph.addEdge("(33.5866077, -101.8793284)", "(33.5865932, -101.8793119)",
      2.4288574367559557);
  graph.addEdge("(33.5865932, -101.8793119)", "(33.5865829, -101.8792947)",
      2.1470785928096165);
  graph.addEdge("(33.5865829, -101.8792947)", "(33.5865768, -101.8792729)",
      2.3335497520065256);
  graph.addEdge("(33.5865768, -101.8792729)", "(33.5865756, -101.8792513)",
      2.19765879383289);
  graph.addEdge("(33.5865756, -101.8792513)", "(33.5865776, -101.8792294)",
      2.2364855151348033);
  graph.addEdge("(33.5865776, -101.8792294)", "(33.5865813, -101.8792196)",
      1.091440769317631);
  graph.addEdge("(33.5865813, -101.8792196)", "(33.5865911, -101.8791999)",
      2.326550380613095);
  graph.addEdge("(33.5865911, -101.8791999)", "(33.5866032, -101.8791831)",
      2.25011486579527);
  graph.addEdge("(33.5866032, -101.8791831)", "(33.5866154, -101.8791717)",
      1.878649476843631);
  graph.addEdge("(33.5866154, -101.8791717)", "(33.5866333, -101.8791628)",
      2.351728097628081);
  graph.addEdge("(33.5866333, -101.8791628)", "(33.5866471, -101.8791603)",
      1.6930445083431571);
  graph.addEdge("(33.5866471, -101.8791603)", "(33.5866566, -101.8791603)",
      1.1523315319277476);
  graph.addEdge("(33.5866566, -101.8791603)", "(33.5866651, -101.8791603)",
      1.0310334770445075);
  graph.addEdge("(33.5866651, -101.8791603)", "(33.5866872, -101.8791672)",
      2.770697721924285);
  graph.addEdge("(33.5866872, -101.8791672)", "(33.5867028, -101.8791771)",
      2.142598568673768);
  graph.addEdge("(33.5867028, -101.8791771)", "(33.5867142, -101.8791917)",
      2.0270714313195928);
  graph.addEdge("(33.5867142, -101.8791917)", "(33.586724, -101.8792078)",
      2.0210270121988887);
  graph.addEdge("(33.586724, -101.8792078)", "(33.5867311, -101.879225)",
      1.9469732227981842);
  graph.addEdge("(33.5866939, -101.879251)", "(33.5866917, -101.8792646)",
      1.4062233071089778);
  graph.addEdge("(33.5866917, -101.8792646)", "(33.5866862, -101.8792757)",
      1.3095470091495967);
  graph.addEdge("(33.5866862, -101.8792757)", "(33.5866769, -101.8792852)",
      1.4841460462235598);
  graph.addEdge("(33.5866769, -101.8792852)", "(33.5866656, -101.8792913)",
      1.5040705534535463);
  graph.addEdge("(33.5866656, -101.8792913)", "(33.5866537, -101.8792919)",
      1.4447315084042733);
  graph.addEdge("(33.5866537, -101.8792919)", "(33.5866426, -101.8792887)",
      1.3850459149363454);
  graph.addEdge("(33.5866426, -101.8792887)", "(33.5866341, -101.8792817)",
      1.2522136512228714);
  graph.addEdge("(33.5866341, -101.8792817)", "(33.5866267, -101.8792719)",
      1.339967785731389);
  graph.addEdge("(33.5866267, -101.8792719)", "(33.5866236, -101.8792608)",
      1.1879538753950074);
  graph.addEdge("(33.5866236, -101.8792608)", "(33.5866236, -101.8792513)",
      0.9644399692132013);
  graph.addEdge("(33.5866236, -101.8792513)", "(33.5866236, -101.8792446)",
      0.6801839790009556);
  graph.addEdge("(33.5866236, -101.8792446)", "(33.5866249, -101.8792364)",
      0.8472671355015088);
  graph.addEdge("(33.5866249, -101.8792364)", "(33.5866296, -101.8792269)",
      1.1203389520759672);
  graph.addEdge("(33.5866296, -101.8792269)", "(33.586637, -101.8792174)",
      1.3175128399639306);
  graph.addEdge("(33.586637, -101.8792174)", "(33.5866468, -101.8792123)",
      1.296581848569632);
  graph.addEdge("(33.5866468, -101.8792123)", "(33.5866566, -101.8792101)",
      1.2095205665896291);
  graph.addEdge("(33.5866566, -101.8792101)", "(33.5866677, -101.879211)",
      1.3495050004904567);
  graph.addEdge("(33.5866677, -101.879211)", "(33.5866775, -101.8792167)",
      1.3220851443118908);
  graph.addEdge("(33.5866775, -101.8792167)", "(33.5866849, -101.8792246)",
      1.2037075160207915);
  graph.addEdge("(33.5866849, -101.8792246)", "(33.5866904, -101.8792342)",
      1.1810601030275123);
  graph.addEdge("(33.5866904, -101.8792342)", "(33.5866931, -101.8792418)",
      0.8381830829622429);
  graph.addEdge("(33.5866566, -101.8792101)", "(33.5866566, -101.8791603)",
      5.055693919082866);
  graph.addEdge("(33.5866566, -101.8791603)", "(33.5866569, -101.8790987)",
      6.25373528756718);
  graph.addEdge("(33.5863834, -101.8794369)", "(33.5863846, -101.8792511)",
      18.863029163951204);
  graph.addEdge("(33.5858982, -101.8792503)", "(33.5859542, -101.8792497)",
      6.792963444998171);
  graph.addEdge("(33.5859542, -101.8792497)", "(33.5860386, -101.879249)",
      10.237801484298307);
  graph.addEdge("(33.5860386, -101.879249)", "(33.5861728, -101.8792484)",
      16.278311638408184);
  graph.addEdge("(33.5861728, -101.8792484)", "(33.5863846, -101.8792511)",
      25.692388923674805);
  graph.addEdge("(33.5863846, -101.8792511)", "(33.5865531, -101.8792516)",
      20.43878485831613);
  graph.addEdge("(33.5865531, -101.8792516)", "(33.5865756, -101.8792513)",
      2.7293761499466);
  graph.addEdge("(33.5865756, -101.8792513)", "(33.5866236, -101.8792513)",
      5.822306637308107);
  graph.addEdge("(33.586039, -101.8791732)", "(33.585955, -101.8791725)",
      10.18928344256201);
  graph.addEdge("(33.586038, -101.8793281)", "(33.5859535, -101.8793275)",
      10.249865637148048);
  graph.addEdge("(33.5859574, -101.878779)", "(33.5860403, -101.87878)",
      10.056120237797401);
  graph.addEdge("(33.5858453, -101.8775493)", "(33.5858677, -101.87755)",
      2.7180052850888154);
  graph.addEdge("(33.5858677, -101.87755)", "(33.5859426, -101.8775506)",
      9.085427489009689);
  graph.addEdge("(33.5859426, -101.8775506)", "(33.5859469, -101.8775278)",
      2.37271223088054);
  graph.addEdge("(33.5859469, -101.8775278)", "(33.5859567, -101.877505)",
      2.602070767571533);
  graph.addEdge("(33.5859567, -101.877505)", "(33.5859675, -101.8774934)",
      1.7615299074113537);
  graph.addEdge("(33.5859675, -101.8774934)", "(33.5859714, -101.8774893)",
      0.6301108516229195);
  graph.addEdge("(33.5859714, -101.8774893)", "(33.585992, -101.8774822)",
      2.6006246870217926);
  graph.addEdge("(33.585992, -101.8774822)", "(33.5860121, -101.8774822)",
      2.438090667934263);
  graph.addEdge("(33.5860121, -101.8774822)", "(33.5860238, -101.8774878)",
      1.5288238756788577);
  graph.addEdge("(33.5860238, -101.8774878)", "(33.5860331, -101.8774993)",
      1.6234451603052988);
  graph.addEdge("(33.5860331, -101.8774993)", "(33.586041, -101.8775218)",
      2.4770732119477);
  graph.addEdge("(33.586041, -101.8775218)", "(33.586043, -101.8775519)",
      3.065387067218774);
  graph.addEdge("(33.586043, -101.8775519)", "(33.5860374, -101.8775812)",
      3.0511292004995587);
  graph.addEdge("(33.5860374, -101.8775812)", "(33.5860321, -101.8775905)",
      1.1422342435062314);
  graph.addEdge("(33.5860321, -101.8775905)", "(33.5860262, -101.8776006)",
      1.250411174459698);
  graph.addEdge("(33.5860262, -101.8776006)", "(33.5860087, -101.8776077)",
      2.2417561310090974);
  graph.addEdge("(33.5860087, -101.8776077)", "(33.5859863, -101.8776081)",
      2.7173796076851393);
  graph.addEdge("(33.5859863, -101.8776081)", "(33.5859724, -101.8776026)",
      1.7760942555395531);
  graph.addEdge("(33.5859724, -101.8776026)", "(33.5859589, -101.8775895)",
      2.1095440560263055);
  graph.addEdge("(33.5859589, -101.8775895)", "(33.5859493, -101.8775725)",
      2.0819556735688862);
  graph.addEdge("(33.5859493, -101.8775725)", "(33.5859426, -101.8775506)",
      2.367184556671324);
  graph.addEdge("(33.5860321, -101.8775905)", "(33.5860462, -101.8776263)",
      4.016751341519557);
  graph.addEdge("(33.5860462, -101.8776263)", "(33.5860959, -101.8782751)",
      66.14190159770544);
  graph.addEdge("(33.5859956, -101.8784171)", "(33.5860133, -101.8783265)",
      9.445031100877323);
  graph.addEdge("(33.5860133, -101.8783265)", "(33.5860196, -101.8782733)",
      5.454695800153699);
  graph.addEdge("(33.5860196, -101.8782733)", "(33.5860554, -101.8779327)",
      34.84955245915539);
  graph.addEdge("(33.5860554, -101.8779327)", "(33.5860558, -101.8778794)",
      5.411268812787065);
  graph.addEdge("(33.5860558, -101.8778794)", "(33.5860476, -101.8777667)",
      11.484531902218407);
  graph.addEdge("(33.5860476, -101.8777667)", "(33.5860394, -101.8776994)",
      6.904361457387203);
  graph.addEdge("(33.5860394, -101.8776994)", "(33.5860087, -101.8776077)",
      10.026608713577613);
  graph.addEdge("(33.5859675, -101.8774934)", "(33.5858996, -101.8772682)",
      24.30076514974303);
  graph.addEdge("(33.5858996, -101.8772682)", "(33.5858988, -101.8772261)",
      4.275129033244625);
  graph.addEdge("(33.5858988, -101.8772261)", "(33.5858988, -101.8769516)",
      27.867472145609405);
  graph.addEdge("(33.5858431, -101.876947)", "(33.5858549, -101.8769469)",
      1.4313528780787743);
  graph.addEdge("(33.5858549, -101.8769469)", "(33.5858697, -101.8769469)",
      1.795210998785751);
  graph.addEdge("(33.5858697, -101.8769469)", "(33.5858905, -101.8769466)",
      2.5231830692296056);
  graph.addEdge("(33.5858726, -101.8765677)", "(33.5858524, -101.8766028)",
      4.324497631632838);
  graph.addEdge("(33.5858524, -101.8766028)", "(33.5858333, -101.8766304)",
      3.635739778685329);
  graph.addEdge("(33.5858333, -101.8766304)", "(33.5858162, -101.8766514)",
      2.9744675866138217);
  graph.addEdge("(33.5858162, -101.8766514)", "(33.5858006, -101.8766673)",
      2.4872062679748312);
  graph.addEdge("(33.5858006, -101.8766673)", "(33.5857787, -101.876678)",
      2.869947179037448);
  graph.addEdge("(33.5857787, -101.876678)", "(33.5857737, -101.8766804)",
      0.653602217961953);
  graph.addEdge("(33.5857737, -101.8766804)", "(33.5857257, -101.8767066)",
      6.4010976546617995);
  graph.addEdge("(33.5857257, -101.8767066)", "(33.5856841, -101.87673)",
      5.577234258972297);
  graph.addEdge("(33.5856841, -101.87673)", "(33.5856499, -101.8767464)",
      4.470034621657819);
  graph.addEdge("(33.5856499, -101.8767464)", "(33.5851077, -101.8767465)",
      65.76779318463423);
  graph.addEdge("(33.5851077, -101.8767465)", "(33.5850751, -101.8767465)",
      3.954315627191465);
  graph.addEdge("(33.5858549, -101.8769469)", "(33.5858694, -101.8769339)",
      2.1989202636498844);
  graph.addEdge("(33.5858694, -101.8769339)", "(33.5858905, -101.8769466)",
      2.8657989353915965);
  graph.addEdge("(33.5858905, -101.8769466)", "(33.5858988, -101.8769516)",
      1.127499642604597);
  graph.addEdge("(33.5858988, -101.8769516)", "(33.5859385, -101.8769769)",
      5.457694015335152);
  graph.addEdge("(33.5859385, -101.8769769)", "(33.5859962, -101.8770143)",
      7.9624639470334415);
  graph.addEdge("(33.5859962, -101.8770143)", "(33.5860083, -101.8771064)",
      9.464552822411761);
  graph.addEdge("(33.5860083, -101.8771064)", "(33.5860246, -101.8774665)",
      36.61103355534186);
  graph.addEdge("(33.5860246, -101.8774665)", "(33.5860238, -101.8774878)",
      2.1645671157758186);
  graph.addEdge("(33.58577, -101.8766534)", "(33.5857787, -101.876678)",
      2.711223304949028);
  graph.addEdge("(33.5857787, -101.876678)", "(33.5857928, -101.8767103)",
      3.6983525911870467);
  graph.addEdge("(33.5857928, -101.8767103)", "(33.5858111, -101.8767382)",
      3.598610152476831);
  graph.addEdge("(33.5858111, -101.8767382)", "(33.5858331, -101.8767576)",
      3.3166474423224312);
  graph.addEdge("(33.5858331, -101.8767576)", "(33.5858738, -101.8767842)",
      5.627144475981909);
  graph.addEdge("(33.5858738, -101.8767842)", "(33.5859263, -101.8768206)",
      7.3626744078243735);
  graph.addEdge("(33.5859263, -101.8768206)", "(33.585961, -101.8768408)",
      4.682038838088352);
  graph.addEdge("(33.585961, -101.8768408)", "(33.5860085, -101.8768698)",
      6.470272487319406);
  graph.addEdge("(33.5860085, -101.8768698)", "(33.5860362, -101.8768801)",
      3.5189081568143736);
  graph.addEdge("(33.5860362, -101.8768801)", "(33.5860675, -101.8768833)",
      3.8105023442863515);
  graph.addEdge("(33.5860675, -101.8768833)", "(33.5861141, -101.8768768)",
      5.69087670459092);
  graph.addEdge("(33.5861141, -101.8768768)", "(33.5861186, -101.8768765)",
      0.5466902213824757);
  graph.addEdge("(33.5861186, -101.8768765)", "(33.586162, -101.8768729)",
      5.277006376972268);
  graph.addEdge("(33.586162, -101.8768729)", "(33.5862058, -101.8768693)",
      5.325410174473437);
  graph.addEdge("(33.5862058, -101.8768693)", "(33.5862228, -101.8768774)",
      2.219982630429135);
  graph.addEdge("(33.5862228, -101.8768774)", "(33.5862461, -101.8768774)",
      2.8262445124947524);
  graph.addEdge("(33.5862461, -101.8768774)", "(33.5862976, -101.8768721)",
      6.269978889331692);
  graph.addEdge("(33.5862976, -101.8768721)", "(33.5863508, -101.8768666)",
      6.477167807121212);
  graph.addEdge("(33.5859263, -101.8768206)", "(33.5859193, -101.8768335)",
      1.5607845037281356);
  graph.addEdge("(33.5863508, -101.8768666)", "(33.5863548, -101.8769319)",
      6.647008233052217);
  graph.addEdge("(33.5863548, -101.8769319)", "(33.586358, -101.8769853)",
      5.435062574740725);
  graph.addEdge("(33.5862058, -101.8768693)", "(33.5861998, -101.876847)",
      2.3780139467234767);
  graph.addEdge("(33.5861998, -101.876847)", "(33.5861936, -101.8767525)",
      9.623118274626245);
  graph.addEdge("(33.5861936, -101.8767525)", "(33.5861988, -101.8767476)",
      0.8033071040864648);
  graph.addEdge("(33.5861988, -101.8767476)", "(33.5862976, -101.8768721)",
      17.417633056167872);
  graph.addEdge("(33.586207, -101.8763567)", "(33.586207, -101.8764428)",
      8.740913738318046);
  graph.addEdge("(33.586207, -101.8764428)", "(33.586207, -101.8766717)",
      23.238038961293256);
  graph.addEdge("(33.586207, -101.8766717)", "(33.58619, -101.8766686)",
      2.0859444137664966);
  graph.addEdge("(33.58619, -101.8766686)", "(33.5861756, -101.8766557)",
      2.183122294289184);
  graph.addEdge("(33.5861756, -101.8766557)", "(33.586152, -101.8765921)",
      7.062841199591874);
  graph.addEdge("(33.586152, -101.8765921)", "(33.5861397, -101.8765353)",
      5.956253667536939);
  graph.addEdge("(33.5861397, -101.8765353)", "(33.5861412, -101.8764681)",
      6.824607639021218);
  graph.addEdge("(33.5861412, -101.8764681)", "(33.5861427, -101.8763989)",
      7.02757855636512);
  graph.addEdge("(33.58628, -101.876204)", "(33.5862548, -101.8762077)",
      3.0797038138439503);
  graph.addEdge("(33.5862548, -101.8762077)", "(33.5861949, -101.8762433)",
      8.114991823954766);
  graph.addEdge("(33.5861949, -101.8762433)", "(33.5861565, -101.8762746)",
      5.638493851723398);
  graph.addEdge("(33.5861565, -101.8762746)", "(33.5861363, -101.8762998)",
      3.5423963165527512);
  graph.addEdge("(33.5861363, -101.8762998)", "(33.5860939, -101.8763695)",
      8.74759387946751);
  graph.addEdge("(33.5860939, -101.8763695)", "(33.5860715, -101.876458)",
      9.3864319694479);
  graph.addEdge("(33.5860715, -101.876458)", "(33.5860604, -101.8765385)",
      8.282580419701597);
  graph.addEdge("(33.5860604, -101.8765385)", "(33.586076, -101.8766109)",
      7.589763019686832);
  graph.addEdge("(33.586076, -101.8766109)", "(33.5861028, -101.8766887)",
      8.541125975110164);
  graph.addEdge("(33.5861028, -101.8766887)", "(33.5861126, -101.8767859)",
      9.939143921052084);
  graph.addEdge("(33.5861126, -101.8767859)", "(33.5861186, -101.8768765)",
      9.226514407162583);
  graph.addEdge("(33.5855706, -101.877547)", "(33.5853092, -101.8775477)",
      31.707385249988494);
  graph.addEdge("(33.5853092, -101.8775477)", "(33.5851344, -101.8775482)",
      21.202956039612957);
  graph.addEdge("(33.5851344, -101.8775482)", "(33.5850645, -101.8775481)",
      8.478738061410294);
  graph.addEdge("(33.5850645, -101.8775481)", "(33.5850041, -101.8775481)",
      7.326400663976483);
  graph.addEdge("(33.5850041, -101.8775481)", "(33.5848695, -101.877548)",
      16.326716957877046);
  graph.addEdge("(33.5844783, -101.8781752)", "(33.584514, -101.8781746)",
      4.3307674902864965);
  graph.addEdge("(33.584514, -101.8781746)", "(33.5846409, -101.8780766)",
      18.32818167026704);
  graph.addEdge("(33.5846409, -101.8780766)", "(33.5846912, -101.8780529)",
      6.558578761648963);
  graph.addEdge("(33.5846912, -101.8780529)", "(33.5847549, -101.8780275)",
      8.145621656552143);
  graph.addEdge("(33.5847549, -101.8780275)", "(33.5848661, -101.8779658)",
      14.87185057490828);
  graph.addEdge("(33.5848661, -101.8779658)", "(33.5848672, -101.8778696)",
      9.767333035236481);
  graph.addEdge("(33.5848695, -101.877548)", "(33.5848712, -101.8773004)",
      25.137705391700212);
  graph.addEdge("(33.5848712, -101.8773004)", "(33.5848714, -101.8772738)",
      2.700595468555573);
  graph.addEdge("(33.5848714, -101.8772738)", "(33.5848743, -101.8768449)",
      43.54422690003819);
  graph.addEdge("(33.5848743, -101.8768449)", "(33.584875, -101.8767426)",
      10.386052292932517);
  graph.addEdge("(33.584875, -101.8767426)", "(33.5848733, -101.8766488)",
      9.525000229069626);
  graph.addEdge("(33.5844392, -101.8776396)", "(33.5845004, -101.8776415)",
      7.425944072946804);
  graph.addEdge("(33.5845004, -101.8776415)", "(33.5845342, -101.8776293)",
      4.282875586174924);
  graph.addEdge("(33.5845342, -101.8776293)", "(33.5848712, -101.8773004)",
      52.78163580104983);
  graph.addEdge("(33.5848405, -101.8772738)", "(33.5848714, -101.8772738)",
      3.7481088418294415);
  graph.addEdge("(33.5848714, -101.8772738)", "(33.5850704, -101.8772732)",
      24.138383428514523);
  graph.addEdge("(33.5850645, -101.8775481)", "(33.5850639, -101.8776252)",
      7.8276709044192065);
  graph.addEdge("(33.5850639, -101.8776252)", "(33.5850036, -101.8776259)",
      7.31461608722781);
  graph.addEdge("(33.5850036, -101.8776259)", "(33.5850041, -101.8775481)",
      7.898636184197141);
  graph.addEdge("(33.583991, -101.8786972)", "(33.5841834, -101.8788001)",
      25.569195417076084);
  graph.addEdge("(33.5841834, -101.8788001)", "(33.5845023, -101.8788703)",
      39.332997859838635);
  graph.addEdge("(33.5845023, -101.8788703)", "(33.5849466, -101.8789683)",
      54.80337826206096);
  graph.addEdge("(33.583801, -101.8807309)", "(33.5839337, -101.8806615)",
      17.57074701124823);
  graph.addEdge("(33.5839337, -101.8806615)", "(33.584664, -101.8804262)",
      91.7483759714054);
  graph.addEdge("(33.5851942, -101.8803984)", "(33.5851497, -101.8804227)",
      5.934796829861361);
  graph.addEdge("(33.5851497, -101.8804227)", "(33.5851285, -101.8804343)",
      2.828351141648499);
  graph.addEdge("(33.5851285, -101.8804343)", "(33.5851195, -101.8804335)",
      1.0946992116771614);
  graph.addEdge("(33.5851195, -101.8804335)", "(33.5851131, -101.880425)",
      1.1607367929150219);
  graph.addEdge("(33.5851131, -101.880425)", "(33.5850664, -101.8803107)",
      12.912758823685722);
  graph.addEdge("(33.5850664, -101.8803107)", "(33.5850197, -101.8801964)",
      12.912764421857704);
  graph.addEdge("(33.5850197, -101.8801964)", "(33.5849828, -101.8801847)",
      4.630824780292803);
  graph.addEdge("(33.5849828, -101.8801847)", "(33.5842404, -101.8800145)",
      91.69441958799085);
  graph.addEdge("(33.5837121, -101.8801668)", "(33.5838143, -101.8801431)",
      12.628000687988479);
  graph.addEdge("(33.5838143, -101.8801431)", "(33.5840861, -101.8800654)",
      33.89937473492768);
  graph.addEdge("(33.5840861, -101.8800654)", "(33.5841267, -101.8800538)",
      5.063551940246124);
  graph.addEdge("(33.5840861, -101.8800654)", "(33.5840838, -101.8799898)",
      7.680205304808771);
  graph.addEdge("(33.5840838, -101.8799898)", "(33.5840843, -101.8799267)",
      6.406386554633851);
  graph.addEdge("(33.5840843, -101.8799267)", "(33.5840845, -101.8799112)",
      1.5737930324605256);
  graph.addEdge("(33.5840845, -101.8799112)", "(33.5840991, -101.8798631)",
      5.194462551586437);
  graph.addEdge("(33.5840843, -101.8799267)", "(33.5840209, -101.8799051)",
      7.9968375893429045);
  graph.addEdge("(33.5839465, -101.8794722)", "(33.583942, -101.8794329)",
      4.027023564088859);
  graph.addEdge("(33.583942, -101.8794329)", "(33.5839317, -101.8794137)",
      2.3152705044398942);
  graph.addEdge("(33.5839317, -101.8794137)", "(33.5839138, -101.8793959)",
      2.824873944313284);
  graph.addEdge("(33.5839138, -101.8793959)", "(33.5838907, -101.8793821)",
      3.1327257057881392);
  graph.addEdge("(33.5838907, -101.8793821)", "(33.5838682, -101.8793767)",
      2.783722531892714);
  graph.addEdge("(33.5838682, -101.8793767)", "(33.5838005, -101.8793826)",
      8.233691207636268);
  graph.addEdge("(33.5850664, -101.8803107)", "(33.5851099, -101.8802856)",
      5.859554731040632);
  graph.addEdge("(33.5851099, -101.8802856)", "(33.5851499, -101.8802599)",
      5.508955158612749);
  graph.addEdge("(33.5851499, -101.8802599)", "(33.5851958, -101.8802264)",
      6.524153895384473);
  graph.addEdge("(33.5851104, -101.8805596)", "(33.5851509, -101.8805342)",
      5.548224257464316);
  graph.addEdge("(33.5851509, -101.8805342)", "(33.5851592, -101.8805325)",
      1.0214594301797346);
  graph.addEdge("(33.5851592, -101.8805325)", "(33.585167, -101.8805369)",
      1.0462737006510796);
  graph.addEdge("(33.585167, -101.8805369)", "(33.585172, -101.8805463)",
      1.1307194019334612);
  graph.addEdge("(33.585172, -101.8805463)", "(33.5851785, -101.8806159)",
      7.109761950417087);
  graph.addEdge("(33.5851785, -101.8806159)", "(33.5851771, -101.8806247)",
      0.9093872369780344);
  graph.addEdge("(33.5851771, -101.8806247)", "(33.5851702, -101.8806314)",
      1.0784997497624467);
  graph.addEdge("(33.5851702, -101.8806314)", "(33.5851247, -101.880659)",
      6.189606405035234);
  graph.addEdge("(33.5851408, -101.8807628)", "(33.5851757, -101.8807401)",
      4.819933233583809);
  graph.addEdge("(33.5851757, -101.8807401)", "(33.5851831, -101.880739)",
      0.9045255682771733);
  graph.addEdge("(33.5851831, -101.880739)", "(33.58519, -101.8807435)",
      0.9535227765082804);
  graph.addEdge("(33.58519, -101.8807435)", "(33.5851941, -101.8807501)",
      0.834437994106337);
  graph.addEdge("(33.5851941, -101.8807501)", "(33.585213, -101.8808489)",
      10.288995422627377);
  graph.addEdge("(33.585213, -101.8808489)", "(33.585213, -101.8808589)",
      1.0152164888386537);
  graph.addEdge("(33.585213, -101.8808589)", "(33.5852088, -101.8808688)",
      1.1268076119622743);
  graph.addEdge("(33.5852088, -101.8808688)", "(33.5851923, -101.8808788)",
      2.2441783875045798);
  graph.addEdge("(33.5852075, -101.8809787)", "(33.5852249, -101.8809688)",
      2.3376753721412262);
  graph.addEdge("(33.5852249, -101.8809688)", "(33.5852328, -101.8809693)",
      0.959597935590468);
  graph.addEdge("(33.5852328, -101.8809693)", "(33.585241, -101.8809743)",
      1.1166836339041182);
  graph.addEdge("(33.585241, -101.8809743)", "(33.5852631, -101.8810444)",
      7.604800561667988);
  graph.addEdge("(33.5852631, -101.8810444)", "(33.5852843, -101.8811013)",
      6.323097084058952);
  graph.addEdge("(33.5852843, -101.8811013)", "(33.5852838, -101.8811135)",
      1.240047119402376);
  graph.addEdge("(33.5852838, -101.8811135)", "(33.5852792, -101.8811212)",
      0.9604226105636107);
  graph.addEdge("(33.5852792, -101.8811212)", "(33.5852696, -101.8811256)",
      1.247199250817355);
  graph.addEdge("(33.5853064, -101.8812145)", "(33.5853151, -101.8812101)",
      1.1459403191592978);
  graph.addEdge("(33.5853151, -101.8812101)", "(33.585322, -101.881209)",
      0.8443737525443054);
  graph.addEdge("(33.585322, -101.881209)", "(33.5853298, -101.881214)",
      1.073693290514268);
  graph.addEdge("(33.5853298, -101.881214)", "(33.585357, -101.8812803)",
      7.496005853927112);
  graph.addEdge("(33.585357, -101.8812803)", "(33.5853574, -101.881288)",
      0.7832196841009503);
  graph.addEdge("(33.5853574, -101.881288)", "(33.5853533, -101.8812957)",
      0.9265031481016518);
  graph.addEdge("(33.5853533, -101.8812957)", "(33.5853455, -101.8813001)",
      1.046273315983896);
  graph.addEdge("(33.5853455, -101.8813001)", "(33.5853377, -101.8812968)",
      1.0036886291650324);
  graph.addEdge("(33.5853377, -101.8812968)", "(33.5853073, -101.8812272)",
      7.970211682033122);
  graph.addEdge("(33.5853827, -101.8813896)", "(33.5854002, -101.8813791)",
      2.3753366595468353);
  graph.addEdge("(33.5854002, -101.8813791)", "(33.5854067, -101.8813791)",
      0.7884372048953997);
  graph.addEdge("(33.5854067, -101.8813791)", "(33.585415, -101.8813852)",
      1.18199057640336);
  graph.addEdge("(33.585415, -101.8813852)", "(33.585449, -101.8814437)",
      7.230505654351652);
  graph.addEdge("(33.585449, -101.8814437)", "(33.585449, -101.8814531)",
      0.9543009008340897);
  graph.addEdge("(33.585449, -101.8814531)", "(33.5854449, -101.8814603)",
      0.8840942858229153);
  graph.addEdge("(33.5854449, -101.8814603)", "(33.5854237, -101.881473)",
      2.87663980571442);
  graph.addEdge("(33.5854237, -101.881473)", "(33.5854127, -101.8814691)",
      1.391783762839395);
  graph.addEdge("(33.5854127, -101.8814691)", "(33.5853846, -101.8814051)",
      7.3371341503239815);
  graph.addEdge("(33.5854305, -101.8816356)", "(33.585415, -101.8816024)",
      3.8594288329433617);
  graph.addEdge("(33.585415, -101.8816024)", "(33.5854144, -101.8815972)",
      0.5329044432503725);
  graph.addEdge("(33.5854144, -101.8815972)", "(33.5854157, -101.8815909)",
      0.65873679919676);
  graph.addEdge("(33.5854157, -101.8815909)", "(33.5854876, -101.8815457)",
      9.854863965367372);
  graph.addEdge("(33.5854876, -101.8815457)", "(33.5854942, -101.8815442)",
      0.8149216868821618);
  graph.addEdge("(33.5854942, -101.8815442)", "(33.5855031, -101.8815442)",
      1.0795524965548031);
  graph.addEdge("(33.5855031, -101.8815442)", "(33.585511, -101.8815473)",
      1.0086118221571538);
  graph.addEdge("(33.585511, -101.8815473)", "(33.5855202, -101.8815541)",
      1.3122127459443205);
  graph.addEdge("(33.5855202, -101.8815541)", "(33.5855249, -101.8815592)",
      0.7701225894409389);
  graph.addEdge("(33.5855249, -101.8815592)", "(33.5855305, -101.8815691)",
      1.2130759747479882);
  graph.addEdge("(33.5855305, -101.8815691)", "(33.5855658, -101.8816598)",
      10.15484346045307);
  graph.addEdge("(33.5855658, -101.8816598)", "(33.5855737, -101.8816871)",
      2.9325122328829236);
  graph.addEdge("(33.5855737, -101.8816871)", "(33.5855806, -101.8817239)",
      3.8285832894856378);
  graph.addEdge("(33.5855806, -101.8817239)", "(33.5855865, -101.8817758)",
      5.317331299346573);
  graph.addEdge("(33.5855865, -101.8817758)", "(33.5855888, -101.8818142)",
      3.908384353710212);
  graph.addEdge("(33.5855888, -101.8818142)", "(33.5855885, -101.8818562)",
      4.264046052001616);
  graph.addEdge("(33.5855885, -101.8818562)", "(33.5855859, -101.8818977)",
      4.224917483536272);
  graph.addEdge("(33.5855859, -101.8818977)", "(33.5855713, -101.8819917)",
      9.70592691442287);
  graph.addEdge("(33.5853681, -101.8743443)", "(33.5853296, -101.8743065)",
      6.044432107153145);
  graph.addEdge("(33.5853296, -101.8743065)", "(33.5852922, -101.874283)",
      5.1256301429218425);
  graph.addEdge("(33.5852922, -101.874283)", "(33.585248, -101.8742649)",
      5.66752809512218);
  graph.addEdge("(33.585248, -101.8742649)", "(33.5852291, -101.8742482)",
      2.8513373897880077);
  graph.addEdge("(33.5852291, -101.8742482)", "(33.5852086, -101.8741974)",
      5.725466303582349);
  graph.addEdge("(33.5851398, -101.8742801)", "(33.5851318, -101.8741972)",
      8.471910239385863);
  graph.addEdge("(33.5851318, -101.8741972)", "(33.5851219, -101.8740943)",
      10.5153812900881);
  graph.addEdge("(33.5851219, -101.8740943)", "(33.5851223, -101.8738726)",
      22.507425447217397);
  graph.addEdge("(33.5851223, -101.8738726)", "(33.5851228, -101.8736514)",
      22.45669405452632);
  graph.addEdge("(33.5851228, -101.8736514)", "(33.5851224, -101.8733899)",
      26.547983195390064);
  graph.addEdge("(33.5851224, -101.8733899)", "(33.5851222, -101.8732694)",
      12.233395541045178);
  graph.addEdge("(33.5851222, -101.8732694)", "(33.585122, -101.8732387)",
      3.1168123008527138);
  graph.addEdge("(33.585122, -101.8732387)", "(33.5851263, -101.8731712)",
      6.872539243660349);
  graph.addEdge("(33.5851263, -101.8731712)", "(33.5851219, -101.8730855)",
      8.716768639819259);
  graph.addEdge("(33.5836226, -101.8707693)", "(33.5842602, -101.8707651)",
      77.34078198396821);
  graph.addEdge("(33.5842602, -101.8707651)", "(33.5843266, -101.8707657)",
      8.054418183019912);
  graph.addEdge("(33.5843266, -101.8707657)", "(33.584345, -101.870769)",
      2.2568883692724606);
  graph.addEdge("(33.584345, -101.870769)", "(33.5843596, -101.8707831)",
      2.277141216675219);
  graph.addEdge("(33.5843596, -101.8707831)", "(33.5843702, -101.8708005)",
      2.1848745851867664);
  graph.addEdge("(33.5843702, -101.8708005)", "(33.5843738, -101.8708161)",
      1.6428502688650448);
  graph.addEdge("(33.5843738, -101.8708161)", "(33.5843758, -101.8708247)",
      0.9061716455044306);
  graph.addEdge("(33.5843758, -101.8708247)", "(33.5843752, -101.8709709)",
      14.842786883189891);
  graph.addEdge("(33.5843752, -101.8709709)", "(33.5843747, -101.8710835)",
      11.431609053400349);
  graph.addEdge("(33.5843747, -101.8710835)", "(33.5843719, -101.8711365)",
      5.3914078631483875);
  graph.addEdge("(33.5843719, -101.8711365)", "(33.5843601, -101.8711968)",
      6.286914093275005);
  graph.addEdge("(33.5843601, -101.8711968)", "(33.5843389, -101.8712585)",
      6.771244352488663);
  graph.addEdge("(33.5843389, -101.8712585)", "(33.5843009, -101.871339)",
      9.382797288584406);
  graph.addEdge("(33.5843009, -101.871339)", "(33.5842847, -101.8713832)",
      4.898697361489246);
  graph.addEdge("(33.5842847, -101.8713832)", "(33.5842708, -101.8714483)",
      6.820802488237444);
  graph.addEdge("(33.5842708, -101.8714483)", "(33.584264, -101.87151)",
      6.318026524174191);
  graph.addEdge("(33.584264, -101.87151)", "(33.5842624, -101.8715978)",
      8.91581098379314);
  graph.addEdge("(33.5842624, -101.8715978)", "(33.5842625, -101.8716679)",
      7.116755955474295);
  graph.addEdge("(33.5842625, -101.8716679)", "(33.5842646, -101.8724406)",
      78.44705078602802);
  graph.addEdge("(33.5842646, -101.8724406)", "(33.5842643, -101.8725685)",
      12.984811953498076);
  graph.addEdge("(33.5842643, -101.8725685)", "(33.5842646, -101.872702)",
      13.553337269713131);
  graph.addEdge("(33.5842646, -101.872702)", "(33.584259, -101.8730668)",
      37.04173258319101);
  graph.addEdge("(33.584259, -101.8730668)", "(33.5842581, -101.8730833)",
      1.678679134713541);
  graph.addEdge("(33.5842581, -101.8730833)", "(33.5842542, -101.8730947)",
      1.250307582493333);
  graph.addEdge("(33.5842542, -101.8730947)", "(33.5842432, -101.8731108)",
      2.1099627896890105);
  graph.addEdge("(33.5842432, -101.8731108)", "(33.5842298, -101.8731235)",
      2.0746806211160744);
  graph.addEdge("(33.5842298, -101.8731235)", "(33.5842083, -101.8731315)",
      2.7314502117274246);
  graph.addEdge("(33.5842083, -101.8731315)", "(33.5841546, -101.8731414)",
      6.590789418292929);
  graph.addEdge("(33.5837321, -101.873672)", "(33.5837321, -101.8737888)",
      11.857931146532222);
  graph.addEdge("(33.5837321, -101.8737888)", "(33.5837313, -101.8739361)",
      14.954709235181811);
  graph.addEdge("(33.5837313, -101.8739361)", "(33.5837301, -101.8741826)",
      25.025937644071753);
  graph.addEdge("(33.5837301, -101.8741826)", "(33.5837294, -101.8743128)",
      13.218617542645108);
  graph.addEdge("(33.5837294, -101.8743128)", "(33.5837285, -101.8744973)",
      18.73138298723545);
  graph.addEdge("(33.5837285, -101.8744973)", "(33.5837278, -101.8746225)",
      12.711011738282727);
  graph.addEdge("(33.5837971, -101.8736075)", "(33.5841493, -101.8736121)",
      42.7237092574014);
  graph.addEdge("(33.5841493, -101.8736121)", "(33.5842565, -101.8736135)",
      13.003923216662972);
  graph.addEdge("(33.5842565, -101.8736135)", "(33.5843082, -101.8736168)",
      6.280049833635754);
  graph.addEdge("(33.5843082, -101.8736168)", "(33.5843483, -101.8736184)",
      4.866761761444178);
  graph.addEdge("(33.5843608, -101.87328)", "(33.5843524, -101.8732709)",
      1.3753814266194373);
  graph.addEdge("(33.5843524, -101.8732709)", "(33.5843104, -101.8732753)",
      5.114062812537623);
  graph.addEdge("(33.5843104, -101.8732753)", "(33.584255, -101.8732698)",
      6.743068249407704);
  graph.addEdge("(33.584255, -101.8732698)", "(33.5842469, -101.8732792)",
      1.369689339945498);
  graph.addEdge("(33.5846996, -101.8732709)", "(33.5846906, -101.8732638)",
      1.3081796988981609);
  graph.addEdge("(33.5846906, -101.8732638)", "(33.5846495, -101.873269)",
      5.013222004384648);
  graph.addEdge("(33.5846495, -101.873269)", "(33.5845957, -101.8732709)",
      6.528683430563563);
  graph.addEdge("(33.5845957, -101.8732709)", "(33.5845867, -101.8732802)",
      1.4433310166648154);
  graph.addEdge("(33.5843608, -101.87328)", "(33.5843695, -101.8732719)",
      1.3378620604814753);
  graph.addEdge("(33.5843695, -101.8732719)", "(33.5843795, -101.8732672)",
      1.3034565390881356);
  graph.addEdge("(33.5843795, -101.8732672)", "(33.5843904, -101.8732662)",
      1.3260403585091671);
  graph.addEdge("(33.5843904, -101.8732662)", "(33.5845647, -101.8732655)",
      21.142363153821876);
  graph.addEdge("(33.5845647, -101.8732655)", "(33.5845717, -101.8732678)",
      0.8806078449759646);
  graph.addEdge("(33.5845717, -101.8732678)", "(33.5845787, -101.8732719)",
      0.9456238542607418);
  graph.addEdge("(33.5845787, -101.8732719)", "(33.5845867, -101.8732802)",
      1.2851772075661556);
  graph.addEdge("(33.5845867, -101.8732802)", "(33.5845982, -101.8732993)",
      2.3886906242410615);
  graph.addEdge("(33.5845982, -101.8732993)", "(33.5845996, -101.8733071)",
      0.8098784269766156);
  graph.addEdge("(33.5845996, -101.8733071)", "(33.5846016, -101.8735436)",
      24.01126512256762);
  graph.addEdge("(33.5846016, -101.8735436)", "(33.5846023, -101.8736209)",
      7.848138096343127);
  graph.addEdge("(33.5846023, -101.8736209)", "(33.5846005, -101.8736494)",
      2.901613597957511);
  graph.addEdge("(33.5846005, -101.8736494)", "(33.5845982, -101.8736772)",
      2.8360770982776797);
  graph.addEdge("(33.5845982, -101.8736772)", "(33.5845885, -101.8737097)",
      3.5029866409105734);
  graph.addEdge("(33.5845885, -101.8737097)", "(33.5845773, -101.8737315)",
      2.596887781083048);
  graph.addEdge("(33.5845773, -101.8737315)", "(33.5845619, -101.8737506)",
      2.692472387386825);
  graph.addEdge("(33.5845619, -101.8737506)", "(33.5845418, -101.8737687)",
      3.0530140606685325);
  graph.addEdge("(33.5879748, -101.8760786)", "(33.5880181, -101.8760915)",
      5.413011795951902);
  graph.addEdge("(33.5880181, -101.8760915)", "(33.5880695, -101.8760406)",
      8.097689017353446);
  graph.addEdge("(33.5880695, -101.8760406)", "(33.5881913, -101.8760044)",
      15.224308239713219);
  graph.addEdge("(33.5881913, -101.8760044)", "(33.5882897, -101.8759382)",
      13.69769295351476);
  graph.addEdge("(33.5880181, -101.8760915)", "(33.5879938, -101.8757369)",
      36.1188873644825);
  graph.addEdge("(33.5816755, -101.8770489)", "(33.5816372, -101.8770287)",
      5.0782385323008885);
  graph.addEdge("(33.5816372, -101.8770287)", "(33.5815597, -101.8770272)",
      9.40182510112485);
  graph.addEdge("(33.5815597, -101.8770272)", "(33.5815565, -101.8769516)",
      7.685168684116357);
  graph.addEdge("(33.5815565, -101.8769516)", "(33.5814641, -101.8769448)",
      11.229173536117454);
  graph.addEdge("(33.5806247, -101.8795382)", "(33.5805945, -101.8795506)",
      3.8734913859161586);
  graph.addEdge("(33.5876059, -101.8743437)", "(33.5877674, -101.8741721)",
      26.21510812438734);
  graph.addEdge("(33.5877674, -101.8741721)", "(33.5877696, -101.8740621)",
      11.170240191088991);
  graph.addEdge("(33.586684, -101.8745374)", "(33.5866844, -101.874446)",
      9.279048077318484);
  graph.addEdge("(33.5848672, -101.8778696)", "(33.5848673, -101.8777236)",
      14.822224812047452);
  graph.addEdge("(33.5848695, -101.877548)", "(33.5848673, -101.8777236)",
      17.829269565910657);
  graph.addEdge("(33.5847556, -101.8777417)", "(33.5848673, -101.8777236)",
      13.673027801768024);
  graph.addEdge("(33.5847556, -101.8777417)", "(33.5848126, -101.877786)",
      8.24803648645197);
  graph.addEdge("(33.5848126, -101.877786)", "(33.5848211, -101.877866)",
      8.186950679625358);
  graph.addEdge("(33.5816087, -101.8792463)", "(33.5816785, -101.8792445)",
      8.46856945091184);
  graph.addEdge("(33.5816087, -101.8792463)", "(33.5811016, -101.8792442)",
      61.51056095559838);
  graph.addEdge("(33.5816042, -101.8792758)", "(33.5816087, -101.8792463)",
      3.0443466369527634);
  graph.addEdge("(33.58028, -101.8792428)", "(33.5800802, -101.8792423)",
      24.235379363869182);
  graph.addEdge("(33.5845418, -101.8737687)", "(33.5845209, -101.8737835)",
      2.9469441077736263);
  graph.addEdge("(33.5845209, -101.8737835)", "(33.5844985, -101.8737919)",
      2.847761931263205);
  graph.addEdge("(33.5844985, -101.8737919)", "(33.5844807, -101.8737946)",
      2.176435055403246);
  graph.addEdge("(33.5844807, -101.8737946)", "(33.5844633, -101.8737942)",
      2.1109760634700976);
  graph.addEdge("(33.5844633, -101.8737942)", "(33.5844494, -101.8737912)",
      1.7133301884120906);
  graph.addEdge("(33.5844494, -101.8737912)", "(33.5844312, -101.8737848)",
      2.301254154050126);
  graph.addEdge("(33.5844312, -101.8737848)", "(33.5844128, -101.8737754)",
      2.4273474009555844);
  graph.addEdge("(33.5844128, -101.8737754)", "(33.5843969, -101.8737627)",
      2.31992151300597);
  graph.addEdge("(33.5843969, -101.8737627)", "(33.5843812, -101.8737463)",
      2.52958228376562);
  graph.addEdge("(33.5843812, -101.8737463)", "(33.58437, -101.8737288)",
      2.2365365679400964);
  graph.addEdge("(33.58437, -101.8737288)", "(33.5843597, -101.8737067)",
      2.568052036875221);
  graph.addEdge("(33.5843597, -101.8737067)", "(33.5843516, -101.8736799)",
      2.892771127564144);
  graph.addEdge("(33.5843516, -101.8736799)", "(33.5843485, -101.8736527)",
      2.786900449262882);
  graph.addEdge("(33.5843485, -101.8736527)", "(33.5843483, -101.8736184)",
      3.482311788304576);
  graph.addEdge("(33.5851228, -101.8736514)", "(33.5848972, -101.87365)",
      27.36520326013163);
  graph.addEdge("(33.5848972, -101.87365)", "(33.5848007, -101.8736496)",
      11.705329427515684);
  graph.addEdge("(33.5848007, -101.8736496)", "(33.584691, -101.8736484)",
      13.306950317568246);
  graph.addEdge("(33.5861023, -101.8744415)", "(33.5861019, -101.8743534)",
      8.944097133096964);
  graph.addEdge("(33.5861019, -101.8743534)", "(33.5861017, -101.8741882)",
      16.771221981161055);
  graph.addEdge("(33.5862682, -101.8743508)", "(33.5865315, -101.8743409)",
      31.953586902514836);
  graph.addEdge("(33.5865315, -101.8743409)", "(33.586685, -101.874444)",
      21.359508822824715);
  graph.addEdge("(33.5861004, -101.872973)", "(33.5861052, -101.8729972)",
      2.5248469786503502);
  graph.addEdge("(33.5861052, -101.8729972)", "(33.586108, -101.8730117)",
      1.5107213807205089);
  graph.addEdge("(33.586108, -101.8730117)", "(33.5861118, -101.873171)",
      16.178798634233036);
  graph.addEdge("(33.5882825, -101.8724918)", "(33.5882605, -101.8725477)",
      6.270983715084454);
  graph.addEdge("(33.5882605, -101.8725477)", "(33.5883308, -101.8727931)",
      26.33150343981878);
  graph.addEdge("(33.5883308, -101.8727931)", "(33.5882649, -101.8729695)",
      19.610848687457832);
  graph.addEdge("(33.5882649, -101.8729695)", "(33.5879016, -101.8729732)",
      44.06919473785513);
  graph.addEdge("(33.5879016, -101.8729732)", "(33.5879016, -101.8723936)",
      58.84012266672901);
  graph.addEdge("(33.5879016, -101.8729732)", "(33.5879017, -101.8730603)",
      8.842269674812568);
  graph.addEdge("(33.5879017, -101.8730603)", "(33.5878363, -101.8730603)",
      7.9328944240787145);
  graph.addEdge("(33.5878363, -101.8730603)", "(33.5878354, -101.8732801)",
      22.314050297018294);
  graph.addEdge("(33.5878354, -101.8732801)", "(33.5878347, -101.8734306)",
      15.2787819307256);
  graph.addEdge("(33.5883123, -101.8735546)", "(33.5882713, -101.8735433)",
      5.103811838144776);
  graph.addEdge("(33.5882713, -101.8735433)", "(33.5882146, -101.8734828)",
      9.220827720516741);
  graph.addEdge("(33.5882146, -101.8734828)", "(33.5880815, -101.8733248)",
      22.758106960712603);
  graph.addEdge("(33.5880815, -101.8733248)", "(33.5880517, -101.8733025)",
      4.265089282082998);
  graph.addEdge("(33.5880517, -101.8733025)", "(33.5880161, -101.8732891)",
      4.527415770552547);
  graph.addEdge("(33.5880161, -101.8732891)", "(33.5879714, -101.873282)",
      5.469723206147595);
  graph.addEdge("(33.5879714, -101.873282)", "(33.5878879, -101.8732801)",
      10.130226254847663);
  graph.addEdge("(33.5878879, -101.8732801)", "(33.5878354, -101.8732801)",
      6.368149184707805);
  graph.addEdge("(33.5878354, -101.8732801)", "(33.5876506, -101.8732778)",
      22.417100750135223);
  graph.addEdge("(33.5876506, -101.8732778)", "(33.5876214, -101.8732775)",
      3.542034735942154);
  graph.addEdge("(33.5876214, -101.8732775)", "(33.5875325, -101.8732764)",
      10.78397699484382);
  graph.addEdge("(33.5875325, -101.8732764)", "(33.5874389, -101.8732752)",
      11.35415313177082);
  graph.addEdge("(33.5883119, -101.8741406)", "(33.5883123, -101.8735546)",
      59.48957911858433);
  graph.addEdge("(33.5883123, -101.8735546)", "(33.5883173, -101.8730991)",
      46.245433480080955);
  graph.addEdge("(33.5883173, -101.8730991)", "(33.5882649, -101.8729695)",
      14.611596620818652);
  graph.addEdge("(33.5882649, -101.8729695)", "(33.5882975, -101.8729786)",
      4.060795623409258);
  graph.addEdge("(33.5882975, -101.8729786)", "(33.5883317, -101.8729978)",
      4.583486425421059);
  graph.addEdge("(33.5883317, -101.8729978)", "(33.5883487, -101.8730126)",
      2.5513774940434026);
  graph.addEdge("(33.5883487, -101.8730126)", "(33.588604, -101.8732334)",
      38.22850205224884);
  graph.addEdge("(33.588604, -101.8732334)", "(33.588661, -101.8732248)",
      6.968894928247492);
  graph.addEdge("(33.588661, -101.8732248)", "(33.5887497, -101.8732114)",
      10.84479738019139);
  graph.addEdge("(33.5887497, -101.8732114)", "(33.5888187, -101.8731925)",
      8.586676566527473);
  graph.addEdge("(33.5883487, -101.8730126)", "(33.5883937, -101.8728141)",
      20.877492746422924);
  graph.addEdge("(33.5883937, -101.8728141)", "(33.5884531, -101.8726433)",
      18.776670103543285);
  graph.addEdge("(33.5874856, -101.8743554)", "(33.5874829, -101.8738996)",
      46.27351412901786);
  graph.addEdge("(33.5874829, -101.8738996)", "(33.5875311, -101.8738991)",
      5.8467874489874525);
  graph.addEdge("(33.5875311, -101.8738991)", "(33.5875325, -101.8732764)",
      63.21606780486862);
  graph.addEdge("(33.5840366, -101.8716679)", "(33.5841605, -101.8716678)",
      15.028826355516431);
  graph.addEdge("(33.5841605, -101.8716678)", "(33.5842625, -101.8716679)",
      12.372400987668902);
  graph.addEdge("(33.5843511, -101.871668)", "(33.5846061, -101.8716678)",
      30.931000060049367);
  graph.addEdge("(33.5846987, -101.8716674)", "(33.5847514, -101.8716668)",
      6.3926957723508355);
  graph.addEdge("(33.5842595, -101.8713355)", "(33.5842609, -101.8710362)",
      30.386237989250436);
  graph.addEdge("(33.5842609, -101.8710362)", "(33.5843089, -101.8710366)",
      5.822446074453461);
  graph.addEdge("(33.5843089, -101.8710366)", "(33.5843092, -101.8709703)",
      6.731053869286466);
  graph.addEdge("(33.5843092, -101.8709703)", "(33.5843095, -101.8709089)",
      6.233600430266884);
  graph.addEdge("(33.5843095, -101.8709089)", "(33.5842581, -101.8709086)",
      6.234792078652504);
  graph.addEdge("(33.5842581, -101.8709086)", "(33.5842129, -101.8709082)",
      5.482820376562216);
  graph.addEdge("(33.5842129, -101.8709082)", "(33.5842123, -101.8710359)",
      12.964668443398276);
  graph.addEdge("(33.5842123, -101.8710359)", "(33.5842609, -101.8710362)",
      5.895161892348328);
  graph.addEdge("(33.5847054, -101.8708048)", "(33.5847049, -101.8709374)",
      13.461986119151788);
  graph.addEdge("(33.5842643, -101.8725685)", "(33.5841872, -101.8727013)",
      16.40828508107962);
  graph.addEdge("(33.5841872, -101.8727013)", "(33.5841569, -101.8727532)",
      6.424235135660108);
  graph.addEdge("(33.5841569, -101.8727532)", "(33.5840953, -101.8728551)",
      12.761387539844765);
  graph.addEdge("(33.5840953, -101.8728551)", "(33.5839305, -101.8731225)",
      33.71306166093468);
  graph.addEdge("(33.5839305, -101.8731225)", "(33.5838824, -101.8731964)",
      9.504160632771887);
  graph.addEdge("(33.5838824, -101.8731964)", "(33.5838259, -101.8732781)",
      10.759465993509306);
  graph.addEdge("(33.5838259, -101.8732781)", "(33.5837748, -101.8733363)",
      8.56338053284905);
  graph.addEdge("(33.5837748, -101.8733363)", "(33.5837111, -101.8733916)",
      9.550986359139879);
  graph.addEdge("(33.5837111, -101.8733916)", "(33.5836298, -101.8734529)",
      11.661058029721703);
  graph.addEdge("(33.5836298, -101.8734529)", "(33.5835724, -101.8734862)",
      7.73988606697914);
  graph.addEdge("(33.5835724, -101.8734862)", "(33.5835322, -101.8735095)",
      5.419660003463256);
  graph.addEdge("(33.5835322, -101.8735095)", "(33.5834101, -101.8735694)",
      16.01038095530922);
  graph.addEdge("(33.5834101, -101.8735694)", "(33.5833132, -101.8736006)",
      12.173108252601523);
  graph.addEdge("(33.5833132, -101.8736006)", "(33.583238, -101.8736132)",
      9.21086877996277);
  graph.addEdge("(33.583238, -101.8736132)", "(33.5831894, -101.8736245)",
      6.005673221793252);
  graph.addEdge("(33.5831894, -101.8736245)", "(33.5831524, -101.8736342)",
      4.594798277201722);
  graph.addEdge("(33.5831524, -101.8736342)", "(33.5829507, -101.8736609)",
      24.61551173813886);
  graph.addEdge("(33.5832032, -101.8771785)", "(33.5832247, -101.8770486)",
      13.443349001011313);
  graph.addEdge("(33.5832247, -101.8770486)", "(33.5832265, -101.8767931)",
      25.940294800556146);
  graph.addEdge("(33.5832265, -101.8767931)", "(33.5829705, -101.8767832)",
      31.068546383902742);
  graph.addEdge("(33.5829705, -101.8767832)", "(33.5826749, -101.8767848)",
      35.85605107783703);
  graph.addEdge("(33.5826749, -101.8767848)", "(33.5825685, -101.8767821)",
      12.909015432961477);
  graph.addEdge("(33.5825685, -101.8767821)", "(33.5824717, -101.8767532)",
      12.102683625181262);
  graph.addEdge("(33.5826749, -101.8767848)", "(33.5829115, -101.8765676)",
      36.19240598254673);
  graph.addEdge("(33.5829115, -101.8765676)", "(33.5830591, -101.8764002)",
      24.68549679962459);
  graph.addEdge("(33.5830591, -101.8764002)", "(33.5831621, -101.8762817)",
      17.344389962707083);
  graph.addEdge("(33.5831621, -101.8762817)", "(33.5832299, -101.876281)",
      8.224310645767895);
  graph.addEdge("(33.5840656, -101.8739368)", "(33.5837313, -101.8739361)",
      40.54998431559531);
  graph.addEdge("(33.5837313, -101.8739361)", "(33.5835968, -101.8739367)",
      16.314694356125802);
  graph.addEdge("(33.5835968, -101.8739367)", "(33.5834493, -101.8739378)",
      17.891802725572525);
  graph.addEdge("(33.5834493, -101.8739378)", "(33.5834459, -101.8738892)",
      4.951258404732345);
  graph.addEdge("(33.5838579, -101.8741816)", "(33.5837301, -101.8741826)",
      15.502216822197514);
  graph.addEdge("(33.5837301, -101.8741826)", "(33.5835973, -101.8741843)",
      16.109298606391906);
  graph.addEdge("(33.5835973, -101.8741843)", "(33.5835968, -101.8739367)",
      25.13730197827244);
  graph.addEdge("(33.5835968, -101.8739367)", "(33.5835979, -101.8737984)",
      14.041339670165522);
  graph.addEdge("(33.5876203, -101.8734566)", "(33.5876214, -101.8732775)",
      18.18251183017898);
  graph.addEdge("(33.5876942, -101.873192)", "(33.5876506, -101.8731911)",
      5.2893852916453685);
  graph.addEdge("(33.5876506, -101.8731911)", "(33.5876053, -101.8731902)",
      5.495562372843784);
  graph.addEdge("(33.5876053, -101.8731902)", "(33.5875402, -101.8731165)",
      10.878154208306492);
  graph.addEdge("(33.5875402, -101.8731165)", "(33.58754, -101.8730575)",
      5.9896656144261495);
  graph.addEdge("(33.58754, -101.8730575)", "(33.5875391, -101.8730028)",
      5.554158118612485);
  graph.addEdge("(33.5875391, -101.8730028)", "(33.5876042, -101.8729279)",
      10.962300002817052);
  graph.addEdge("(33.5876042, -101.8729279)", "(33.5876966, -101.8729269)",
      11.208401941049637);
  graph.addEdge("(33.5876966, -101.8729269)", "(33.5877589, -101.8730067)",
      11.078610387459046);
  graph.addEdge("(33.5877589, -101.8730067)", "(33.5877593, -101.8730611)",
      5.522828614861585);
  graph.addEdge("(33.5877593, -101.8730611)", "(33.5877596, -101.873114)",
      5.370460749030493);
  graph.addEdge("(33.5878363, -101.8730603)", "(33.5877593, -101.8730611)",
      9.340305135777268);
  graph.addEdge("(33.5876506, -101.8731911)", "(33.5876506, -101.8732778)",
      8.801679446471498);
  graph.addEdge("(33.58754, -101.8730575)", "(33.5874378, -101.8730569)",
      12.396812644515983);
  graph.addEdge("(33.5869656, -101.8735033)", "(33.5869627, -101.8737596)",
      26.02185066583772);
  graph.addEdge("(33.5869627, -101.8737596)", "(33.5869038, -101.8739084)",
      16.71042063932959);
  graph.addEdge("(33.5869038, -101.8739084)", "(33.5867434, -101.8739051)",
      19.45909280911652);
  graph.addEdge("(33.586102, -101.8740788)", "(33.5862238, -101.8738798)",
      25.028355971426365);
  graph.addEdge("(33.5862238, -101.8738798)", "(33.5862238, -101.8738346)",
      4.588725022108316);
  graph.addEdge("(33.5869627, -101.8737596)", "(33.5871135, -101.873759)",
      18.291849403170897);
  graph.addEdge("(33.5871135, -101.873759)", "(33.5871135, -101.8740941)",
      34.019158684651956);
  graph.addEdge("(33.5871135, -101.8740941)", "(33.5870975, -101.8741375)",
      4.814449236990983);
  graph.addEdge("(33.5870975, -101.8741375)", "(33.5870946, -101.8743558)",
      22.164486064732884);
  graph.addEdge("(33.587139, -101.8751585)", "(33.587136, -101.8753126)",
      15.648370422278797);
  graph.addEdge("(33.587136, -101.8753126)", "(33.5872209, -101.8754844)",
      20.254440385208074);
  graph.addEdge("(33.5872209, -101.8754844)", "(33.5873241, -101.8756944)",
      24.72247548728234);
  graph.addEdge("(33.5871407, -101.8750526)", "(33.5874731, -101.8750398)",
      40.34041239280446);
  graph.addEdge("(33.5874731, -101.8750398)", "(33.5877412, -101.8750395)",
      32.52002809931053);
  graph.addEdge("(33.5877412, -101.8750395)", "(33.5878077, -101.8750392)",
      8.066379681659127);
  graph.addEdge("(33.5878077, -101.8750392)", "(33.5878077, -101.8751518)",
      11.43099549531313);
  graph.addEdge("(33.5847482, -101.8767418)", "(33.5847493, -101.8761491)",
      60.17235144728712);
  graph.addEdge("(33.5847493, -101.8761491)", "(33.58475, -101.8757628)",
      39.21811448361161);
  graph.addEdge("(33.5800148, -101.8797364)", "(33.5800134, -101.879365)",
      37.70778386323347);
  graph.addEdge("(33.5800134, -101.879365)", "(33.580013, -101.8792421)",
      12.477853324464983);
  graph.addEdge("(33.580013, -101.8792421)", "(33.5800131, -101.879128)",
      11.584321268957893);
  graph.addEdge("(33.5800131, -101.879128)", "(33.5800136, -101.8787437)",
      39.01715675576149);
  graph.addEdge("(33.5805687, -101.876773)", "(33.5806604, -101.8769319)",
      19.595505845886137);
  graph.addEdge("(33.5806604, -101.8769319)", "(33.5807442, -101.8770779)",
      17.973363773226385);
  graph.addEdge("(33.5807442, -101.8770779)", "(33.5807455, -101.8771665)",
      8.996663697967191);
  graph.addEdge("(33.5807455, -101.8771665)", "(33.5808633, -101.8771676)",
      14.289333898667115);
  graph.addEdge("(33.5804793, -101.8779034)", "(33.5805992, -101.8779019)",
      14.544419842441535);
  graph.addEdge("(33.5805992, -101.8779019)", "(33.5806016, -101.8774186)",
      49.068887002425434);
  graph.addEdge("(33.5867093, -101.8808656)", "(33.5866709, -101.8808651)",
      4.6581219543193315);
  graph.addEdge("(33.5866709, -101.8808651)", "(33.5866079, -101.8808642)",
      7.642323708192511);
  graph.addEdge("(33.5866079, -101.8808642)", "(33.5865883, -101.8808649)",
      2.378503724923448);
  graph.addEdge("(33.5865883, -101.8808649)", "(33.5862511, -101.8808639)",
      40.901828928603834);
  graph.addEdge("(33.5862511, -101.8808639)", "(33.5857419, -101.8808626)",
      61.765104554262436);
  graph.addEdge("(33.5857419, -101.8808626)", "(33.5853158, -101.8808614)",
      51.6852358346346);
  graph.addEdge("(33.5862511, -101.8809734)", "(33.5862511, -101.8808639)",
      11.116487426717041);
  graph.addEdge("(33.5862511, -101.8808639)", "(33.5862499, -101.8806446)",
      22.26390695641832);
  graph.addEdge("(33.5862499, -101.8806446)", "(33.5862491, -101.8805036)",
      14.31471024536139);
  graph.addEdge("(33.5862491, -101.8805036)", "(33.5862482, -101.8803675)",
      13.8173626015019);
  graph.addEdge("(33.5862482, -101.8803675)", "(33.5862468, -101.8801143)",
      25.70553566617392);
  graph.addEdge("(33.5862468, -101.8801143)", "(33.5863858, -101.8801158)",
      16.861116538970904);
  graph.addEdge("(33.5863858, -101.8801158)", "(33.5865251, -101.8801173)",
      16.897504848797855);
  graph.addEdge("(33.5862491, -101.8805036)", "(33.5857418, -101.880505)",
      61.53466140209412);
  graph.addEdge("(33.5857419, -101.8808626)", "(33.5857418, -101.8806448)",
      22.111283554463057);
  graph.addEdge("(33.5857418, -101.8806448)", "(33.5857418, -101.880505)",
      14.192639933599454);
  graph.addEdge("(33.5857418, -101.880505)", "(33.5857415, -101.8803671)",
      13.999797294799201);
  graph.addEdge("(33.5857415, -101.8803671)", "(33.5857404, -101.8801153)",
      25.5633437116413);
  graph.addEdge("(33.5857404, -101.8801153)", "(33.585613, -101.8801174)",
      15.454840434442824);
  graph.addEdge("(33.585613, -101.8801174)", "(33.5854608, -101.8801179)",
      18.46163057320145);
  graph.addEdge("(33.5862482, -101.8803675)", "(33.5864508, -101.8803658)",
      24.57559094249095);
  graph.addEdge("(33.5864508, -101.8803658)", "(33.586606, -101.8803643)",
      18.82607380532933);
  graph.addEdge("(33.586606, -101.8803643)", "(33.5866744, -101.880364)",
      8.296842910521876);
  graph.addEdge("(33.5864508, -101.8803658)", "(33.5864501, -101.8806456)",
      28.40547876317838);
  graph.addEdge("(33.5857415, -101.8803671)", "(33.5856038, -101.8803528)",
      16.765711905802565);
  graph.addEdge("(33.5856038, -101.8803528)", "(33.5855419, -101.8803444)",
      7.556621323777525);
  graph.addEdge("(33.5855419, -101.8803444)", "(33.5852742, -101.8803424)",
      32.47211785242144);
  graph.addEdge("(33.5852742, -101.8803424)", "(33.5852304, -101.8803424)",
      5.312853648568077);
  graph.addEdge("(33.5852721, -101.8805073)", "(33.5854017, -101.8805084)",
      15.72062136038036);
  graph.addEdge("(33.5857419, -101.8808626)", "(33.5857421, -101.8809743)",
      11.33992492655936);
  graph.addEdge("(33.5852736, -101.8798819)", "(33.5855419, -101.8798828)",
      32.54439012842946);
  graph.addEdge("(33.5855419, -101.8798828)", "(33.5856754, -101.8798832)",
      16.19333865617292);
  graph.addEdge("(33.5856754, -101.8798832)", "(33.5857143, -101.8798833)",
      4.7185045665665895);
  graph.addEdge("(33.5855419, -101.8798828)", "(33.5855422, -101.8796101)",
      27.68487247257906);
  graph.addEdge("(33.5855422, -101.8796101)", "(33.5856762, -101.8796107)",
      16.25405089543637);
  graph.addEdge("(33.5856762, -101.8796107)", "(33.5856754, -101.8798832)",
      27.664671809049306);
  graph.addEdge("(33.5857418, -101.8806448)", "(33.5855402, -101.8806446)",
      24.453692514950212);
  graph.addEdge("(33.5855402, -101.8806446)", "(33.5855419, -101.8803444)",
      30.477381247608584);
  graph.addEdge("(33.5866487, -101.8798915)", "(33.5864501, -101.8798907)",
      24.089930422344462);
  graph.addEdge("(33.5864501, -101.8798907)", "(33.5863145, -101.8798901)",
      16.448128461686036);
  graph.addEdge("(33.5863145, -101.8798901)", "(33.5862737, -101.8798899)",
      4.949002048517267);
  graph.addEdge("(33.5863145, -101.8798901)", "(33.5863141, -101.8796158)",
      27.8470767692448);
  graph.addEdge("(33.5863141, -101.8796158)", "(33.5864499, -101.8796159)",
      16.472278412335065);
  graph.addEdge("(33.5864499, -101.8796159)", "(33.5864501, -101.8798907)",
      27.897761555797793);
  graph.addEdge("(33.5860517, -101.8787205)", "(33.5860729, -101.878721)",
      2.5720194833288375);
  graph.addEdge("(33.5860729, -101.878721)", "(33.5864078, -101.8787292)",
      40.63124508804763);
  graph.addEdge("(33.5865883, -101.8808649)", "(33.5865849, -101.8820226)",
      117.53047411341656);
  graph.addEdge("(33.586692, -101.8822698)", "(33.5865947, -101.8820822)",
      22.40562277495005);
  graph.addEdge("(33.5865947, -101.8820822)", "(33.5864964, -101.8822683)",
      22.34084687421156);
  graph.addEdge("(33.5865947, -101.8820822)", "(33.5865864, -101.8820317)",
      5.2246799050927475);
  graph.addEdge("(33.5865864, -101.8820317)", "(33.5865849, -101.8820226)",
      0.941578992170135);
  graph.addEdge("(33.5858154, -101.8813696)", "(33.5858107, -101.881766)",
      40.24694100598142);
  graph.addEdge("(33.5858107, -101.881766)", "(33.5858107, -101.8818051)",
      3.9694691006368665);
  graph.addEdge("(33.5858107, -101.8818051)", "(33.5858146, -101.8818464)",
      4.2194177809130755);
  graph.addEdge("(33.5858146, -101.8818464)", "(33.5858292, -101.881923)",
      7.975605197463346);
  graph.addEdge("(33.5858292, -101.881923)", "(33.5858474, -101.8819944)",
      7.577315622419459);
  graph.addEdge("(33.5858474, -101.8819944)", "(33.5858665, -101.8820541)",
      6.488512397964801);
  graph.addEdge("(33.5858665, -101.8820541)", "(33.585875, -101.8820862)",
      3.418031431539308);
  graph.addEdge("(33.585875, -101.8820862)", "(33.5858792, -101.8821217)",
      3.6398202825510793);
  graph.addEdge("(33.5874394, -101.8724983)", "(33.5874378, -101.8730569)",
      56.708869165902975);
  graph.addEdge("(33.5874378, -101.8730569)", "(33.5874389, -101.8732752)",
      22.16200867258268);
  graph.addEdge("(33.5874389, -101.8732752)", "(33.5874361, -101.8734607)",
      18.8348450352428);
  graph.addEdge("(33.5874361, -101.8734607)", "(33.5874081, -101.8735004)",
      5.270534942339128);
  graph.addEdge("(33.5874081, -101.8735004)", "(33.5869656, -101.8735033)",
      53.675201827558716);
  graph.addEdge("(33.5869656, -101.8735033)", "(33.5867304, -101.8734936)",
      28.546293695602575);
  graph.addEdge("(33.5867304, -101.8734936)", "(33.5866181, -101.873489)",
      13.62977426196453);
  graph.addEdge("(33.5866181, -101.873489)", "(33.5862934, -101.8734935)",
      39.38812693773287);
  graph.addEdge("(33.5862934, -101.8734935)", "(33.5862067, -101.8734946)",
      10.517133663411263);
  graph.addEdge("(33.5862067, -101.8734946)", "(33.5861081, -101.8734963)",
      11.961232515529234);
  graph.addEdge("(33.5849008, -101.8722838)", "(33.5848582, -101.8722467)",
      6.394311811155882);
  graph.addEdge("(33.5848582, -101.8722467)", "(33.5848291, -101.8722092)",
      5.191641017768831);
  graph.addEdge("(33.5848291, -101.8722092)", "(33.5847897, -101.8721388)",
      8.597793688560229);
  graph.addEdge("(33.5832032, -101.8771785)", "(33.5832001, -101.8777228)",
      55.26079488026269);
  graph.addEdge("(33.5832001, -101.8777228)", "(33.583156, -101.8777601)",
      6.553974950859931);
  graph.addEdge("(33.583156, -101.8777601)", "(33.5829643, -101.8777586)",
      23.253322481398804);
  graph.addEdge("(33.5829643, -101.8777586)", "(33.5826173, -101.8777594)",
      42.09047748406454);
  graph.addEdge("(33.5826173, -101.8777594)", "(33.5824766, -101.8777601)",
      17.0667731039187);
  graph.addEdge("(33.5830907, -101.879276)", "(33.5831154, -101.8792461)",
      4.265099000312884);
  graph.addEdge("(33.5831154, -101.8792461)", "(33.5831366, -101.8792079)",
      4.6533100477745934);
  graph.addEdge("(33.5831366, -101.8792079)", "(33.5831408, -101.8791665)",
      4.23385921294393);
  graph.addEdge("(33.5831408, -101.8791665)", "(33.5831392, -101.878985)",
      18.427641900978912);
  graph.addEdge("(33.5831392, -101.878985)", "(33.5831319, -101.8786385)",
      35.18923678586047);
  graph.addEdge("(33.5831319, -101.8786385)", "(33.5831379, -101.8786004)",
      3.93593975557001);
  graph.addEdge("(33.5831379, -101.8786004)", "(33.583141, -101.8785811)",
      1.9951691123959923);
  graph.addEdge("(33.583141, -101.8785811)", "(33.5831995, -101.87824)",
      35.349381802615795);
  graph.addEdge("(33.5831995, -101.87824)", "(33.5831979, -101.8778866)",
      35.87910923892711);
  graph.addEdge("(33.5831979, -101.8778866)", "(33.5831688, -101.8778681)",
      3.99836228482615);
  graph.addEdge("(33.5831688, -101.8778681)", "(33.5829913, -101.8778695)",
      21.53086163589533);
  graph.addEdge("(33.5829913, -101.8778695)", "(33.5824766, -101.8778673)",
      62.432469352782455);
  graph.addEdge("(33.5821369, -101.8746737)", "(33.5821862, -101.874675)",
      5.981446115492849);
  graph.addEdge("(33.5821862, -101.874675)", "(33.5825521, -101.8746766)",
      44.38322517695334);
  graph.addEdge("(33.5825521, -101.8746766)", "(33.5829226, -101.8746801)",
      44.942306019292324);
  graph.addEdge("(33.5835973, -101.8741843)", "(33.5835972, -101.8742124)",
      2.852837290617241);
  graph.addEdge("(33.5835972, -101.8742124)", "(33.5835956, -101.8745785)",
      37.16827542750067);
  graph.addEdge("(33.5835956, -101.8745785)", "(33.5835952, -101.8746826)",
      10.56871221821777);
  graph.addEdge("(33.5835952, -101.8746826)", "(33.5835948, -101.8747739)",
      9.269226521335383);
  graph.addEdge("(33.5835948, -101.8747739)", "(33.5835932, -101.8751575)",
      38.94491537674633);
  graph.addEdge("(33.5835932, -101.8751575)", "(33.583593, -101.8751911)",
      3.4112774042624863);
  graph.addEdge("(33.583593, -101.8751911)", "(33.5835921, -101.8754174)",
      22.975037942495184);
  graph.addEdge("(33.5837285, -101.8744973)", "(33.5835956, -101.8745785)",
      18.106057611174855);
  graph.addEdge("(33.5837268, -101.8748649)", "(33.5835948, -101.8747739)",
      18.485541757329848);
  graph.addEdge("(33.5837274, -101.8751572)", "(33.5835932, -101.8751575)",
      16.27821972387223);
  graph.addEdge("(33.5835932, -101.8751575)", "(33.5837271, -101.8750149)",
      21.757453696028705);
  graph.addEdge("(33.5837294, -101.8743128)", "(33.5835972, -101.8742124)",
      19.000964759663542);
  graph.addEdge("(33.583593, -101.8751911)", "(33.5833803, -101.8751917)",
      25.800155198000738);
  graph.addEdge("(33.5833803, -101.8751917)", "(33.5833454, -101.8751917)",
      4.233299901180567);
  graph.addEdge("(33.5833454, -101.8751917)", "(33.5830118, -101.8751926)",
      40.46511188533185);
  graph.addEdge("(33.5830118, -101.8751926)", "(33.5830117, -101.8752188)",
      2.6599623949205187);
  graph.addEdge("(33.5830117, -101.8752188)", "(33.5830115, -101.8753181)",
      10.081384914481736);
  graph.addEdge("(33.5830115, -101.8753181)", "(33.5830113, -101.875399)",
      8.213345798081491);
  graph.addEdge("(33.5830113, -101.875399)", "(33.5830112, -101.8754223)",
      2.365545593633056);
  graph.addEdge("(33.5830113, -101.875399)", "(33.5831709, -101.8753071)",
      21.490164904904848);
  graph.addEdge("(33.5831709, -101.8753071)", "(33.583321, -101.8752206)",
      20.214078941353968);
  graph.addEdge("(33.583321, -101.8752206)", "(33.5833454, -101.8751917)",
      4.167521894418153);
  graph.addEdge("(33.5830117, -101.8752188)", "(33.5831709, -101.8753071)",
      21.2900095265944);
  graph.addEdge("(33.5831709, -101.8753071)", "(33.5833044, -101.8753882)",
      18.166299173594226);
  graph.addEdge("(33.5833812, -101.8753828)", "(33.5833803, -101.8751917)",
      19.401504274076668);
  graph.addEdge("(33.5866847, -101.8751596)", "(33.5866806, -101.8752714)",
      11.360818321817781);
  graph.addEdge("(33.5856455, -101.8709185)", "(33.5852382, -101.8709176)",
      49.40477301335535);
  graph.addEdge("(33.5852382, -101.8709176)", "(33.5851528, -101.8709194)",
      10.36046324982544);
  graph.addEdge("(33.5856898, -101.8712103)", "(33.5856898, -101.871058)",
      15.461662077671049);
  graph.addEdge("(33.5856898, -101.871058)", "(33.5856873, -101.8710225)",
      3.6167339799311455);
  graph.addEdge("(33.5856873, -101.8710225)", "(33.5856764, -101.870984)",
      4.1261285117623165);
  graph.addEdge("(33.5856764, -101.870984)", "(33.5856612, -101.8709455)",
      4.321597513296153);
  graph.addEdge("(33.5856612, -101.8709455)", "(33.5856455, -101.8709185)",
      3.3376830350500826);
  graph.addEdge("(33.5856455, -101.8709185)", "(33.5856257, -101.8708977)",
      3.1979980811389077);
  graph.addEdge("(33.5856257, -101.8708977)", "(33.5854895, -101.87077)",
      21.000206997740463);
  graph.addEdge("(33.5872751, -101.8821417)", "(33.5873295, -101.8820591)",
      10.67043092089528);
  graph.addEdge("(33.5873295, -101.8820591)", "(33.5873675, -101.8819858)",
      8.753264228704916);
  graph.addEdge("(33.5873675, -101.8819858)", "(33.5873815, -101.8819546)",
      3.5939103831259525);
  graph.addEdge("(33.5873815, -101.8819546)", "(33.5874289, -101.8819162)",
      6.946515431659775);
  graph.addEdge("(33.5874289, -101.8819162)", "(33.5874794, -101.881864)",
      8.099685296509534);
  graph.addEdge("(33.5874794, -101.881864)", "(33.5876044, -101.8819396)",
      16.99403207086089);
  graph.addEdge("(33.5876044, -101.8819396)", "(33.5876136, -101.8819715)",
      3.4253310240128565);
  graph.addEdge("(33.5871981, -101.8820696)", "(33.5872495, -101.8820432)",
      6.786363371157889);
  graph.addEdge("(33.5872495, -101.8820432)", "(33.5872941, -101.8820185)",
      5.9627706512982);
  graph.addEdge("(33.5872941, -101.8820185)", "(33.5873419, -101.8819852)",
      6.711612165813019);
  graph.addEdge("(33.5873419, -101.8819852)", "(33.5873815, -101.8819546)",
      5.720396639751503);
  graph.addEdge("(33.5862993, -101.8822363)", "(33.5863317, -101.8821374)",
      10.782126097110092);
  graph.addEdge("(33.5863317, -101.8821374)", "(33.5863715, -101.8820271)",
      12.194039660501236);
  graph.addEdge("(33.5863715, -101.8820271)", "(33.5863729, -101.8817153)",
      31.65448233835169);
  graph.addEdge("(33.5858154, -101.8813696)", "(33.5855257, -101.881371)",
      35.140328668317835);
  graph.addEdge("(33.5864501, -101.8806456)", "(33.5862499, -101.8806446)",
      24.28408182640109);
  graph.addEdge("(33.5859045, -101.8780784)", "(33.585401, -101.8780818)",
      61.074536712683916);
  graph.addEdge("(33.585248, -101.8783826)", "(33.5852785, -101.8782743)",
      11.600531572625215);
  graph.addEdge("(33.5852785, -101.8782743)", "(33.5853043, -101.8782092)",
      7.312543245327888);
  graph.addEdge("(33.5853043, -101.8782092)", "(33.5853538, -101.8781603)",
      7.790785259454478);
  graph.addEdge("(33.5853538, -101.8781603)", "(33.585401, -101.8780818)",
      9.812775669178034);
  graph.addEdge("(33.5828934, -101.8803284)", "(33.5829205, -101.8803453)",
      3.7080128304953512);
  graph.addEdge("(33.5829205, -101.8803453)", "(33.5829486, -101.8803571)",
      3.612874630865548);
  graph.addEdge("(33.5829486, -101.8803571)", "(33.5829727, -101.8803598)",
      2.9361051584797124);
  graph.addEdge("(33.5829727, -101.8803598)", "(33.5834371, -101.8803159)",
      56.50682627087518);
  graph.addEdge("(33.585127, -101.8720642)", "(33.5851612, -101.8720408)",
      4.780447253988264);
  graph.addEdge("(33.5851612, -101.8720408)", "(33.5851999, -101.8720284)",
      4.86010087282994);
  graph.addEdge("(33.5851999, -101.8720284)", "(33.5852345, -101.8720235)",
      4.226290438724285);
  graph.addEdge("(33.5852345, -101.8720235)", "(33.5852348, -101.8719935)",
      3.0458660870307184);
  graph.addEdge("(33.5852348, -101.8719935)", "(33.5852366, -101.8718042)",
      19.219283317204013);
  graph.addEdge("(33.585127, -101.8720642)", "(33.5851932, -101.8719071)",
      17.856435954163683);
  graph.addEdge("(33.5851932, -101.8719071)", "(33.5852366, -101.8718042)",
      11.69804243944807);
  graph.addEdge("(33.5851495, -101.871806)", "(33.5851932, -101.8719071)",
      11.551803261997339);
  graph.addEdge("(33.5851932, -101.8719071)", "(33.5852348, -101.8719935)",
      10.119327429729063);
  graph.addEdge("(33.586649, -101.879859)", "(33.586843, -101.8795804)",
      36.79265122044788);
  graph.addEdge("(33.586843, -101.8795804)", "(33.5868908, -101.8795117)",
      9.069711478754728);
  graph.addEdge("(33.5868908, -101.8795117)", "(33.5870365, -101.8793025)",
      27.629474091682013);
  graph.addEdge("(33.5870365, -101.8793025)", "(33.5870365, -101.8792526)",
      5.065823712742143);
  graph.addEdge("(33.5866791, -101.8793382)", "(33.5868325, -101.8795427)",
      27.87895494731742);
  graph.addEdge("(33.5868325, -101.8795427)", "(33.586843, -101.8795804)",
      4.033647859015857);
  graph.addEdge("(33.586843, -101.8795804)", "(33.5868464, -101.8796156)",
      3.597214160954052);
  graph.addEdge("(33.5868464, -101.8796156)", "(33.5868458, -101.8798939)",
      28.253036346073536);
  graph.addEdge("(33.5868458, -101.8798939)", "(33.5869034, -101.8798934)",
      6.986952662167549);
  graph.addEdge("(33.5869034, -101.8798934)", "(33.5869034, -101.8795563)",
      34.22228047874131);
  graph.addEdge("(33.5869034, -101.8795563)", "(33.5868908, -101.8795117)",
      4.778769768730802);
  graph.addEdge("(33.5866487, -101.8798915)", "(33.5868458, -101.8798939)",
      23.90908869258029);
  graph.addEdge("(33.5872845, -101.8800691)", "(33.5872993, -101.8800756)",
      1.912647089402393);
  graph.addEdge("(33.5872993, -101.8800756)", "(33.5873059, -101.8800821)",
      1.0374693697863557);
  graph.addEdge("(33.5873059, -101.8800821)", "(33.5873114, -101.8800875)",
      0.8634825958015802);
  graph.addEdge("(33.5873114, -101.8800875)", "(33.5873195, -101.8801037)",
      1.9157450833032827);
  graph.addEdge("(33.5873195, -101.8801037)", "(33.5873227, -101.8801221)",
      1.9078552000482738);
  graph.addEdge("(33.5873227, -101.8801221)", "(33.5873208, -101.8801399)",
      1.8216787093988935);
  graph.addEdge("(33.5873208, -101.8801399)", "(33.5873181, -101.8801466)",
      0.7549186726255894);
  graph.addEdge("(33.5873181, -101.8801466)", "(33.5873143, -101.880156)",
      1.0597687929954795);
  graph.addEdge("(33.5873143, -101.880156)", "(33.587304, -101.8801688)",
      1.802632729114599);
  graph.addEdge("(33.587304, -101.8801688)", "(33.5872907, -101.8801771)",
      1.820058347376626);
  graph.addEdge("(33.5872907, -101.8801771)", "(33.587276, -101.8801799)",
      1.805596922698033);
  graph.addEdge("(33.587276, -101.8801799)", "(33.5872613, -101.880177)",
      1.8072229450120947);
  graph.addEdge("(33.5872613, -101.880177)", "(33.5872482, -101.8801686)",
      1.8033686615183093);
  graph.addEdge("(33.5872482, -101.8801686)", "(33.5872378, -101.8801557)",
      1.8183592886786104);
  graph.addEdge("(33.5872378, -101.8801557)", "(33.5872315, -101.8801395)",
      1.8134821603626692);
  graph.addEdge("(33.5872315, -101.8801395)", "(33.5872297, -101.8801208)",
      1.910924860607428);
  graph.addEdge("(33.5872297, -101.8801208)", "(33.5872332, -101.8801025)",
      1.905693738366483);
  graph.addEdge("(33.5872332, -101.8801025)", "(33.5872417, -101.8800866)",
      1.9153410935814157);
  graph.addEdge("(33.5872417, -101.8800866)", "(33.587254, -101.8800749)",
      1.907032685770121);
  graph.addEdge("(33.587254, -101.8800749)", "(33.5872689, -101.8800689)",
      1.9072241455309176);
  graph.addEdge("(33.5873181, -101.8801466)", "(33.5873488, -101.8801831)",
      5.253324714757881);
  graph.addEdge("(33.5873488, -101.8801831)", "(33.5873783, -101.8802125)",
      4.6596556814165275);
  graph.addEdge("(33.5873783, -101.8802125)", "(33.5874212, -101.8802504)",
      6.471644465842516);
  graph.addEdge("(33.5874212, -101.8802504)", "(33.5874824, -101.880285)",
      8.21252439637819);
  graph.addEdge("(33.5874824, -101.880285)", "(33.5875496, -101.8803171)",
      8.77850013968915);
  graph.addEdge("(33.5875496, -101.8803171)", "(33.5875961, -101.8803287)",
      5.761983390135157);
  graph.addEdge("(33.5875961, -101.8803287)", "(33.5876573, -101.8803381)",
      7.484526605115699);
  graph.addEdge("(33.5876573, -101.8803381)", "(33.5877217, -101.8803387)",
      7.811833594540339);
  graph.addEdge("(33.5877217, -101.8803387)", "(33.5877775, -101.8803271)",
      6.870113723220881);
  graph.addEdge("(33.5877775, -101.8803271)", "(33.5878628, -101.8802997)",
      10.714107203061241);
  graph.addEdge("(33.5878628, -101.8802997)", "(33.5879215, -101.8802677)",
      7.826273832898172);
  graph.addEdge("(33.5879215, -101.8802677)", "(33.5879807, -101.8802201)",
      8.65537200430069);
  graph.addEdge("(33.5879807, -101.8802201)", "(33.5880438, -101.8801512)",
      10.368556912585085);
  graph.addEdge("(33.5880438, -101.8801512)", "(33.5880792, -101.8800925)",
      7.345011607533558);
  graph.addEdge("(33.5872298, -101.8801207)", "(33.5872223, -101.8801207)",
      0.909735504587742);
  graph.addEdge("(33.588133, -101.8756256)", "(33.587913, -101.8752429)",
      47.13306864148811);
  graph.addEdge("(33.587913, -101.8752429)", "(33.5879137, -101.8751526)",
      9.16751253373844);
  graph.addEdge("(33.5879137, -101.8751526)", "(33.5878077, -101.8751518)",
      12.857852943728075);
  graph.addEdge("(33.5877412, -101.8750395)", "(33.5877429, -101.8749533)",
      8.753340010865251);
  graph.addEdge("(33.5877429, -101.8749533)", "(33.5877425, -101.8746956)",
      26.161410430314145);
  graph.addEdge("(33.5877425, -101.8746956)", "(33.587742, -101.8743763)",
      32.414973414538935);
  graph.addEdge("(33.587742, -101.8743763)", "(33.5877443, -101.8743636)",
      1.3191264968350245);
  graph.addEdge("(33.5877443, -101.8743636)", "(33.5877464, -101.8743526)",
      1.1453892447706897);
  graph.addEdge("(33.5873581, -101.8786764)", "(33.5873584, -101.8786598)",
      1.6856105045026755);
  graph.addEdge("(33.5873584, -101.8786598)", "(33.5873638, -101.8786444)",
      1.6950635318194747);
  graph.addEdge("(33.5873638, -101.8786444)", "(33.5873721, -101.8786367)",
      1.2746154179540166);
  graph.addEdge("(33.5873721, -101.8786367)", "(33.5873841, -101.8786327)",
      1.5111591676031855);
  graph.addEdge("(33.5873841, -101.8786327)", "(33.5873989, -101.8786355)",
      1.8175764521239806);
  graph.addEdge("(33.5873989, -101.8786355)", "(33.5874108, -101.8786483)",
      1.942188126265294);
  graph.addEdge("(33.5874108, -101.8786483)", "(33.5874141, -101.8786633)",
      1.5745172212497558);
  graph.addEdge("(33.5823114, -101.8766343)", "(33.5822158, -101.8765172)",
      16.607461264992594);
  graph.addEdge("(33.5822158, -101.8765172)", "(33.58203, -101.8762896)",
      32.2779197883214);
  graph.addEdge("(33.58203, -101.8762896)", "(33.5819577, -101.876201)",
      12.562758634882156);
  graph.addEdge("(33.5821542, -101.8761518)", "(33.5821542, -101.8760909)",
      6.182886561117079);
  graph.addEdge("(33.5821542, -101.8760909)", "(33.5821727, -101.8760708)",
      3.0331291352646463);
  graph.addEdge("(33.5821727, -101.8760708)", "(33.5821922, -101.8760497)",
      3.191180897977444);
  graph.addEdge("(33.5821922, -101.8760497)", "(33.5822184, -101.876049)",
      3.1788012979552613);
  graph.addEdge("(33.5822184, -101.876049)", "(33.5822425, -101.8760492)",
      2.9233515763136433);
  graph.addEdge("(33.5822425, -101.8760492)", "(33.5822762, -101.8760923)",
      5.9880433389209236);
  graph.addEdge("(33.5822762, -101.8760923)", "(33.5822762, -101.8761526)",
      6.121962807231169);
  graph.addEdge("(33.5822762, -101.8761526)", "(33.5822382, -101.8761934)",
      6.19708648728726);
  graph.addEdge("(33.5822382, -101.8761934)", "(33.5822154, -101.8761934)",
      2.765593694900532);
  graph.addEdge("(33.5822154, -101.8761934)", "(33.5821923, -101.8761934)",
      2.801983075871675);
  graph.addEdge("(33.5821923, -101.8761934)", "(33.5821585, -101.8761565)",
      5.553697818983615);
  graph.addEdge("(33.58203, -101.8762896)", "(33.5821585, -101.8761565)",
      20.62885420570813);
  graph.addEdge("(33.5821727, -101.8760708)", "(33.5820413, -101.8759217)",
      21.9813319793266);
  graph.addEdge("(33.5820413, -101.8759217)", "(33.5819716, -101.8758352)",
      12.190185904756511);
  graph.addEdge("(33.5819716, -101.8758352)", "(33.5819684, -101.875831)",
      0.5766159471324483);
  graph.addEdge("(33.5819684, -101.875831)", "(33.5819586, -101.8758188)",
      1.7167444266193925);
  graph.addEdge("(33.5822425, -101.8760492)", "(33.5823121, -101.8759506)",
      13.095062491526559);
  graph.addEdge("(33.5822158, -101.8765172)", "(33.5822154, -101.8761934)",
      32.87388228024224);
  graph.addEdge("(33.5842595, -101.8713355)", "(33.584161, -101.8714947)",
      20.099140907319445);
  graph.addEdge("(33.5815271, -101.881172)", "(33.5814896, -101.881132)",
      6.097743077871838);
  graph.addEdge("(33.5814896, -101.881132)", "(33.5813724, -101.8809748)",
      21.373265112020725);
  graph.addEdge("(33.5813724, -101.8809748)", "(33.5812794, -101.8808439)",
      17.431943395231883);
  graph.addEdge("(33.5812794, -101.8808439)", "(33.5811192, -101.8806185)",
      30.021312482309032);
  graph.addEdge("(33.5851224, -101.8733899)", "(33.5851538, -101.8733899)",
      3.8087580251528825);
  graph.addEdge("(33.5851538, -101.8733899)", "(33.5852264, -101.873305)",
      12.322347465517208);
  graph.addEdge("(33.5852264, -101.873305)", "(33.5852271, -101.8732717)",
      3.3817364809344586);
  graph.addEdge("(33.5831318, -101.8724353)", "(33.5831293, -101.8715634)",
      88.51937135424241);
  graph.addEdge("(33.5831293, -101.8715634)", "(33.5830352, -101.8715614)",
      11.415946362133418);
  graph.addEdge("(33.5835944, -101.8736298)", "(33.583597, -101.8735626)",
      6.829667524040205);
  graph.addEdge("(33.583597, -101.8735626)", "(33.5835724, -101.8734862)",
      8.31057025816934);
  graph.addEdge("(33.5835724, -101.8734862)", "(33.5835436, -101.8733988)",
      9.536074385739346);
  graph.addEdge("(33.5835436, -101.8733988)", "(33.583536, -101.8733597)",
      4.075211051636316);
  graph.addEdge("(33.583536, -101.8733597)", "(33.5835361, -101.8732776)",
      8.335097427791188);
  graph.addEdge("(33.5835361, -101.8732776)", "(33.5838259, -101.8732781)",
      35.15219637125123);
  graph.addEdge("(33.5838259, -101.8732781)", "(33.5838825, -101.8732771)",
      6.866217456092652);
  graph.addEdge("(33.5877425, -101.8746956)", "(33.5878778, -101.8746956)",
      16.41163005330882);
  graph.addEdge("(33.5874768, -101.8748486)", "(33.5874803, -101.8748086)",
      4.082892029882497);
  graph.addEdge("(33.5874803, -101.8748086)", "(33.5874865, -101.874587)",
      22.50917490733631);
  graph.addEdge("(33.5874865, -101.874587)", "(33.5874899, -101.8745456)",
      4.223071767332832);
  graph.addEdge("(33.5875017, -101.8744289)", "(33.5875053, -101.8744136)",
      1.6134554327438486);
  graph.addEdge("(33.5875053, -101.8744136)", "(33.5875203, -101.8743546)",
      6.259872467613142);
  graph.addEdge("(33.587913, -101.8752429)", "(33.587908, -101.8754916)",
      25.254931788379693);
  graph.addEdge("(33.5850726, -101.8770214)", "(33.5848743, -101.8768449)",
      29.994048002542783);
  graph.addEdge("(33.5848743, -101.8768449)", "(33.5848177, -101.8767968)",
      8.424987217150532);
  graph.addEdge("(33.5848177, -101.8767968)", "(33.5847482, -101.8767418)",
      10.111695759000511);
  graph.addEdge("(33.5847482, -101.8767418)", "(33.5847015, -101.8767034)",
      6.876469203729207);
  graph.addEdge("(33.5847015, -101.8767034)", "(33.5846837, -101.8766896)",
      2.5738209399050156);
  graph.addEdge("(33.5846837, -101.8766896)", "(33.5846606, -101.8766889)",
      2.802885254115492);
  graph.addEdge("(33.5846606, -101.8766889)", "(33.5846302, -101.8766887)",
      3.6875156057981497);
  graph.addEdge("(33.5846302, -101.8766887)", "(33.5844746, -101.876688)",
      18.874104888006134);
  graph.addEdge("(33.5844746, -101.876688)", "(33.5843219, -101.8766872)",
      18.52238445732887);
  graph.addEdge("(33.5843219, -101.8766872)", "(33.5842726, -101.8766879)",
      5.980414137447529);
  graph.addEdge("(33.5842726, -101.8766879)", "(33.5842458, -101.8767084)",
      3.8599322198511263);
  graph.addEdge("(33.5842458, -101.8767084)", "(33.5842031, -101.876741)",
      6.14655862341843);
  graph.addEdge("(33.5842031, -101.876741)", "(33.5841226, -101.8768025)",
      11.590017680681372);
  graph.addEdge("(33.583998, -101.8767833)", "(33.5841125, -101.8767844)",
      13.889070545120214);
  graph.addEdge("(33.5841965, -101.8755679)", "(33.5842032, -101.8757779)",
      21.335279531379676);
  graph.addEdge("(33.5842032, -101.8757779)", "(33.5842032, -101.8761901)",
      41.847711109224036);
  graph.addEdge("(33.5842032, -101.8761901)", "(33.5842031, -101.876741)",
      55.92892917342643);
  graph.addEdge("(33.5842458, -101.8767084)", "(33.584245, -101.876191)",
      52.5279770366593);
  graph.addEdge("(33.584245, -101.876191)", "(33.5842444, -101.8757784)",
      41.88836341482008);
  graph.addEdge("(33.5842444, -101.8757784)", "(33.5842032, -101.8757779)",
      4.997735737452444);
  graph.addEdge("(33.5842032, -101.8757779)", "(33.5840603, -101.875777)",
      17.333725951368518);
  graph.addEdge("(33.5840603, -101.875777)", "(33.5839508, -101.875777)",
      13.28213144096903);
  graph.addEdge("(33.5839508, -101.875777)", "(33.5836523, -101.8757771)",
      36.20745442864746);
  graph.addEdge("(33.5867434, -101.8739051)", "(33.5866812, -101.8739061)",
      7.545422137597716);
  graph.addEdge("(33.5866812, -101.8739061)", "(33.5866795, -101.8738977)",
      0.8773445530855638);
  graph.addEdge("(33.5866729, -101.8738664)", "(33.5866671, -101.8738391)",
      2.8593940008104397);
  graph.addEdge("(33.5866671, -101.8738391)", "(33.586679, -101.8737841)",
      5.767156173619284);
  graph.addEdge("(33.586679, -101.8737841)", "(33.5866849, -101.8737166)",
      6.8898641334533295);
  graph.addEdge("(33.5866849, -101.8737166)", "(33.5866998, -101.8736433)",
      7.657745260772706);
  graph.addEdge("(33.5866998, -101.8736433)", "(33.5867184, -101.8735861)",
      6.229824647487664);
  graph.addEdge("(33.5867184, -101.8735861)", "(33.5867274, -101.8735361)",
      5.192059907758725);
  graph.addEdge("(33.5867274, -101.8735361)", "(33.5867304, -101.8734936)",
      4.3299129025334935);
  graph.addEdge("(33.5858781, -101.8769165)", "(33.5858694, -101.8769339)",
      2.057677220895722);
  graph.addEdge("(33.5858694, -101.8769339)", "(33.5858697, -101.8769469)",
      1.3202730174094972);
  graph.addEdge("(33.5858697, -101.8769469)", "(33.5858702, -101.8769673)",
      2.0719137914025723);
  graph.addEdge("(33.5858702, -101.8769673)", "(33.5858677, -101.87755)",
      59.15699439880904);
  graph.addEdge("(33.5858677, -101.87755)", "(33.5858671, -101.8776104)",
      6.13229319093704);
  graph.addEdge("(33.5858671, -101.8776104)", "(33.5858694, -101.877844)",
      23.716918843690504);
  graph.addEdge("(33.5858694, -101.877844)", "(33.5858819, -101.8779782)",
      13.708211825543874);
  graph.addEdge("(33.5858819, -101.8779782)", "(33.5858957, -101.8780524)",
      7.716591079924063);
  graph.addEdge("(33.5858957, -101.8780524)", "(33.5859045, -101.8780784)",
      2.8472044282630025);
  graph.addEdge("(33.5859045, -101.8780784)", "(33.5859333, -101.878164)",
      9.36605566330833);
  graph.addEdge("(33.5859333, -101.878164)", "(33.5859708, -101.878267)",
      11.403148382701044);
  graph.addEdge("(33.5859708, -101.878267)", "(33.5859851, -101.8783442)",
      8.027052856824758);
  graph.addEdge("(33.5859851, -101.8783442)", "(33.5859956, -101.8784171)",
      7.509652980469793);
  graph.addEdge("(33.5859956, -101.8784171)", "(33.5859994, -101.8784914)",
      7.5570603223133315);
  graph.addEdge("(33.5859994, -101.8784914)", "(33.5859989, -101.8786464)",
      15.735829744247214);
  graph.addEdge("(33.5859989, -101.8786464)", "(33.5860002, -101.8786477)",
      0.2056289098156743);
  graph.addEdge("(33.5860002, -101.8786477)", "(33.5860175, -101.8786609)",
      2.489842383842993);
  graph.addEdge("(33.5860175, -101.8786609)", "(33.5860292, -101.8786719)",
      1.8058717585684672);
  graph.addEdge("(33.5860292, -101.8786719)", "(33.5860402, -101.8786857)",
      1.9346987793233734);
  graph.addEdge("(33.5860402, -101.8786857)", "(33.5860496, -101.8787025)",
      2.0515729166955428);
  graph.addEdge("(33.5860496, -101.8787025)", "(33.5860517, -101.8787205)",
      1.8450403210722075);
  graph.addEdge("(33.5860517, -101.8787205)", "(33.5860494, -101.8787384)",
      1.83851061482421);
  graph.addEdge("(33.5860494, -101.8787384)", "(33.5860403, -101.87878)",
      4.365126224786521);
  graph.addEdge("(33.5860403, -101.87878)", "(33.5860394, -101.8789644)",
      18.720731791464562);
  graph.addEdge("(33.5860394, -101.8789644)", "(33.5860392, -101.879128)",
      16.6088011543404);
  graph.addEdge("(33.5860392, -101.879128)", "(33.586039, -101.8791732)",
      4.588798926335657);
  graph.addEdge("(33.586039, -101.8791732)", "(33.5860386, -101.879249)",
      7.695420633780012);
  graph.addEdge("(33.5860386, -101.879249)", "(33.5860383, -101.8793013)",
      5.309656373773077);
  graph.addEdge("(33.5855758, -101.8744478)", "(33.5855761, -101.8744296)",
      1.848044575462796);
  graph.addEdge("(33.5861025, -101.8745314)", "(33.5861006, -101.8748434)",
      31.675268213458672);
  graph.addEdge("(33.5852998, -101.8748223)", "(33.5853016, -101.8745492)",
      27.72639393063584);
  graph.addEdge("(33.5853059, -101.874434)", "(33.5855761, -101.8744296)",
      32.777772207443654);
  graph.addEdge("(33.586684, -101.8745374)", "(33.5866859, -101.8748456)",
      31.289289669790307);
  graph.addEdge("(33.5877464, -101.8743526)", "(33.5878567, -101.8742812)",
      15.2165085562142);
  graph.addEdge("(33.5878567, -101.8742812)", "(33.5879573, -101.8742517)",
      12.564709617770049);
  graph.addEdge("(33.5879573, -101.8742517)", "(33.5885918, -101.8742705)",
      76.98729702439087);
  graph.addEdge("(33.5885918, -101.8742705)", "(33.5886431, -101.8742719)",
      6.224215111318431);
  graph.addEdge("(33.5886431, -101.8742719)", "(33.5886978, -101.8742742)",
      6.639112905947531);
  graph.addEdge("(33.5886978, -101.8742742)", "(33.5887723, -101.8742755)",
      9.03767183601674);
  graph.addEdge("(33.5830593, -101.8810496)", "(33.5830721, -101.8810065)",
      4.642982505064454);
  graph.addEdge("(33.5830721, -101.8810065)", "(33.5831018, -101.8809767)",
      4.70441600445068);
  graph.addEdge("(33.5831018, -101.8809767)", "(33.5834954, -101.8807584)",
      52.63617746259137);
  graph.addEdge("(33.5806182, -101.8811987)", "(33.580619, -101.8809418)",
      26.082474272881903);
  graph.addEdge("(33.580619, -101.8809418)", "(33.5805858, -101.8809843)",
      5.902188076841716);
  graph.addEdge("(33.5805858, -101.8809843)", "(33.5805615, -101.8810188)",
      4.577858523921741);
  graph.addEdge("(33.5805615, -101.8810188)", "(33.580543, -101.8810321)",
      2.618955430630498);
  graph.addEdge("(33.580543, -101.8810321)", "(33.5805157, -101.8810454)",
      3.5761616643401095);
  graph.addEdge("(33.5805157, -101.8810454)", "(33.5804834, -101.8810485)",
      3.930544578004764);
  graph.addEdge("(33.5804834, -101.8810485)", "(33.580458, -101.8810477)",
      3.082037953376762);
  graph.addEdge("(33.580458, -101.8810477)", "(33.5804235, -101.8810368)",
      4.328630302936893);
  graph.addEdge("(33.5804235, -101.8810368)", "(33.5803942, -101.8810141)",
      4.235873600591204);
  graph.addEdge("(33.5803942, -101.8810141)", "(33.5803786, -101.8809836)",
      3.628970357775694);
  graph.addEdge("(33.5803786, -101.8809836)", "(33.5803513, -101.880924)",
      6.897864867058672);
  graph.addEdge("(33.5803513, -101.880924)", "(33.5803373, -101.8808982)",
      3.121709595838573);
  graph.addEdge("(33.5803373, -101.8808982)", "(33.5803195, -101.8808844)",
      2.573858049494204);
  graph.addEdge("(33.5803195, -101.8808844)", "(33.5803011, -101.8808803)",
      2.270368095890352);
  graph.addEdge("(33.5803011, -101.8808803)", "(33.5802803, -101.8808761)",
      2.5587777482626857);
  graph.addEdge("(33.5802803, -101.8808761)", "(33.5802602, -101.8808761)",
      2.438088405859983);
  graph.addEdge("(33.5802602, -101.8808761)", "(33.5802602, -101.8808499)",
      2.660019155490916);
  graph.addEdge("(33.5802602, -101.8808499)", "(33.5802579, -101.8808154)",
      3.5137898664356784);
  graph.addEdge("(33.5802579, -101.8808154)", "(33.5802528, -101.8807947)",
      2.190773726824136);
  graph.addEdge("(33.5802528, -101.8807947)", "(33.5802472, -101.8807745)",
      2.160419076564124);
  graph.addEdge("(33.5805316, -101.8808088)", "(33.5803752, -101.8808097)",
      18.971216975055);
  graph.addEdge("(33.5803752, -101.8808097)", "(33.5803604, -101.8808094)",
      1.7954677662291285);
  graph.addEdge("(33.5803604, -101.8808094)", "(33.5803369, -101.8808088)",
      2.851152238118549);
  graph.addEdge("(33.5803369, -101.8808088)", "(33.5802963, -101.8808044)",
      4.944915582088401);
  graph.addEdge("(33.5802963, -101.8808044)", "(33.5802746, -101.8808015)",
      2.648581104183457);
  graph.addEdge("(33.5802746, -101.8808015)", "(33.5802528, -101.8807947)",
      2.7329341631118576);
  graph.addEdge("(33.5803604, -101.8808094)", "(33.5803479, -101.8808318)",
      2.7333089224008495);
  graph.addEdge("(33.5803479, -101.8808318)", "(33.5803412, -101.8808624)",
      3.211275329377468);
  graph.addEdge("(33.5803412, -101.8808624)", "(33.5803373, -101.8808982)",
      3.665335125072197);
  graph.addEdge("(33.5805157, -101.8810454)", "(33.5804921, -101.8811994)",
      15.895081318104097);
  graph.addEdge("(33.5846109, -101.8708252)", "(33.5845926, -101.8708196)",
      2.29140292908578);
  graph.addEdge("(33.5845116, -101.8708173)", "(33.5844621, -101.8708168)",
      6.004466235886689);
  graph.addEdge("(33.5870319, -101.872836)", "(33.5870847, -101.8729624)",
      14.341546341491298);
  graph.addEdge("(33.5870847, -101.8729624)", "(33.5872585, -101.8729639)",
      21.082153876049492);
  graph.addEdge("(33.5844713, -101.8746846)", "(33.5845375, -101.8748543)",
      19.00779576771049);
  graph.addEdge("(33.5845375, -101.8748543)", "(33.584725, -101.8753363)",
      53.96086006570545);
  graph.addEdge("(33.584725, -101.8753363)", "(33.5847361, -101.8753625)",
      2.981239134050673);
  graph.addEdge("(33.5847361, -101.8753625)", "(33.5847608, -101.8754206)",
      6.615736490299681);
  graph.addEdge("(33.5847608, -101.8754206)", "(33.5847901, -101.8754896)",
      7.855035088720883);
  graph.addEdge("(33.586267, -101.8741879)", "(33.5862672, -101.8738345)",
      35.87732264163521);
  graph.addEdge("(33.5851224, -101.8733899)", "(33.5850654, -101.8734416)",
      8.680543011732683);
  graph.addEdge("(33.5850654, -101.8734416)", "(33.5850246, -101.8734859)",
      6.6872240593832535);
  graph.addEdge("(33.5850246, -101.8734859)", "(33.5849819, -101.8735383)",
      7.424699364967995);
  graph.addEdge("(33.5849819, -101.8735383)", "(33.5849431, -101.8735884)",
      6.9296311137105775);
  graph.addEdge("(33.5849431, -101.8735884)", "(33.5848972, -101.87365)",
      8.373015347946422);
  graph.addEdge("(33.5808708, -101.876361)", "(33.580872, -101.8759365)",
      43.09834396593109);
  graph.addEdge("(33.5860959, -101.8782751)", "(33.5860767, -101.8783979)",
      12.682401534183004);
  graph.addEdge("(33.5860767, -101.8783979)", "(33.5860707, -101.8784474)",
      5.07769944536591);
  graph.addEdge("(33.5860707, -101.8784474)", "(33.5860677, -101.8785004)",
      5.392885440721607);
  graph.addEdge("(33.5860677, -101.8785004)", "(33.5860699, -101.8785399)",
      4.018934886188019);
  graph.addEdge("(33.5860699, -101.8785399)", "(33.5860744, -101.8785786)",
      3.966584937633031);
  graph.addEdge("(33.5860744, -101.8785786)", "(33.5860804, -101.8786037)",
      2.6500633572324412);
  graph.addEdge("(33.5860804, -101.8786037)", "(33.5860842, -101.8786271)",
      2.4198868339384094);
  graph.addEdge("(33.5860842, -101.8786271)", "(33.5860834, -101.8786469)",
      2.0124493686012106);
  graph.addEdge("(33.5860834, -101.8786469)", "(33.5860804, -101.8786738)",
      2.755042822321135);
  graph.addEdge("(33.5860804, -101.8786738)", "(33.5860729, -101.878721)",
      4.8773678637060565);
  graph.addEdge("(33.5846023, -101.8736209)", "(33.5843483, -101.8736184)",
      30.810740758715223);
  graph.addEdge("(33.5843484, -101.873549)", "(33.5843722, -101.8735104)",
      4.867334012093964);
  graph.addEdge("(33.5843722, -101.8735104)", "(33.584394, -101.8734825)",
      3.8749521377215776);
  graph.addEdge("(33.584394, -101.8734825)", "(33.5844225, -101.8734609)",
      4.093844233750769);
  graph.addEdge("(33.5844225, -101.8734609)", "(33.5844487, -101.8734483)",
      3.425791399521856);
  graph.addEdge("(33.5844487, -101.8734483)", "(33.5844817, -101.8734456)",
      4.012208895310001);
  graph.addEdge("(33.5844817, -101.8734456)", "(33.5845102, -101.873451)",
      3.500192857339784);
  graph.addEdge("(33.5845102, -101.873451)", "(33.5845364, -101.8734654)",
      3.4981358782173606);
  graph.addEdge("(33.5845364, -101.8734654)", "(33.5845596, -101.873487)",
      3.56762938241248);
  graph.addEdge("(33.5845596, -101.873487)", "(33.5845844, -101.8735167)",
      4.259194153595636);
  graph.addEdge("(33.5845844, -101.8735167)", "(33.5846016, -101.8735436)",
      3.4366922813043534);
  graph.addEdge("(33.5861028, -101.8738349)", "(33.5861551, -101.8737382)",
      11.688420811232);
  graph.addEdge("(33.5861551, -101.8737382)", "(33.5861808, -101.8736911)",
      5.708046346447119);
  graph.addEdge("(33.5861808, -101.8736911)", "(33.5862036, -101.8736494)",
      5.056702053175706);
  graph.addEdge("(33.5862036, -101.8736494)", "(33.5862067, -101.8734946)",
      15.719869322625);
  graph.addEdge("(33.5861551, -101.8737382)", "(33.5862672, -101.8738345)",
      16.747260658035948);
  graph.addEdge("(33.5862921, -101.8738345)", "(33.5862926, -101.8736939)",
      14.273894950740727);
  graph.addEdge("(33.5862926, -101.8736939)", "(33.5862934, -101.8734935)",
      20.344916385106636);
  graph.addEdge("(33.5861053, -101.8736898)", "(33.5861808, -101.8736911)",
      9.158953387689532);
  graph.addEdge("(33.5861808, -101.8736911)", "(33.5862926, -101.8736939)",
      13.5641006044283);
  graph.addEdge("(33.5806242, -101.8746748)", "(33.5806544, -101.8746748)",
      3.663197723870771);
  graph.addEdge("(33.5805615, -101.874673)", "(33.580613, -101.8746747)",
      6.249227649479552);
  graph.addEdge("(33.5805616, -101.8753584)", "(33.5805617, -101.8751725)",
      18.873890991931688);
  graph.addEdge("(33.5798439, -101.8787446)", "(33.5800136, -101.8787437)",
      20.584460510798397);
  graph.addEdge("(33.5800136, -101.8787437)", "(33.5800736, -101.878742)",
      7.2799218829419265);
  graph.addEdge("(33.5800736, -101.878742)", "(33.5800691, -101.8782593)",
      49.010445904019306);
  graph.addEdge("(33.5819575, -101.8763127)", "(33.5817108, -101.8763132)",
      29.92425013333438);
  graph.addEdge("(33.5816974, -101.8763132)", "(33.5816866, -101.8763127)",
      1.3110011096926746);
  graph.addEdge("(33.5818901, -101.8764242)", "(33.581647, -101.876426)",
      29.48810037291863);
  graph.addEdge("(33.5823123, -101.8757732)", "(33.5822631, -101.8757741)",
      5.968559588897617);
  graph.addEdge("(33.5822631, -101.8757741)", "(33.582263, -101.875749)",
      2.5483089645274735);
  graph.addEdge("(33.582263, -101.875749)", "(33.5822568, -101.8757434)",
      0.9427691773757578);
  graph.addEdge("(33.5822568, -101.8757434)", "(33.5822372, -101.8757254)",
      2.998633599393503);
  graph.addEdge("(33.5822372, -101.8757254)", "(33.5821999, -101.8757263)",
      4.5253368048091);
  graph.addEdge("(33.5821999, -101.8757263)", "(33.582177, -101.8757547)",
      4.0036552675658195);
  graph.addEdge("(33.582177, -101.8757547)", "(33.582177, -101.8757736)",
      1.9188263589851902);
  graph.addEdge("(33.582177, -101.8757736)", "(33.582177, -101.8757917)",
      1.837606194695329);
  graph.addEdge("(33.582177, -101.8757917)", "(33.5822014, -101.8758201)",
      4.131967653644186);
  graph.addEdge("(33.5822014, -101.8758201)", "(33.5822179, -101.8758224)",
      2.014992276815297);
  graph.addEdge("(33.5822179, -101.8758224)", "(33.58223, -101.8758237)",
      1.473627717136683);
  graph.addEdge("(33.58223, -101.8758237)", "(33.5822621, -101.8757962)",
      4.791196059265085);
  graph.addEdge("(33.5822621, -101.8757962)", "(33.5822631, -101.8757741)",
      2.24698117741709);
  graph.addEdge("(33.5822179, -101.8758224)", "(33.5822184, -101.875923)",
      10.213610762163388);
  graph.addEdge("(33.5822184, -101.875923)", "(33.5822184, -101.876049)",
      12.792169617153746);
  graph.addEdge("(33.582177, -101.8757736)", "(33.582154, -101.8757723)",
      2.792973447373997);
  graph.addEdge("(33.5822568, -101.8757434)", "(33.582257, -101.8756243)",
      12.091665010668349);
  graph.addEdge("(33.582257, -101.8756243)", "(33.5822571, -101.8755584)",
      6.690515772899643);
  graph.addEdge("(33.5823907, -101.8756253)", "(33.5823124, -101.8756243)",
      9.498173783041311);
  graph.addEdge("(33.5823124, -101.8756243)", "(33.582257, -101.8756243)",
      6.7199075517899045);
  graph.addEdge("(33.582257, -101.8756243)", "(33.5821538, -101.8756239)",
      12.518016239812141);
  graph.addEdge("(33.5798557, -101.8767732)", "(33.5799452, -101.8767732)",
      10.85616414732895);
  graph.addEdge("(33.5800117, -101.8767725)", "(33.5800946, -101.8767729)",
      10.05568010807859);
  graph.addEdge("(33.5800946, -101.8767729)", "(33.5801951, -101.8767733)",
      12.190509432639105);
  graph.addEdge("(33.5801951, -101.8767733)", "(33.5804905, -101.8767731)",
      35.83141490097684);
  graph.addEdge("(33.5804905, -101.8767731)", "(33.5805687, -101.876773)",
      9.48550401117058);
  graph.addEdge("(33.5805687, -101.876773)", "(33.5807485, -101.8767732)",
      21.809378762150274);
  graph.addEdge("(33.5804905, -101.8767731)", "(33.5804885, -101.8768971)",
      12.591707527594405);
  graph.addEdge("(33.5807379, -101.8769316)", "(33.5806604, -101.8769319)",
      9.400639623972902);
  graph.addEdge("(33.5800134, -101.879365)", "(33.5798438, -101.8793644)",
      20.572218099087575);
  graph.addEdge("(33.5800131, -101.879128)", "(33.5798438, -101.8791254)",
      20.537435048918987);
  graph.addEdge("(33.581151, -101.8799055)", "(33.5811027, -101.8799046)",
      5.85940336765416);
  graph.addEdge("(33.5811027, -101.8799046)", "(33.5810824, -101.8799235)",
      3.1217216334095244);
  graph.addEdge("(33.5810824, -101.8799235)", "(33.5810553, -101.8799389)",
      3.6400649508346845);
  graph.addEdge("(33.5810553, -101.8799389)", "(33.5808624, -101.8799414)",
      23.3997500497944);
  graph.addEdge("(33.5808625, -101.8798782)", "(33.5808624, -101.8799414)",
      6.416501655627607);
  graph.addEdge("(33.5803392, -101.8811037)", "(33.5803942, -101.8810141)",
      11.28095930259481);
  graph.addEdge("(33.5802371, -101.8809489)", "(33.5802602, -101.8808761)",
      7.904488000979143);
  graph.addEdge("(33.581684, -101.8811847)", "(33.5816882, -101.880906)",
      28.29982054073272);
  graph.addEdge("(33.5816882, -101.880906)", "(33.5816908, -101.8807295)",
      17.922074332436544);
  graph.addEdge("(33.581684, -101.8811847)", "(33.581614, -101.8810494)",
      16.148824757846096);
  graph.addEdge("(33.581614, -101.8810494)", "(33.5815251, -101.8808665)",
      21.473066029176046);
  graph.addEdge("(33.5816554, -101.8807311)", "(33.5815248, -101.8804733)",
      30.594102167561196);
  graph.addEdge("(33.5815842, -101.8803961)", "(33.5816496, -101.8803987)",
      7.937276943362511);
  graph.addEdge("(33.5815246, -101.8803954)", "(33.5815688, -101.8803955)",
      5.361379257185967);
  graph.addEdge("(33.5825758, -101.8807253)", "(33.5825144, -101.8807221)",
      7.454778172833598);
  graph.addEdge("(33.5825144, -101.8807221)", "(33.5824602, -101.8806494)",
      9.884286257314931);
  graph.addEdge("(33.5824602, -101.8806494)", "(33.5821644, -101.88065)",
      35.879991464695074);
  graph.addEdge("(33.5818699, -101.8789436)", "(33.5823475, -101.8789493)",
      57.93479921175325);
  graph.addEdge("(33.5825332, -101.8797928)", "(33.5825354, -101.8795308)",
      26.60083243405729);
  graph.addEdge("(33.5825354, -101.8795308)", "(33.5825434, -101.8795155)",
      1.83152289512495);
  graph.addEdge("(33.5825434, -101.8795155)", "(33.582579, -101.8795147)",
      4.318971684679703);
  graph.addEdge("(33.58258, -101.8793902)", "(33.5825396, -101.8793917)",
      4.902803900051727);
  graph.addEdge("(33.5825396, -101.8793917)", "(33.5825295, -101.87937)",
      2.520811269730851);
  graph.addEdge("(33.5825295, -101.87937)", "(33.5825264, -101.879289)",
      8.232100689785554);
  graph.addEdge("(33.5825264, -101.879289)", "(33.5825032, -101.8791648)",
      12.91958695310242);
  graph.addEdge("(33.5825032, -101.8791648)", "(33.582419, -101.8789401)",
      24.994554629321225);
  graph.addEdge("(33.582419, -101.8789401)", "(33.582459, -101.8789185)",
      5.324480578922016);
  graph.addEdge("(33.5825032, -101.8791648)", "(33.582546, -101.8791452)",
      5.559844632021372);
  graph.addEdge("(33.5823467, -101.878997)", "(33.5823475, -101.8789493)",
      4.843714862355904);
  graph.addEdge("(33.5823475, -101.8789493)", "(33.5823514, -101.8787831)",
      16.88008542326308);
  graph.addEdge("(33.5823514, -101.8787831)", "(33.5824109, -101.878781)",
      7.220377736825617);
  graph.addEdge(
      "(33.581645, -101.8780003)", "(33.5819533, -101.878)", 37.39617369052279);
  graph.addEdge("(33.5816451, -101.8779221)", "(33.5819542, -101.8779213)",
      37.49328762903636);
  graph.addEdge("(33.5819542, -101.8779213)", "(33.582089, -101.8779209)",
      16.351016124014244);
  graph.addEdge("(33.582089, -101.8779209)", "(33.582371, -101.8779202)",
      34.20610113116869);
  graph.addEdge("(33.5819542, -101.8779213)", "(33.5819536, -101.8779742)",
      5.371190214214712);
  graph.addEdge("(33.5819536, -101.8779742)", "(33.5819533, -101.878)",
      2.619609780290255);
  graph.addEdge("(33.5819533, -101.878)", "(33.5819531, -101.8780174)",
      1.7667096814083618);
  graph.addEdge("(33.5819536, -101.8779742)", "(33.582089, -101.8779746)",
      16.423794678584994);
  graph.addEdge("(33.582089, -101.8779746)", "(33.5823812, -101.8779757)",
      35.44344256147396);
  graph.addEdge("(33.582089, -101.8779209)", "(33.582089, -101.8779746)",
      5.4519089974649315);
  graph.addEdge("(33.582089, -101.8779746)", "(33.5820897, -101.8780189)",
      4.498372504821498);
  graph.addEdge("(33.5816438, -101.8777048)", "(33.582127, -101.8777087)",
      58.61251284179506);
  graph.addEdge("(33.5829242, -101.8755672)", "(33.5829226, -101.8754214)",
      14.80351957887654);
  graph.addEdge("(33.5829226, -101.8754214)", "(33.5829211, -101.8753168)",
      10.621003689940451);
  graph.addEdge("(33.5829211, -101.8753168)", "(33.5829192, -101.8751925)",
      12.62157900369046);
  graph.addEdge("(33.5829192, -101.8751925)", "(33.5829212, -101.8748889)",
      30.823742445125227);
  graph.addEdge("(33.5829212, -101.8748889)", "(33.5829222, -101.8747458)",
      14.528638286724792);
  graph.addEdge("(33.5829222, -101.8747458)", "(33.5829226, -101.8746801)",
      6.670325029494067);
  graph.addEdge("(33.5829226, -101.8746801)", "(33.5829231, -101.8746074)",
      7.381068022899935);
  graph.addEdge("(33.5829231, -101.8746074)", "(33.5829242, -101.8744377)",
      17.22919543191646);
  graph.addEdge("(33.5829242, -101.8744377)", "(33.5829262, -101.8741336)",
      30.87450126324482);
  graph.addEdge("(33.5829262, -101.8741336)", "(33.5829275, -101.873945)",
      19.148137197527724);
  graph.addEdge("(33.5829192, -101.8751925)", "(33.5830118, -101.8751926)",
      11.232197871129529);
  graph.addEdge("(33.5829262, -101.8741336)", "(33.5830112, -101.8741304)",
      10.315445777927637);
  graph.addEdge("(33.5830112, -101.8741304)", "(33.5832409, -101.8739306)",
      34.463905240248465);
  graph.addEdge("(33.5831691, -101.873805)", "(33.5831894, -101.8736245)",
      18.489780840501613);
  graph.addEdge("(33.5831894, -101.8736245)", "(33.5831913, -101.8734364)",
      19.098058323601943);
  graph.addEdge("(33.5829283, -101.8738021)", "(33.5829507, -101.8736609)",
      14.59045556644368);
  graph.addEdge("(33.5829507, -101.8736609)", "(33.5829546, -101.8735066)",
      15.672340058726295);
  graph.addEdge("(33.5829546, -101.8735066)", "(33.5829553, -101.8734491)",
      5.838264322690867);
  graph.addEdge("(33.5827873, -101.873788)", "(33.5827895, -101.8735002)",
      29.21996628322567);
  graph.addEdge("(33.5827895, -101.8735002)", "(33.5829546, -101.8735066)",
      20.03683473383377);
  graph.addEdge("(33.5830789, -101.8755656)", "(33.5830778, -101.8756846)",
      12.082110463918287);
  graph.addEdge("(33.5830778, -101.8756846)", "(33.5830769, -101.875782)",
      9.889054783353117);
  graph.addEdge("(33.5830769, -101.875782)", "(33.5830769, -101.8757981)",
      1.6345388206278406);
  graph.addEdge("(33.5830769, -101.8757981)", "(33.583077, -101.875828)",
      3.0355963290682526);
  graph.addEdge("(33.583077, -101.875828)", "(33.5831705, -101.8758268)",
      11.342016082086712);
  graph.addEdge("(33.5831705, -101.8758268)", "(33.5831714, -101.8758436)",
      1.7090939922226815);
  graph.addEdge("(33.5831714, -101.8758436)", "(33.5830374, -101.8758475)",
      16.258752031265622);
  graph.addEdge("(33.5832295, -101.8757816)", "(33.5830769, -101.875782)",
      18.510117407054786);
  graph.addEdge("(33.5829926, -101.875565)", "(33.5829913, -101.8756843)",
      12.112869452205405);
  graph.addEdge("(33.5829913, -101.8756843)", "(33.58299, -101.8757981)",
      11.55453585369661);
  graph.addEdge("(33.58299, -101.8757981)", "(33.5830377, -101.8757984)",
      5.785994025762988);
  graph.addEdge("(33.5830377, -101.8757984)", "(33.5830769, -101.8757981)",
      4.754978574250408);
  graph.addEdge("(33.5830778, -101.8756846)", "(33.5829913, -101.8756843)",
      10.492319904902947);
  graph.addEdge("(33.5830379, -101.8758097)", "(33.5830377, -101.8757984)",
      1.1474798901116667);
  graph.addEdge("(33.5830115, -101.8753181)", "(33.5829211, -101.8753168)",
      10.966131972482513);
  graph.addEdge("(33.5830112, -101.8754223)", "(33.5829226, -101.8754214)",
      10.747389767206258);
  graph.addEdge("(33.5824713, -101.8768872)", "(33.5825703, -101.8768903)",
      12.012623091793554);
  graph.addEdge("(33.5825703, -101.8768903)", "(33.5825702, -101.8769069)",
      1.685354395219559);
  graph.addEdge("(33.5824702, -101.8774096)", "(33.5825363, -101.8774107)",
      8.01857383707089);
  graph.addEdge("(33.5823851, -101.8770921)", "(33.5824275, -101.8770918)",
      5.143124224235481);
  graph.addEdge("(33.5824275, -101.8770918)", "(33.5824707, -101.8770915)",
      5.240160969201913);
  graph.addEdge("(33.5824707, -101.8770915)", "(33.5825024, -101.8770913)",
      3.845199393510294);
  graph.addEdge("(33.5825024, -101.8770913)", "(33.5825109, -101.8770916)",
      1.0314825528467007);
  graph.addEdge("(33.5825335, -101.8770919)", "(33.5825399, -101.877092)",
      0.776373425685626);
  graph.addEdge("(33.5825399, -101.877092)", "(33.5825481, -101.8770925)",
      0.9959379021533324);
  graph.addEdge("(33.5825024, -101.8770913)", "(33.5825027, -101.8770667)",
      2.497775732383906);
  graph.addEdge("(33.5825027, -101.8770667)", "(33.5825253, -101.8770667)",
      2.74133423028946);
  graph.addEdge("(33.5825253, -101.8770667)", "(33.5825266, -101.8769866)",
      8.133664810389474);
  graph.addEdge("(33.5825266, -101.8769866)", "(33.5825396, -101.8769873)",
      1.5784743134016792);
  graph.addEdge("(33.5825396, -101.8769873)", "(33.5825399, -101.877092)",
      10.629706690374574);
  graph.addEdge("(33.5826173, -101.8777594)", "(33.58262, -101.8775766)",
      18.56160228544064);
  graph.addEdge("(33.5824654, -101.878028)", "(33.5825382, -101.8780293)",
      8.831478806307624);
  graph.addEdge("(33.5824649, -101.878169)", "(33.5825345, -101.8781709)",
      8.44454246720586);
  graph.addEdge("(33.5839917, -101.8772065)", "(33.5841022, -101.8772088)",
      13.405463323714836);
  graph.addEdge("(33.5843171, -101.8777718)", "(33.5843177, -101.8771911)",
      58.95427546449083);
  graph.addEdge("(33.5846606, -101.8766889)", "(33.5846589, -101.8761459)",
      55.126992808000864);
  graph.addEdge("(33.5846589, -101.8761459)", "(33.5846577, -101.8757619)",
      38.984834342383735);
  graph.addEdge("(33.5846577, -101.8757619)", "(33.5846614, -101.8756563)",
      10.73014455704466);
  graph.addEdge("(33.5846614, -101.8756563)", "(33.5846565, -101.8756253)",
      3.2028232516948933);
  graph.addEdge("(33.5846614, -101.8756563)", "(33.58475, -101.8756571)",
      10.747311261409667);
  graph.addEdge("(33.5848727, -101.8756582)", "(33.5848735, -101.8755039)",
      15.665152395465993);
  graph.addEdge("(33.5851366, -101.8755024)", "(33.5849737, -101.875504)",
      19.760115859433053);
  graph.addEdge("(33.5851372, -101.8753257)", "(33.5850153, -101.875325)",
      14.786400027649705);
  graph.addEdge("(33.5853009, -101.8750192)", "(33.5851846, -101.8750176)",
      14.107895838869105);
  graph.addEdge("(33.5851846, -101.8750176)", "(33.5851427, -101.8750749)",
      7.724662094793943);
  graph.addEdge("(33.58475, -101.8757628)", "(33.58475, -101.8756571)",
      10.730895596573472);
  graph.addEdge("(33.58475, -101.8756571)", "(33.58475, -101.8755096)",
      14.974523182342695);
  graph.addEdge("(33.5846589, -101.8761459)", "(33.584875, -101.8761548)",
      26.228069956469312);
  graph.addEdge("(33.5844746, -101.876688)", "(33.5844741, -101.8767171)",
      2.9549276196806846);
  graph.addEdge("(33.5844741, -101.8767171)", "(33.5844737, -101.8767278)",
      1.0873739204654198);
  graph.addEdge("(33.5844737, -101.8767278)", "(33.5844724, -101.8768207)",
      9.43275980269664);
  graph.addEdge("(33.5847015, -101.8767034)", "(33.5846999, -101.8768208)",
      11.920292018226613);
  graph.addEdge("(33.5846999, -101.8768208)", "(33.5846572, -101.8768207)",
      5.179435284689334);
  graph.addEdge("(33.5846572, -101.8768207)", "(33.5844724, -101.8768207)",
      22.415873171813445);
  graph.addEdge("(33.5846572, -101.8768207)", "(33.5846565, -101.876795)",
      2.6105043369930176);
  graph.addEdge("(33.5846565, -101.876795)", "(33.5846309, -101.8767603)",
      4.69603448903318);
  graph.addEdge("(33.5846306, -101.8767418)", "(33.5846302, -101.8766887)",
      5.391054122852969);
  graph.addEdge("(33.5844724, -101.8768207)", "(33.5842763, -101.8768176)",
      23.788621952857643);
  graph.addEdge("(33.5842763, -101.8768176)", "(33.5842473, -101.8768172)",
      3.5178766580099747);
  graph.addEdge("(33.5842473, -101.8768172)", "(33.5842458, -101.8767084)",
      11.047176970638661);
  graph.addEdge("(33.5842763, -101.8768176)", "(33.5843201, -101.8767593)",
      7.953508519138398);
  graph.addEdge("(33.5843206, -101.8767416)", "(33.5843219, -101.8766872)",
      5.525085187074753);
  graph.addEdge("(33.5868982, -101.8768255)", "(33.586897, -101.8759816)",
      85.67257820014619);
  graph.addEdge("(33.586897, -101.8759816)", "(33.5868967, -101.8758052)",
      17.908107967713676);
  graph.addEdge("(33.5868967, -101.8758052)", "(33.5868095, -101.8758037)",
      10.57828695140126);
  graph.addEdge("(33.5868095, -101.8758037)", "(33.5865059, -101.8757988)",
      36.829449446480695);
  graph.addEdge("(33.5868095, -101.8758037)", "(33.5868075, -101.8755364)",
      27.13732165425833);
  graph.addEdge("(33.586897, -101.8759816)", "(33.5870707, -101.8759835)",
      21.070356361152253);
  graph.addEdge("(33.5872209, -101.8754844)", "(33.5872923, -101.8754321)",
      10.15862922887684);
  graph.addEdge("(33.5872923, -101.8754321)", "(33.5873397, -101.8754313)",
      5.750102049921581);
  graph.addEdge("(33.5887532, -101.8750936)", "(33.5888152, -101.8750217)",
      10.480200213019968);
  graph.addEdge("(33.5888152, -101.8750217)", "(33.5888095, -101.8745459)",
      48.3069429546137);
  graph.addEdge("(33.5888095, -101.8745459)", "(33.5887552, -101.8745446)",
      6.587808740587946);
  graph.addEdge("(33.5887552, -101.8745446)", "(33.5887501, -101.8745332)",
      1.3122626602575371);
  graph.addEdge("(33.5887501, -101.8745332)", "(33.5887495, -101.874364)",
      17.176916317584293);
  graph.addEdge("(33.5887495, -101.874364)", "(33.5887577, -101.8743496)",
      1.768142765983759);
  graph.addEdge("(33.5887577, -101.8743496)", "(33.5887729, -101.8743238)",
      3.20301378794953);
  graph.addEdge("(33.5887729, -101.8743238)", "(33.5887723, -101.8742755)",
      4.903834377342124);
  graph.addEdge("(33.5879938, -101.8757369)", "(33.588133, -101.8756256)",
      20.316495646516);
  graph.addEdge("(33.588133, -101.8756256)", "(33.5881999, -101.8755715)",
      9.798683396344522);
  graph.addEdge("(33.5881999, -101.8755715)", "(33.5883724, -101.8755691)",
      20.92533866499922);
  graph.addEdge("(33.5883724, -101.8755691)", "(33.5883857, -101.8755692)",
      1.6132965380309536);
  graph.addEdge("(33.5883857, -101.8755692)", "(33.5883869, -101.8754638)",
      10.700980082378258);
  graph.addEdge("(33.5883869, -101.8754638)", "(33.5886621, -101.8754653)",
      33.38158244616987);
  graph.addEdge("(33.5882897, -101.8759382)", "(33.5882194, -101.8758165)",
      15.011794139508728);
  graph.addEdge("(33.5861023, -101.8744415)", "(33.586365, -101.8744435)",
      31.86564402253375);
  graph.addEdge("(33.586365, -101.8744435)", "(33.5865898, -101.874444)",
      27.267849458982084);
  graph.addEdge("(33.5865898, -101.874444)", "(33.586685, -101.874444)",
      11.547574904278758);
  graph.addEdge("(33.586685, -101.874444)", "(33.5869717, -101.8744439)",
      34.776155123705614);
  graph.addEdge("(33.5869717, -101.8744439)", "(33.5870109, -101.8744257)",
      5.10125038331188);
  graph.addEdge("(33.5870109, -101.8744257)", "(33.5871765, -101.8744265)",
      20.087123692112662);
  graph.addEdge("(33.5871765, -101.8744265)", "(33.5872138, -101.874447)",
      4.980113127610964);
  graph.addEdge("(33.5872138, -101.874447)", "(33.5874021, -101.8744485)",
      22.840933987168214);
  graph.addEdge("(33.5874021, -101.8744485)", "(33.5874672, -101.8744295)",
      8.128670903161128);
  graph.addEdge("(33.5874672, -101.8744295)", "(33.5875053, -101.8744136)",
      4.895237176302466);
  graph.addEdge("(33.5877443, -101.8743636)", "(33.5878795, -101.8743655)",
      16.400634535541194);
  graph.addEdge("(33.586035, -101.8795813)", "(33.585953, -101.8795813)",
      9.946439530838996);
  graph.addEdge("(33.5856118, -101.88018)", "(33.585613, -101.8801174)",
      6.356892616342859);
  graph.addEdge("(33.585613, -101.8801174)", "(33.585613, -101.8800487)",
      6.974505094034573);
  graph.addEdge("(33.5863866, -101.8801884)", "(33.5863858, -101.8801158)",
      7.371010733998528);
  graph.addEdge("(33.5863858, -101.8801158)", "(33.5863858, -101.8800522)",
      6.456689513419067);
  graph.addEdge("(33.587032, -101.8787408)", "(33.5870527, -101.8787253)",
      2.963196710395326);
  graph.addEdge("(33.5870527, -101.8787253)", "(33.587064, -101.8787131)",
      1.8473513085422923);
  graph.addEdge("(33.587064, -101.8787131)", "(33.5870888, -101.8786838)",
      4.230483483253754);
  graph.addEdge("(33.5870876, -101.8788074)", "(33.5870712, -101.8787812)",
      3.3214238882035825);
  graph.addEdge("(33.5870712, -101.8787812)", "(33.5870603, -101.8787677)",
      1.9043065680989661);
  graph.addEdge("(33.5870603, -101.8787677)", "(33.587032, -101.8787408)",
      4.386495989258553);
  graph.addEdge("(33.5872247, -101.8802581)", "(33.5869348, -101.8802611)",
      35.16562772856595);
  graph.addEdge("(33.5866079, -101.8808642)", "(33.5866249, -101.880502)",
      36.82832017844154);
  graph.addEdge("(33.5866249, -101.880502)", "(33.5866076, -101.8805016)",
      2.098849230071508);
  graph.addEdge("(33.5866076, -101.8805016)", "(33.586606, -101.8803643)",
      13.940049330588144);
  graph.addEdge("(33.5866249, -101.880502)", "(33.5866721, -101.8805029)",
      5.725997251678651);
  graph.addEdge("(33.5873806, -101.8797904)", "(33.5877757, -101.8797892)",
      47.92502393560513);
  graph.addEdge("(33.5825083, -101.8718129)", "(33.5825053, -101.8713032)",
      51.748479183632455);
  graph.addEdge("(33.5825053, -101.8713032)", "(33.5828944, -101.8713033)",
      47.19704448317511);
  graph.addEdge("(33.5828962, -101.8711958)", "(33.5829882, -101.8711016)",
      14.696760907372878);
  graph.addEdge("(33.5829882, -101.8711016)", "(33.5831413, -101.8709587)",
      23.56582380737665);
  graph.addEdge("(33.5831413, -101.8709587)", "(33.5832977, -101.8708587)",
      21.51674321385093);
  graph.addEdge("(33.5836325, -101.8710902)", "(33.5833964, -101.871099)",
      28.65238850625931);
  graph.addEdge("(33.5833964, -101.871099)", "(33.5833284, -101.8710939)",
      8.264498572679495);
  graph.addEdge("(33.5833284, -101.8710939)", "(33.5832837, -101.8710786)",
      5.640132213584923);
  graph.addEdge("(33.5832837, -101.8710786)", "(33.5832518, -101.8710684)",
      4.005577767796449);
  graph.addEdge("(33.5832518, -101.8710684)", "(33.5831753, -101.871071)",
      9.283049746419735);
  graph.addEdge("(33.5831753, -101.871071)", "(33.5830648, -101.8710965)",
      13.651157057075388);
  graph.addEdge("(33.5830648, -101.8710965)", "(33.5829882, -101.8711016)",
      9.305841161177767);
  graph.addEdge("(33.5829882, -101.8711016)", "(33.5828959, -101.8710962)",
      11.209218582522727);
  graph.addEdge("(33.5851223, -101.8738726)", "(33.5850944, -101.8738949)",
      4.071647647492744);
  graph.addEdge("(33.5850944, -101.8738949)", "(33.5850645, -101.8739302)",
      5.098706183950571);
  graph.addEdge("(33.5850645, -101.8739302)", "(33.5850091, -101.8740062)",
      10.23174580889857);
  graph.addEdge("(33.5847046, -101.8710065)", "(33.5847033, -101.8713391)",
      33.766666882165524);
  graph.addEdge("(33.5842581, -101.8709086)", "(33.5842602, -101.8707651)",
      14.570743635674543);
  graph.addEdge("(33.58028, -101.8792428)", "(33.5806251, -101.8792438)",
      41.860040238563165);
  graph.addEdge("(33.5806251, -101.8792438)", "(33.5808245, -101.8792439)",
      24.186811289541858);
  graph.addEdge("(33.5823865, -101.8767453)", "(33.5824283, -101.8767458)",
      5.070509361971854);
  graph.addEdge("(33.5824283, -101.8767458)", "(33.5824717, -101.8767463)",
      5.264576788815826);
  graph.addEdge("(33.5843092, -101.8709703)", "(33.5843752, -101.8709709)",
      8.005900438830778);
  graph.addEdge("(33.5866866, -101.8749483)", "(33.586686, -101.874839)",
      11.096366305185851);
  graph.addEdge("(33.5836492, -101.8760976)", "(33.5836523, -101.8757771)",
      32.54044747650379);
  graph.addEdge("(33.5836523, -101.8757771)", "(33.5836543, -101.8755661)",
      21.422826949653814);
  graph.addEdge("(33.5836543, -101.8755661)", "(33.5836554, -101.8754998)",
      6.73232862792771);
  graph.addEdge("(33.5836554, -101.8754998)", "(33.5836567, -101.875427)",
      7.392590737294635);
  graph.addEdge("(33.5844783, -101.8781752)", "(33.5844851, -101.8781294)",
      4.722323018816657);
  graph.addEdge("(33.5844851, -101.8781294)", "(33.5844902, -101.8780589)",
      7.184020534163469);
  graph.addEdge("(33.5844902, -101.8780589)", "(33.5844987, -101.8779515)",
      10.952154068231826);
  graph.addEdge("(33.5844987, -101.8779515)", "(33.5845004, -101.8777909)",
      16.305814906812575);
  graph.addEdge("(33.5845004, -101.8777909)", "(33.5845004, -101.877772)",
      1.9187749357797301);
  graph.addEdge("(33.5845004, -101.877772)", "(33.5845004, -101.8776415)",
      13.248684079695991);
  graph.addEdge("(33.5844783, -101.8781752)", "(33.5844583, -101.8782687)",
      9.797453758158431);
  graph.addEdge("(33.5844583, -101.8782687)", "(33.5844473, -101.8783483)",
      8.190604156025552);
  graph.addEdge("(33.5844473, -101.8783483)", "(33.584439, -101.8785273)",
      18.200403199680185);
  graph.addEdge("(33.584439, -101.8785273)", "(33.5844362, -101.8786832)",
      15.83101025692005);
  graph.addEdge("(33.5844362, -101.8786832)", "(33.5844501, -101.878776)",
      9.570971457299907);
  graph.addEdge("(33.5844501, -101.878776)", "(33.5844722, -101.8788257)",
      5.71356812283736);
  graph.addEdge("(33.5844722, -101.8788257)", "(33.5845023, -101.8788703)",
      5.816547365882265);
  graph.addEdge("(33.5841498, -101.8788747)", "(33.5840141, -101.8788769)",
      16.46165462209476);
  graph.addEdge("(33.5840141, -101.8788769)", "(33.583991, -101.8788638)",
      3.101594187021655);
  graph.addEdge("(33.583991, -101.8788638)", "(33.583991, -101.8786972)",
      16.913745113953887);
  graph.addEdge("(33.583991, -101.8786972)", "(33.5839914, -101.87781)",
      90.0712893620178);
  graph.addEdge("(33.5839914, -101.87781)", "(33.5839917, -101.8772065)",
      61.26918914632623);
  graph.addEdge("(33.5840603, -101.875777)", "(33.5840603, -101.8755667)",
      21.350286640031875);
  graph.addEdge("(33.5839508, -101.875777)", "(33.5839508, -101.8755665)",
      21.37061823133493);
  graph.addEdge("(33.584109, -101.8761881)", "(33.5842032, -101.8761901)",
      11.428076184792447);
  graph.addEdge("(33.5842032, -101.8761901)", "(33.584245, -101.876191)",
      5.071079969969566);
  graph.addEdge("(33.5811194, -101.8805008)", "(33.5809945, -101.8805006)",
      15.150127080240159);
  graph.addEdge("(33.5809685, -101.8805933)", "(33.5809687, -101.8805)",
      9.472464636895745);
  graph.addEdge("(33.5806577, -101.8805893)", "(33.580693, -101.8805895)",
      4.281865378551729);
  graph.addEdge("(33.5857125, -101.8821775)", "(33.5857171, -101.8821037)",
      7.51300248554706);
  graph.addEdge("(33.5857171, -101.8821037)", "(33.5856993, -101.8820873)",
      2.7264956102947635);
  graph.addEdge("(33.5856993, -101.8820873)", "(33.5856803, -101.8820507)",
      4.3723778360059615);
  graph.addEdge("(33.5856803, -101.8820507)", "(33.585674, -101.8820217)",
      3.041671126437622);
  graph.addEdge("(33.585674, -101.8820217)", "(33.5856761, -101.881946)",
      7.6893681687001685);
  graph.addEdge("(33.5856761, -101.881946)", "(33.5856856, -101.8818678)",
      8.022144111056448);
  graph.addEdge("(33.5856856, -101.8818678)", "(33.5856877, -101.8818047)",
      6.4110434681562145);
  graph.addEdge("(33.5856877, -101.8818047)", "(33.5856824, -101.881734)",
      7.206274767193026);
  graph.addEdge("(33.5856824, -101.881734)", "(33.5856835, -101.8817012)",
      3.3325641664721237);
  graph.addEdge("(33.5856835, -101.8817012)", "(33.5856888, -101.8816419)",
      6.054429226440872);
  graph.addEdge("(33.5856888, -101.8816419)", "(33.5856888, -101.8816053)",
      3.715671954076716);
  graph.addEdge("(33.5856888, -101.8816053)", "(33.5856761, -101.8815524)",
      5.587038645029506);
  graph.addEdge("(33.5856761, -101.8815524)", "(33.5856446, -101.881483)",
      8.014935278918738);
  graph.addEdge("(33.5856446, -101.881483)", "(33.5856204, -101.8814552)",
      4.072094908253992);
  graph.addEdge("(33.5856204, -101.8814552)", "(33.5855794, -101.8814237)",
      5.912663451502795);
  graph.addEdge("(33.5855794, -101.8814237)", "(33.5855458, -101.8813972)",
      4.883483631200622);
  graph.addEdge("(33.5855458, -101.8813972)", "(33.5855257, -101.881371)",
      3.6082026057124157);
  graph.addEdge("(33.5855257, -101.881371)", "(33.5855101, -101.8813505)",
      2.812817927030211);
  graph.addEdge("(33.5855101, -101.8813505)", "(33.5854365, -101.8812079)",
      17.00831510411179);
  graph.addEdge("(33.5854365, -101.8812079)", "(33.5854365, -101.8811751)",
      3.32990149859393);
  graph.addEdge("(33.5854365, -101.8811751)", "(33.585405, -101.8810937)",
      9.104409731198615);
  graph.addEdge("(33.585405, -101.8810937)", "(33.5853798, -101.8810288)",
      7.263263130228107);
  graph.addEdge("(33.5853798, -101.8810288)", "(33.5853629, -101.8810124)",
      2.640891083977746);
  graph.addEdge("(33.5853629, -101.8810124)", "(33.5853482, -101.8809771)",
      4.002791936718041);
  graph.addEdge("(33.5853482, -101.8809771)", "(33.5853219, -101.8808862)",
      9.764148339947615);
  graph.addEdge("(33.5853219, -101.8808862)", "(33.5853158, -101.8808614)",
      2.624206965080213);
  graph.addEdge("(33.5853158, -101.8808614)", "(33.5853135, -101.8808522)",
      0.9747744840321452);
  graph.addEdge("(33.5853135, -101.8808522)", "(33.5852936, -101.88075)",
      10.652587200623307);
  graph.addEdge("(33.5852936, -101.88075)", "(33.5852789, -101.8806465)",
      10.65769915497261);
  graph.addEdge("(33.5852789, -101.8806465)", "(33.5852721, -101.8805073)",
      14.15585406445431);
  graph.addEdge("(33.5852721, -101.8805073)", "(33.5852715, -101.8804951)",
      1.2406996996342095);
  graph.addEdge("(33.5852715, -101.8804951)", "(33.5852536, -101.8804257)",
      7.372565159084642);
  graph.addEdge("(33.5852536, -101.8804257)", "(33.5852304, -101.8803424)",
      8.912680202991371);
  graph.addEdge("(33.5852304, -101.8803424)", "(33.5852232, -101.8803172)",
      2.7033058972291317);
  graph.addEdge("(33.5852232, -101.8803172)", "(33.5851958, -101.8802264)",
      9.799014066796195);
  graph.addEdge("(33.5851958, -101.8802264)", "(33.5851702, -101.8801758)",
      6.002598647723518);
  graph.addEdge("(33.5851702, -101.8801758)", "(33.5851311, -101.8800996)",
      9.07406785603135);
  graph.addEdge("(33.5851311, -101.8800996)", "(33.5850518, -101.8800359)",
      11.590736314436338);
  graph.addEdge("(33.5850518, -101.8800359)", "(33.5850392, -101.8800286)",
      1.6985619160961705);
  graph.addEdge("(33.5850392, -101.8800286)", "(33.5849646, -101.8799917)",
      9.793623954444012);
  graph.addEdge("(33.5849646, -101.8799917)", "(33.58489, -101.8799715)",
      9.278303720409093);
  graph.addEdge("(33.58489, -101.8799715)", "(33.5849236, -101.8797583)",
      22.02486456134743);
  graph.addEdge("(33.5857171, -101.8821037)", "(33.585824, -101.8821261)",
      13.164659863921441);
  graph.addEdge("(33.585824, -101.8821261)", "(33.5858534, -101.8821261)",
      3.5661623761104653);
  graph.addEdge("(33.5858534, -101.8821261)", "(33.5858792, -101.8821217)",
      3.1612082885569848);
  graph.addEdge("(33.5858792, -101.8821217)", "(33.5859243, -101.8821084)",
      5.634708470029809);
  graph.addEdge("(33.5859243, -101.8821084)", "(33.5859473, -101.8821051)",
      2.8098982584644454);
  graph.addEdge("(33.5859473, -101.8821051)", "(33.5860835, -101.882125)",
      16.64386005796409);
  graph.addEdge("(33.5860835, -101.882125)", "(33.5861056, -101.8821361)",
      2.9079094924680557);
  graph.addEdge("(33.5861056, -101.8821361)", "(33.586123, -101.8821515)",
      2.6265655086016046);
  graph.addEdge("(33.586123, -101.8821515)", "(33.5861424, -101.8821802)",
      3.7452324852555905);
  graph.addEdge("(33.5861424, -101.8821802)", "(33.5861543, -101.8821957)",
      2.135335239618936);
  graph.addEdge("(33.5861543, -101.8821957)", "(33.5861727, -101.8822023)",
      2.3302905505497655);
  graph.addEdge("(33.5861727, -101.8822023)", "(33.5862795, -101.8822266)",
      13.187429833748038);
  graph.addEdge("(33.5862795, -101.8822266)", "(33.5862993, -101.8822363)",
      2.5957460616126817);
  graph.addEdge("(33.5862993, -101.8822363)", "(33.5863291, -101.8822509)",
      3.9067676793213786);
  graph.addEdge("(33.5863291, -101.8822509)", "(33.5863871, -101.8822609)",
      7.108157231031662);
  graph.addEdge("(33.5863871, -101.8822609)", "(33.5864964, -101.8822683)",
      13.279144558912432);
  graph.addEdge("(33.5864964, -101.8822683)", "(33.5865813, -101.8822741)",
      10.315024299450437);
  graph.addEdge("(33.5865813, -101.8822741)", "(33.5866705, -101.8822719)",
      10.822091456403195);
  graph.addEdge("(33.5866705, -101.8822719)", "(33.586692, -101.8822698)",
      2.6166077337112377);
  graph.addEdge("(33.586692, -101.8822698)", "(33.5868509, -101.8822542)",
      19.339216378895845);
  graph.addEdge("(33.5868509, -101.8822542)", "(33.5869465, -101.8822377)",
      11.716453616260473);
  graph.addEdge("(33.5869465, -101.8822377)", "(33.5870275, -101.8822211)",
      9.96862173075553);
  graph.addEdge("(33.5870275, -101.8822211)", "(33.5870459, -101.882209)",
      2.547594995552688);
  graph.addEdge("(33.5870459, -101.882209)", "(33.5870588, -101.8821935)",
      2.2191199642860453);
  graph.addEdge("(33.5870588, -101.8821935)", "(33.5871163, -101.8821764)",
      7.1874349337111605);
  graph.addEdge("(33.5871163, -101.8821764)", "(33.5871849, -101.8821559)",
      8.577354043391066);
  graph.addEdge("(33.5871849, -101.8821559)", "(33.5871987, -101.8821626)",
      1.8068287083892653);
  graph.addEdge("(33.5871987, -101.8821626)", "(33.5872161, -101.8821626)",
      2.110586363512432);
  graph.addEdge("(33.5872161, -101.8821626)", "(33.5872594, -101.8821482)",
      5.45185815726225);
  graph.addEdge("(33.5872594, -101.8821482)", "(33.5872751, -101.8821417)",
      2.0154644718370722);
  graph.addEdge("(33.5872751, -101.8821417)", "(33.5873256, -101.8821206)",
      6.489282979845419);
  graph.addEdge("(33.5873256, -101.8821206)", "(33.5873845, -101.8820963)",
      7.558367953847514);
  graph.addEdge("(33.5873845, -101.8820963)", "(33.5874903, -101.8820422)",
      13.959174610630061);
  graph.addEdge("(33.5874903, -101.8820422)", "(33.5876136, -101.8819715)",
      16.58910451738596);
  graph.addEdge("(33.5876136, -101.8819715)", "(33.5877553, -101.8818743)",
      19.819060889217027);
  graph.addEdge("(33.5877553, -101.8818743)", "(33.5878367, -101.8818607)",
      9.969725978201277);
  graph.addEdge("(33.5878367, -101.8818607)", "(33.5879016, -101.8817506)",
      13.671205035143712);
  graph.addEdge("(33.5879016, -101.8817506)", "(33.5879559, -101.881692)",
      8.875369565245471);
  graph.addEdge("(33.5879559, -101.881692)", "(33.5879872, -101.8816479)",
      5.870058773301972);
  graph.addEdge("(33.5879872, -101.8816479)", "(33.5880718, -101.8815175)",
      16.7496077753536);
  graph.addEdge("(33.5880718, -101.8815175)", "(33.5881298, -101.8814358)",
      10.87595647071781);
  graph.addEdge("(33.5881298, -101.8814358)", "(33.5882375, -101.8812856)",
      20.078978136047972);
  graph.addEdge("(33.5882375, -101.8812856)", "(33.5882503, -101.8812591)",
      3.1061150003347597);
  graph.addEdge("(33.5882503, -101.8812591)", "(33.5882522, -101.8812204)",
      3.9355040516504602);
  graph.addEdge("(33.5882522, -101.8812204)", "(33.5883203, -101.8811282)",
      12.48371475826748);
  graph.addEdge("(33.5883203, -101.8811282)", "(33.5883819, -101.8810448)",
      11.29218842281913);
  graph.addEdge("(33.5849759, -101.875775)", "(33.584975, -101.8756592)",
      11.756746008382574);
  graph.addEdge("(33.584975, -101.8756592)", "(33.5849737, -101.875504)",
      15.756992321824011);
  graph.addEdge("(33.5849737, -101.875504)", "(33.5849727, -101.8753957)",
      10.99549406199323);
  graph.addEdge("(33.5849737, -101.875504)", "(33.5848735, -101.8755039)",
      12.154066047866094);
  graph.addEdge("(33.5848727, -101.8756582)", "(33.5848722, -101.8757666)",
      11.005157085988383);
  graph.addEdge("(33.58475, -101.8756571)", "(33.5848727, -101.8756582)",
      14.883685994454652);
  graph.addEdge("(33.5848727, -101.8756582)", "(33.584975, -101.8756592)",
      12.409202948369646);
  graph.addEdge("(33.584975, -101.8756592)", "(33.5851366, -101.8756561)",
      19.60428710674077);
  graph.addEdge("(33.5852617, -101.8757877)", "(33.5852599, -101.8761769)",
      39.51280718314479);
  graph.addEdge("(33.5852599, -101.8761769)", "(33.5851077, -101.8763682)",
      26.795675657812303);
  graph.addEdge("(33.5851077, -101.8763682)", "(33.5851077, -101.8767465)",
      38.405686410751485);
  graph.addEdge("(33.5846577, -101.8757619)", "(33.58475, -101.8757628)",
      11.196179869774026);
  graph.addEdge("(33.58475, -101.8757628)", "(33.5848722, -101.8757666)",
      14.82763751954242);
  graph.addEdge("(33.5848722, -101.8757666)", "(33.5849759, -101.875775)",
      12.607479631791495);
  graph.addEdge("(33.5849759, -101.875775)", "(33.5852132, -101.8757351)",
      29.067648969616652);
  graph.addEdge("(33.5852132, -101.8757351)", "(33.5852617, -101.8757877)",
      7.945133709042894);
  graph.addEdge("(33.5851366, -101.8756561)", "(33.5852617, -101.8757877)",
      20.21776982411849);
  graph.addEdge("(33.5852617, -101.8757877)", "(33.5855331, -101.8757908)",
      32.92179001208035);
  graph.addEdge("(33.5855331, -101.8757908)", "(33.58558, -101.8758873)",
      11.328752215629585);
  graph.addEdge("(33.58558, -101.8758873)", "(33.5858012, -101.8759021)",
      26.87316235207013);
  graph.addEdge("(33.5858012, -101.8759021)", "(33.5858034, -101.8760477)",
      14.783860220627467);
  graph.addEdge("(33.5858087, -101.8757772)", "(33.5858695, -101.8757823)",
      7.393073059336052);
  graph.addEdge("(33.5860805, -101.8757846)", "(33.5858695, -101.8757823)",
      25.594952107646392);
  graph.addEdge("(33.5860805, -101.8757846)", "(33.5861938, -101.8757865)",
      13.744422164626291);
  graph.addEdge("(33.5860939, -101.8763695)", "(33.5860805, -101.8763347)",
      3.88888324033383);
  graph.addEdge("(33.5860805, -101.8763347)", "(33.5860805, -101.8757846)",
      55.84650016277864);
  graph.addEdge("(33.5860805, -101.8757846)", "(33.5860805, -101.8755166)",
      27.207529620061365);
  graph.addEdge("(33.5860805, -101.8755166)", "(33.5860827, -101.8753235)",
      19.605450177190715);
  graph.addEdge("(33.5860827, -101.8753235)", "(33.5860776, -101.8751407)",
      18.568279590191917);
  graph.addEdge("(33.5860776, -101.8751407)", "(33.586076, -101.8750278)",
      11.463322947399146);
  graph.addEdge("(33.5860766, -101.8750211)", "(33.5860793, -101.8749495)",
      7.2762517746876005);
  graph.addEdge("(33.5860793, -101.8749495)", "(33.5861006, -101.8748434)",
      11.076866011849264);
  graph.addEdge("(33.5860827, -101.8753235)", "(33.5862612, -101.8753018)",
      21.76348681757628);
  graph.addEdge("(33.5862612, -101.8753018)", "(33.5864245, -101.8751559)",
      24.73349178360547);
  graph.addEdge("(33.5864245, -101.8751559)", "(33.5865816, -101.8750211)",
      23.46071466244084);
  graph.addEdge("(33.5865816, -101.8750211)", "(33.5866866, -101.8749483)",
      14.72531871466752);
  graph.addEdge("(33.5865816, -101.8750211)", "(33.5866844, -101.8750285)",
      12.492049882353102);
  graph.addEdge("(33.5866844, -101.8750285)", "(33.5868045, -101.8750309)",
      14.569934099271508);
  graph.addEdge("(33.5851427, -101.8750749)", "(33.5851372, -101.8753257)",
      25.470389586222566);
  graph.addEdge("(33.5851372, -101.8753257)", "(33.5851366, -101.8755024)",
      17.939038732161134);
  graph.addEdge("(33.5851366, -101.8755024)", "(33.5851366, -101.8756561)",
      15.60389118020873);
  graph.addEdge("(33.5850153, -101.875325)", "(33.5850001, -101.8753671)",
      4.65478546069244);
  graph.addEdge("(33.5850001, -101.8753671)", "(33.5849727, -101.8753957)",
      4.413225287866931);
  graph.addEdge("(33.5849727, -101.8753957)", "(33.5848735, -101.8755039)",
      16.292654176959328);
  graph.addEdge("(33.5848735, -101.8755039)", "(33.5847901, -101.8754896)",
      10.219894197504988);
  graph.addEdge("(33.5847901, -101.8754896)", "(33.58475, -101.8755096)",
      5.27083371700176);
  graph.addEdge("(33.58475, -101.8755096)", "(33.5846565, -101.8756253)",
      16.3278283173213);
  graph.addEdge("(33.5858704, -101.875236)", "(33.5858058, -101.8751413)",
      12.402829792002272);
  graph.addEdge("(33.5858058, -101.8751413)", "(33.5858019, -101.8750262)",
      11.694634034141002);
  graph.addEdge("(33.5858019, -101.8750262)", "(33.5858012, -101.8749614)",
      6.579106110330716);
  graph.addEdge("(33.5858012, -101.8749614)", "(33.5857993, -101.8748421)",
      12.113643210277047);
  graph.addEdge("(33.5858704, -101.875236)", "(33.5858695, -101.8757823)",
      55.460963906891884);
  graph.addEdge("(33.5858087, -101.8757772)", "(33.5858697, -101.8758826)",
      13.009396122122203);
  graph.addEdge("(33.5858695, -101.8757823)", "(33.5858697, -101.8758826)",
      10.182573152710503);
  graph.addEdge("(33.5858704, -101.8762086)", "(33.5858697, -101.8758826)",
      33.095915593481834);
  graph.addEdge("(33.5855685, -101.8751387)", "(33.5855714, -101.8750249)",
      11.558470010654705);
  graph.addEdge("(33.5855714, -101.8750249)", "(33.5855749, -101.8749397)",
      8.660021066865736);
  graph.addEdge("(33.5854805, -101.875024)", "(33.5854798, -101.8751141)",
      9.147466451555783);
  graph.addEdge("(33.5854805, -101.875024)", "(33.5854811, -101.874941)",
      8.42658511723797);
  graph.addEdge("(33.5853002, -101.8749453)", "(33.5852998, -101.8748223)",
      12.487244536645587);
  graph.addEdge("(33.5853016, -101.8745492)", "(33.5853498, -101.8745373)",
      5.970078981520417);
  graph.addEdge("(33.5853498, -101.8745373)", "(33.5855753, -101.8745351)",
      27.353618204777867);
  graph.addEdge("(33.5854407, -101.8746812)", "(33.5853016, -101.8745492)",
      21.54682063448755);
  graph.addEdge("(33.5855749, -101.8748304)", "(33.5854407, -101.8746812)",
      22.235346315456972);
  graph.addEdge("(33.5854407, -101.8746812)", "(33.5852998, -101.8748223)",
      22.300112709408477);
  graph.addEdge("(33.5853016, -101.8745492)", "(33.5853059, -101.874434)",
      11.706906571027636);
  graph.addEdge("(33.5853059, -101.874434)", "(33.5852711, -101.874432)",
      4.226051897025484);
  graph.addEdge("(33.5852711, -101.874432)", "(33.5852309, -101.8744119)",
      5.285936315057925);
  graph.addEdge("(33.5852309, -101.8744119)", "(33.5851957, -101.8743817)",
      5.25645605027183);
  graph.addEdge("(33.5851957, -101.8743817)", "(33.5851739, -101.8743458)",
      4.502846056287561);
  graph.addEdge("(33.5851739, -101.8743458)", "(33.5851398, -101.8742801)",
      7.848392046051321);
  graph.addEdge("(33.5854398, -101.8743438)", "(33.5853681, -101.8743443)",
      8.697216989771254);
  graph.addEdge("(33.5853681, -101.8743443)", "(33.5851739, -101.8743458)",
      23.55656942876803);
  graph.addEdge("(33.5852086, -101.8741974)", "(33.5851219, -101.8740943)",
      14.837564839051959);
  graph.addEdge("(33.5842473, -101.8768172)", "(33.5842418, -101.8769072)",
      9.1613735752108);
  graph.addEdge("(33.5854577, -101.873175)", "(33.5855139, -101.8732425)",
      9.665927606710065);
  graph.addEdge("(33.5861025, -101.8745314)", "(33.5861, -101.874444)",
      8.878081615109297);
  graph.addEdge("(33.5855753, -101.8745351)", "(33.5855761, -101.8744296)",
      10.710928723322297);
  graph.addEdge("(33.5828492, -101.8755642)", "(33.5829242, -101.8755672)",
      9.1024456783864);
  graph.addEdge("(33.5829926, -101.875565)", "(33.5829242, -101.8755672)",
      8.299787916306107);
  graph.addEdge("(33.5829926, -101.875565)", "(33.5830789, -101.8755656)",
      10.468193337896247);
  graph.addEdge("(33.5830789, -101.8755656)", "(33.5833516, -101.8755777)",
      33.100764345504665);
  graph.addEdge("(33.5833516, -101.8755777)", "(33.5834214, -101.8756387)",
      10.489802453145614);
  graph.addEdge("(33.5834214, -101.8756387)", "(33.5835659, -101.8756401)",
      17.528136407982807);
  graph.addEdge("(33.5835659, -101.8756401)", "(33.5836543, -101.8755661)",
      13.092688448462251);
  graph.addEdge("(33.5819678, -101.8755591)", "(33.5817326, -101.8755631)",
      28.532170795735468);
  graph.addEdge("(33.5817326, -101.8755631)", "(33.5814903, -101.8755577)",
      29.395607874432997);
  graph.addEdge("(33.5868075, -101.8755364)", "(33.5866844, -101.8755407)",
      14.938170675592158);
  graph.addEdge("(33.5866844, -101.8755407)", "(33.5866806, -101.8752714)",
      27.343201895099103);
  graph.addEdge("(33.5868982, -101.8768255)", "(33.5868404, -101.8768376)",
      7.117826228865747);
  graph.addEdge("(33.5868404, -101.8768376)", "(33.5867603, -101.8768335)",
      9.724886075797517);
  graph.addEdge("(33.5867603, -101.8768335)", "(33.5866737, -101.8768416)",
      10.536548862844343);
  graph.addEdge("(33.5866737, -101.8768416)", "(33.5864627, -101.8768256)",
      25.645381585485715);
  graph.addEdge("(33.5864627, -101.8768256)", "(33.5863508, -101.8768666)",
      14.197118060346812);
  graph.addEdge("(33.5870707, -101.8759835)", "(33.5870692, -101.8760083)",
      2.524248842382409);
  graph.addEdge("(33.5870692, -101.8760083)", "(33.5871501, -101.876008)",
      9.813060717248135);
  graph.addEdge("(33.5836492, -101.8760976)", "(33.5835757, -101.8760968)",
      8.915772671121239);
  graph.addEdge("(33.5835757, -101.8760968)", "(33.5835746, -101.8761625)",
      6.671432748853669);
  graph.addEdge("(33.5835952, -101.8746826)", "(33.5832244, -101.874684)",
      44.97752013348053);
  graph.addEdge("(33.5832244, -101.874684)", "(33.5832222, -101.8747591)",
      7.629119357894846);
  graph.addEdge("(33.5832222, -101.8747591)", "(33.5831094, -101.8747605)",
      13.683151221450851);
  graph.addEdge("(33.5831094, -101.8747605)", "(33.5831082, -101.8746907)",
      7.087877840082946);
  graph.addEdge("(33.5832244, -101.874684)", "(33.5832233, -101.8746116)",
      7.35154696044239);
  graph.addEdge("(33.5832233, -101.8746116)", "(33.5831116, -101.8746197)",
      13.573918048386297);
  graph.addEdge("(33.5831116, -101.8746197)", "(33.5831082, -101.8746907)",
      7.220000268805422);
  graph.addEdge("(33.5831082, -101.8746907)", "(33.5829226, -101.8746801)",
      22.538612360769353);
  graph.addEdge("(33.5814903, -101.8755577)", "(33.5815731, -101.8754335)",
      16.120527433281893);
  graph.addEdge("(33.5871501, -101.876008)", "(33.5871496, -101.8760841)",
      7.725862914581525);
  graph.addEdge("(33.5871496, -101.8760841)", "(33.5871474, -101.8764743)",
      39.61376174400991);
  graph.addEdge("(33.587415, -101.8760846)", "(33.5871496, -101.8760841)",
      32.19254735941291);
  graph.addEdge("(33.587415, -101.8760846)", "(33.5874161, -101.8761959)",
      11.299860199988133);
  graph.addEdge("(33.5874161, -101.8761959)", "(33.5876474, -101.8761946)",
      28.05655474441737);
  graph.addEdge("(33.5876474, -101.8761946)", "(33.5879428, -101.8761916)",
      35.832746656660696);
  graph.addEdge("(33.5876411, -101.8760025)", "(33.5876474, -101.8761946)",
      19.516728210668642);
  graph.addEdge("(33.5876411, -101.8760025)", "(33.5879439, -101.8760066)",
      36.73141646630521);
  graph.addEdge("(33.5879748, -101.8760786)", "(33.5879442, -101.8760788)",
      3.7117768304907712);
  graph.addEdge("(33.5879428, -101.8761916)", "(33.5879442, -101.8760788)",
      11.452540364802422);
  graph.addEdge("(33.5879442, -101.8760788)", "(33.5879439, -101.8760066)",
      7.329722449932426);
  graph.addEdge("(33.5871474, -101.8764743)", "(33.5874066, -101.8764605)",
      31.471656843483068);
  graph.addEdge("(33.5874066, -101.8764605)", "(33.5874161, -101.8761959)",
      26.88665222508884);
  graph.addEdge("(33.5859193, -101.8768335)", "(33.5858781, -101.8769165)",
      9.796742047060611);
  graph.addEdge("(33.584654, -101.875627)", "(33.584286, -101.875623)",
      44.63951599538875);
  graph.addEdge("(33.584286, -101.875623)", "(33.5841965, -101.8755679)",
      12.212626457312748);
  graph.addEdge("(33.584286, -101.875623)", "(33.5842444, -101.8757784)",
      16.563947407283916);
  graph.addEdge("(33.5841965, -101.8755679)", "(33.5840603, -101.8755667)",
      16.521237661244015);
  graph.addEdge("(33.5840603, -101.8755667)", "(33.5839508, -101.8755665)",
      13.282146960952621);
  graph.addEdge("(33.5839508, -101.8755665)", "(33.5836543, -101.8755661)",
      35.9648799377696);
  graph.addEdge("(33.5834214, -101.8756387)", "(33.5832295, -101.8757816)",
      27.428046670539004);
  graph.addEdge("(33.5829275, -101.873945)", "(33.5831691, -101.8739377)",
      29.314963129140214);
  graph.addEdge("(33.5831691, -101.873805)", "(33.5831691, -101.8739377)",
      13.472240426362983);
  graph.addEdge("(33.5832409, -101.8739306)", "(33.5831691, -101.8739377)",
      8.738974158980088);
  graph.addEdge("(33.5831691, -101.873805)", "(33.5829283, -101.8738021)",
      29.210038675187906);
  graph.addEdge("(33.5829283, -101.8738021)", "(33.5829275, -101.873945)",
      14.5081505483945);
  graph.addEdge("(33.5829321, -101.8738049)", "(33.5827873, -101.873788)",
      17.64755225012983);
  graph.addEdge("(33.5827873, -101.873788)", "(33.5822777, -101.8737944)",
      61.816863023265256);
  graph.addEdge("(33.5835979, -101.8737984)", "(33.5835944, -101.8736298)",
      17.122133309709017);
  graph.addEdge("(33.5822777, -101.8737944)", "(33.5820868, -101.8737671)",
      23.321068221790114);
  graph.addEdge("(33.5822785, -101.8739383)", "(33.5822777, -101.8737944)",
      14.609782114618312);
  graph.addEdge("(33.5822785, -101.8739383)", "(33.5820887, -101.8739249)",
      23.062514856003617);
  graph.addEdge("(33.5821538, -101.8756239)", "(33.5819678, -101.8755591)",
      23.50104060185272);

  //graph.bfs("(33.5853681, -101.8743443)");
  origin = graph.findClosestVertex(
      origin); //If using the users location, autosnaps to closest node in graph
  print("ClosesstVertex");
  print(origin);
  destination = graph.findClosestVertex(destination);
  final result = graph.dijkstraPath(origin, destination);
  print('Shortest distances: ${result['distances']}');
  print('Shortest path: ${result['shortestPath']}');
  //result['shortestPath'].remove(0); //remove empty string
  return result['shortestPath'];
  //TODO map sequence of nodes to in more detail sequence of nodes

  //graph.printGraph();
}
