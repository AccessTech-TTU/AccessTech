import 'package:flutter/material.dart';

/*
Authors:
  Thinh Pham, Travis Libre
Description:
  This file is the buildings screen. It currently lists the buildings,
  and a description of them. Currently, much of it is unused and must
  be implemented.
*/

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
// Make building list separate from classes
final List<BuildingInfo> buildingData = [
      BuildingInfo(
        name: 'Human Sciences Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Administration Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Industrial Engineering Bldg',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Electrical Engineering Bldg',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Chemistry Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Math Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agricultural Science Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Science Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Civil Engineering Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Student Union Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Music Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Holden Hall Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'National Wind Institute',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Petroleum Engineering Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Development Office Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agricultural Pavilion Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'McClellan Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Merket Center Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Doak Hall Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Drane Hall Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Horn Hall Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Knapp Hall Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Human Science Cottage Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'West Hall Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Sneed Hall Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Bledsoe Hall Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Gordon Hall Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Jones Stadium Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Ticket Office Stadium Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Animal Science CASNR Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Educational TV Station Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agriculture Education Communication Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Fuller Petroleum Engineering Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Creative Movement Studio',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Library Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Engineering Center Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Chemical Engineering Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agricultural Plant Science Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Engineering Tech Labs Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Fisheries Wildlife Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Exercise Sports Science Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Wall Hall Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'West Hall Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Psychology Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Maedgen Theatre Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Stangel Hall Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Murdough Hall Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Hulen Hall Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Clement Hall Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Art 3D Annex Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Foreign Language Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Museum Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Media and Communication Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      // -----------------------------------------------------------------
      BuildingInfo(
        name: 'Wind Engineering Research Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Chitwood Hall Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Coleman Hall Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Weymouth Hall Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Wiggins Facilities Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Biology Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Architecture Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'CHACP I Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Law Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Physical Plant Annex Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Track Dressing Room Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agricultural Engineering Lab',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'University Greenhouse Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Goddard Range Wildlife Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Rec Aquatic Facilities Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'CHACP II Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Food Tech Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Devit Mallet Ranch Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Art Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'TTU Warehouse Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Livestock Arena Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Student Rec Center Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Chemical Storage Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Reese Wind Science Engineering',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'KTTZ Transmitter Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Range & Wildlife Field Annex',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Entomology Erskine Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Grantham Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Fiber and Polymer Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Robert Nash Interpretive Center',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Lubbock Lake Landmark Crew Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Athletic Train Center Bubble Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Housing Services Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Creative Movement Studio',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Mechanical Engineering Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Wind Engineering Research Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Lbb Lake Landmark Research Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Skyview Observatory Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Dan Law Field Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'West Locker Rooms DLF',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'International Cultural Center Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Lbb Lake Landmark Prefab Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Southwest Collections Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Athletic Services Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Admin Support Center Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'United Spirit Arena Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Carpenter Wells Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Education Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'English Philosophy Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'TTU Police Dept Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Animal Food Science Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Burkhart Center Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'University Parking Shop',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Experimental Science Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      //----------------------------------------------------------------
      BuildingInfo(
        name: 'Garst Pavilion Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Texas Tech Plaza Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Flint Garage',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Baseball Clubhouse',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Rawls Turf Care Center',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Plant & Soil Science Fld Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Football Training Facility Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Marsha Sharp Center Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Student Wellness Center Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Rawls Course Cart Barn',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'EQC Arena Building',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'EQC Stall Barn',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Murray Hall Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Rawls College of Business Building',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Lanier Law Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Center Addiction Recovery Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Library Storage Facility',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Reese',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Livermore Center Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'TTU Downtown Center Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'EQC Therapeutic Riding Center Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Rawls Golf Course Clubhouse',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Boston Residence Hall Dinning',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'J.T & Margaret Talkington Hall',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'East Loop Research Building',
        description: "Yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'GIS Lab Building',
        description: "Smarter yeehaw people.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Communication Services Building',
        description: "whuuut.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Inst For Envirnmtl Human Health',
        description: "building buildings.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Fredericksburg Building',
        description: "Picasso.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Pantex Residence 2 Building',
        description: "what.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Pantex Barn',
        description: "Bio stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Reese TIEHH Building',
        description: "Bio place stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Feedmill',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'New Deal Research Center',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Agronomy/Horticulture Building',
        description: "The Rawls.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Beef Cattle Center Building',
        description: "Admin stuff.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'New Deal Sow Boar Building',
        description: 'Academic hub housing classrooms and offices.',
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Junction Dining Hall Building',
        description: "It's West Hall.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Junction Academic Building',
        description: "Campus gathering spot with dining and services.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Junction Administration Building',
        description: "North of Mechanical Engineering South.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Junction Maintenance Building',
        description: "South of Mechanical Engineering North.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'Forensic Sciences Building',
        description: "A building no one can find.",
        imageUrl: 'assets/sub.jpg',
      ),
      BuildingInfo(
        name: 'TTUHSC Lbk Building',
        description: "Admin stuff.",
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
