import 'package:flutter/material.dart';

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
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   // Limit the height of the image here
          //   height: 100, // Adjust this value as needed
          //   child: Image.asset(
          //     building.imageUrl,
          //     fit: BoxFit.cover, // Control how the image scales
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              building.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              building.description,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ], // Children (list)
      ),
    );
  }
}
// Make builing list separate from classes
final List<BuildingInfo> buildingData = [
      BuildingInfo(
        name: 'Holden Hall',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'West Hall',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Student Union Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Mechanical Engineering North',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Mechanical Engineering South',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Livermore Center',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      // Add more building info...
    ];

//Start of BuildingScreenUI
class BuildingScreen extends StatelessWidget {
  const BuildingScreen({Key? key}) : super(key: key);
  //TODO stateful

  @override
  Widget build(BuildContext context) {
    // Simulated building data

    return Scaffold(
      appBar: AppBar(
        title: Text('Buildings'),
        elevation: 5,
        // Search button on app bar which show search text field when tapped
        actions: [
          IconButton(onPressed: () {
            showSearch(context: context, delegate: MySearchDelegate(),);
          }, icon: Icon(Icons.search))
        ],
      ),
      // body: GridView.builder(
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //   ),
      //   itemCount: buildingData.length,
      //   itemBuilder: (context, index) {
      //     final building = buildingData[index];
      //     return BuildingCard(building: building);
      //   },
      // ),

      // Use list view to show list of building
      body: ListView.builder(itemCount: buildingData.length, itemBuilder: (context, index) {
        final building = buildingData[index];
        return BuildingCard(building: building);
      },),
    );
  }
}

// Implementation of search function
class MySearchDelegate extends SearchDelegate {

  // Clear button
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () {query = '';}, icon: Icon(Icons.clear))];

  // Back button
  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));

  // Show result
  @override
  Widget buildResults(BuildContext context) {
    // Build results list of buildings that has names contain search query
    List<BuildingInfo> searchResults = buildingData.where((element) {
      final result = element.name.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    // return results as list view
    return ListView.builder(itemCount: searchResults.length, itemBuilder: (context, index) {
      final result = searchResults[index];
      return BuildingCard(building: result);
    });
  }

  // Show suggestion
  @override
  Widget buildSuggestions(BuildContext context) {
    // Building suggestions list of builings that has names contain search query
    List<BuildingInfo> suggestions= buildingData.where((searchResult) {
      final result = searchResult.name.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    // Return suggestions list
    return ListView.builder(itemCount: suggestions.length, itemBuilder: (context, index) {
      final suggestion = suggestions[index];
      return ListTile(title: Text(suggestion.name), onTap: () {
        query = suggestion.name;
        showResults(context);
      },);
    },);
  }

} // End of building screen