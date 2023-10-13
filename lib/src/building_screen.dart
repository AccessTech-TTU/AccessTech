import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'contact_screen.dart';
import 'map_screen.dart';

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
    );
  }
} // End of building screen