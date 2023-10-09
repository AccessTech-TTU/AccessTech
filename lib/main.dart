import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

//TODO Change API key before publication
void main() {
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}

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

//Geting the markers from assets/locations.json, Converted to an object by lib/src/locations.dart, lib/src/locations.g.dart
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
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 182, 8,
            8), //TODO change color to accessable not color blind color
      ),
      home: Scaffold(
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.red,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Buildings",
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: "Contact",
              icon: Icon(Icons.call),
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuildingScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
  //End of MapScreenUI
}

class BuildingInfo {
  final String name;
  final String description;
  final String imageUrl;

  BuildingInfo({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class BuildingCard extends StatelessWidget {
  final BuildingInfo building;

  const BuildingCard({Key? key, required this.building}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Limit the height of the image here
            height: 100, // Adjust this value as needed
            child: Image.asset(
              building.imageUrl,
              fit: BoxFit.cover, // Control how the image scales
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              building.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              building.description,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ], // Children (list)
      ),
    );
  }
}

//Start of BuildingScreenUI
class BuildingScreen extends StatelessWidget {
  const BuildingScreen({Key? key}) : super(key: key);
  //TODO stateful

  @override
  Widget build(BuildContext context) {
    // Simulated building data
    final List<BuildingInfo> buildingData = [
      BuildingInfo(
        name: 'Holden Hall',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Student Union Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      // Add more building info...
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Buildings'),
        elevation: 2,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: buildingData.length,
        itemBuilder: (context, index) {
          final building = buildingData[index];
          return BuildingCard(building: building);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // BuildingScreen is at index 1
        fixedColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Buildings',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Contact',
            icon: Icon(Icons.call),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            );
          }
        },
      ),
    );
  }
}

/* OLD BUILDING SCREEN CODE \\ TODO DELETE
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 182, 8,
            8), //TODO change color to accessible not color blind color
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AccessTech'),
          elevation: 2,
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.red,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Buildings",
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: "Contact",
              icon: Icon(Icons.call),
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuildingScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
*/
//Start of contact screen
class ContactScreen extends StatelessWidget {
  //TODO stateful
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 182, 8,
            8), //TODO change color to accessable not color blind color
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AccessTech'),
          elevation: 2,
        ),
        body: const Text(
          "This is where contact info goes",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.red,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Buildings",
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: "Contact",
              icon: Icon(Icons.call),
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuildingScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
