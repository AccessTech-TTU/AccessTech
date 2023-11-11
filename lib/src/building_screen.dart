// import 'package:flutter/material.dart';
// import "buildingData.dart";
//
// /*
// Authors:
//   Thinh Pham, Travis Libre
// Description:
//   This file is the buildings screen. It currently lists the buildings,
//   and a description of them. Currently, much of it is unused and must
//   be implemented.
// */
//
// class BuildingInfo {
//   final String name;
//   final String description;
//   final String hours;
//   final String address;
//   final String imageUrl;
//
//   BuildingInfo({
//     required this.name,
//     required this.description,
//     required this.hours;
//     required this.address;
//     required this.imageUrl,
//   });
// }
//
// class BuildingCard extends StatelessWidget {
//   final BuildingInfo building;
//
//   const BuildingCard({Key? key, required this.building}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Text(
//               building.name,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//             child: Text(
//               building.description,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ], // Children (list)
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'buildingData.dart';

class BuildingInfo {
  final String name;
  final String description;
  final String hours;
  final String address;
  final String imageUrl;

  BuildingInfo({
    required this.name,
    required this.description,
    required this.hours,
    required this.address,
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
              'Description: ${building.description}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              'Hours: ${building.hours}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              'Address: ${building.address}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
// Start of BuildingScreenUI
class BuildingScreen extends StatelessWidget {
  const BuildingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulated building data

    // Step 2: Sort the Building List
    final sortedBuildings = buildingData
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: Text('Buildings'),
        elevation: 5,
        // Search button on the app bar which shows the search text field when tapped
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),

      // Step 2: Use list view to show the sorted list of buildings
      body: ListView.builder(
        itemCount: sortedBuildings.length, // Update itemCount
        itemBuilder: (context, index) {
          final building = sortedBuildings[index]; // Use the sorted list
          return BuildingCard(building: building);
        },
      ),
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
    // Building suggestions list of buildings that has names contain search query
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
