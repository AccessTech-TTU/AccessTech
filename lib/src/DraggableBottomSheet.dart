import 'package:flutter/material.dart';
import 'buildingData.dart';
import 'building_screen.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({Key? key});

  @override
  _MyDraggableSheetState createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  String searchQuery = '';

  void _removeFromFavorites(BuildingInfo building) {
    setState(() {
      favoriteBuildings.remove(building);
    });
  }

  void _updateFavorites() {
    setState(() {
      // This empty function body is used to trigger a rebuild
    });
  }

  void _addToFavorites(BuildingInfo building) {
    // Check if the building is not already in the favorites list
    if (!favoriteBuildings.contains(building)) {
      // Add the building to the favorites list
      favoriteBuildings.add(building);
      // Notify the UI that the list has changed
      _updateFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: DraggableScrollableSheet(
            key: _sheet,
            initialChildSize: 0.5,
            maxChildSize: .94,
            minChildSize: 0.2,
            snap: true,
            snapSizes: [0.2, 0.5, .94],
            controller: _controller,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Divider(
                            thickness: 5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onVerticalDragDown: (_) {
                        _expand();
                      },
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Favorites",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: favoriteBuildings.length,
                      itemBuilder: (context, index) {
                        final building = favoriteBuildings[index];
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: Text(building.name),
                            onTap: () {
                              _showBuildingDetails(context, building);
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Buildings",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: buildingData.length,
                      itemBuilder: (context, index) {
                        final building = buildingData[index];
                        return _buildBuildingCard(building);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildBuildingCard(BuildingInfo building) {
    final isFavorite = favoriteBuildings.contains(building);

    // Check if the building name contains the search query
    if (searchQuery.isEmpty ||
        building.name.toLowerCase().contains(searchQuery)) {
      return Card(
        elevation: 1,
        child: ListTile(
          leading: Icon(Icons.house),
          title: Text(building.name),
          onTap: () {
            _showBuildingDetails(context, building);
          },
        ),
      );
    } else {
      return Container(); // Return an empty container for non-matching items
    }
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  void _showBuildingDetails(BuildContext context, BuildingInfo building) {
    final bool isFavorite = favoriteBuildings.contains(building);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.15,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.house), // Icon for building
                        SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              building.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('${building.description}'),
                    ElevatedButton.icon(
                      onPressed: () {
                        isFavorite
                            ? _removeFromFavorites(building)
                            : _addToFavorites(building);
                      },
                      icon: Icon(
                        Icons.star,
                        color: isFavorite ? Colors.white : null,
                      ),
                      label: Text(
                        isFavorite
                            ? 'Remove from Favorites'
                            : 'Add to Favorites',
                      ),
                    ),
                    Text(
                      'Hours:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${building.hours}'),
                    Text(
                      'Accessible:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.door_sliding), // Icon for doors
                          SizedBox(width: 8),
                          Text('Doors'),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.wheelchair_pickup_rounded),
                          // Icon for ramps
                          SizedBox(width: 8),
                          Text('Ramps'),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.elevator), // Icon for elevator
                          SizedBox(width: 8),
                          Text('Elevator'),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.wc), // Icon for restroom
                          SizedBox(width: 8),
                          Text('Restroom'),
                        ],
                      ),
                    ),
                    Text(
                      'Address:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${building.address}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your report issue logic here
                      },
                      child: Text('Report Issue'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
