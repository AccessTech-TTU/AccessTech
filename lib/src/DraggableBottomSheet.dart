/*
Authors:
  Raj Raman, Thinh Pham
Description:
  This file is the draggable bottom sheet with building information.
*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'buildingData.dart';
import 'building_screen.dart';
import 'dart:math';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({Key? key, required this.destinationChanged});
  final Function destinationChanged;
  @override
  _MyDraggableSheetState createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final DraggableScrollableController _controller = DraggableScrollableController();
  String searchQuery = '';
  bool isSearching = false;
  ScrollController scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showFullList = false;
  int _buildingsToShow = 10; // Initial number of buildings to show

  void _showMoreBuildings() {
    if (_buildingsToShow < buildingData.length) {
      setState(() {
        _buildingsToShow += 10;
      });
    }
  }


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
  void initState() {
    super.initState();
    // No need to add a listener here since we'll use the GestureDetector
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the max and initial sizes here for reference later
    const double maxChildSize = 0.80;
    const double initialChildSize = 0.5;

    // Filter the buildings based on the search query
    List<BuildingInfo> filteredBuildings = searchQuery.isEmpty
        ? buildingData
        : buildingData.where((building) =>
        building.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Calculate the total item count, considering the search query
    int itemCount = favoriteBuildings.length +
        2; // Include favorites and headers
    itemCount += searchQuery.isEmpty
        ? min(_buildingsToShow, buildingData.length)
        : filteredBuildings
        .length; // Add either the number of buildings to show, or all filtered buildings if searching

    // Include the "See More" button if there are more buildings to show and not searching
    if (buildingData.length > _buildingsToShow &&
        searchQuery.isEmpty) itemCount++;

    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: 0.13,
        snap: true,
        snapSizes: [0.13, initialChildSize, maxChildSize],
        controller: _controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 68),
                // Padding for the static search bar height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "Favorites" header and list logic
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Favorites",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else if (index <= favoriteBuildings.length) {
                      // Favorite buildings list logic
                      final building = favoriteBuildings[index - 1];
                      return _buildBuildingCard(building);
                    } else if (index == favoriteBuildings.length + 1) {
                      // "Buildings" header logic
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Buildings",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else if (searchQuery.isEmpty && index <
                        favoriteBuildings.length + _buildingsToShow + 2) {
                      // Non-search "Buildings" list logic
                      final buildingIndex = index - favoriteBuildings.length -
                          2;
                      final building = buildingData[buildingIndex];
                      return _buildBuildingCard(building);
                    } else if (!searchQuery.isEmpty && index <
                        favoriteBuildings.length + filteredBuildings.length +
                            2) {
                      // Search results logic
                      final buildingIndex = index - favoriteBuildings.length -
                          2;
                      final building = filteredBuildings[buildingIndex];
                      return _buildBuildingCard(building);
                    } else if (index ==
                        favoriteBuildings.length + _buildingsToShow + 2 &&
                        searchQuery.isEmpty) {
                      // "See More" button logic
                      return Center(
                        child: ElevatedButton(
                          onPressed: _showMoreBuildings,
                          child: Text('See More'),
                        ),
                      );
                    }
                    return Container(); // For indices that don't match any condition
                  },
                ),
              ),
              // Positioned widget for draggable handle and search bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    _controller.jumpTo(
                      _controller.size - details.primaryDelta! / MediaQuery
                          .of(context)
                          .size
                          .height,
                    );
                  },
                  onVerticalDragEnd: (details) {
                    // Call the snap function when the drag ends
                    _snapToClosestPoint();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        SizedBox(
                          width: 50,
                          child: Divider(
                            thickness: 5,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Search',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onTap: () {
                                  // First, animate to the top of the list if it's not already there.
                                  if (scrollController.hasClients &&
                                      scrollController.offset > 0) {
                                    scrollController.animateTo(
                                      0, // Scroll to the top
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    ).then((_) {
                                      // Then, proceed with the other operations after scrolling.
                                      setState(() {
                                        isSearching = true;
                                        _controller.animateTo(
                                          maxChildSize,
                                          // Expand the bottom sheet to the maxChildSize
                                          duration: const Duration(
                                              milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      });
                                    });
                                  } else {
                                    // If the list is already at the top, just expand the bottom sheet.
                                    setState(() {
                                      isSearching = true;
                                      _controller.animateTo(
                                        maxChildSize,
                                        // Expand the bottom sheet to the maxChildSize
                                        duration: const Duration(
                                            milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    });
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),

                            if (isSearching)
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  _textEditingController.clear();
                                  _focusNode.unfocus();
                                  setState(() {
                                    isSearching = false;
                                    searchQuery = '';
                                  });
                                  _controller.animateTo(
                                    initialChildSize,
                                    // Snap back to the initial position
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  ).then((_) {
                                    // After snapping back, animate to the top of the list
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(
                                        0, // Scroll to the top
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _snapToClosestPoint() {
    final double currentSize = _controller.size;
    final List<double> snapPoints = [0.13, 0.5, 1];
    final double closestSnapSize = snapPoints.reduce((double a, double b) {
      return (currentSize - a).abs() < (currentSize - b).abs() ? a : b;
    });

    // Only snap if the current size is not already at a snap point
    if (!snapPoints.contains(currentSize)) {
      _controller.animateTo(
        closestSnapSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  //
  // double _getClosestSnapPoint(double currentSize, List<double> snapPoints) {
  //   // Ensure that snapPoints is not empty to avoid a potential error
  //   if (snapPoints.isEmpty) {
  //     // Return a default value, for example, the initialChildSize
  //     return 0.5; // or any other appropriate default value
  //   }
  //
  //   // If snapPoints is not empty, find and return the closest snap point
  //   return snapPoints.reduce((double a, double b) {
  //     return (currentSize - a).abs() < (currentSize - b).abs() ? a : b;
  //   });
  // }


  Widget _buildBuildingCard(BuildingInfo building) {
    final isFavorite = favoriteBuildings.contains(building);

    // Check if the building name contains the search query
    if (searchQuery.isEmpty ||
        building.name.toLowerCase().contains(searchQuery)) {
      return Card(
        elevation: 1,
        child: ListTile(
          leading: isFavorite ? Icon(Icons.star) : Icon(Icons.house),
          // Use star icon for favorites
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

  //
  // void _onChanged() {
  //   final currentSize = _controller.size;
  //   if (currentSize <= 0.05) _collapse();
  // }

  // void _collapse() => _animateSheet(sheet.snapSizes!.first);
  //
  // void _anchor() => _animateSheet(sheet.snapSizes!.last);
  //
  // void _expand() => _animateSheet(sheet.maxChildSize);
  //
  // void _hide() => _animateSheet(sheet.minChildSize);

  // void _animateSheet(double size) {
  //   _controller.animateTo(
  //     size,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }
  Widget _buildAccessibilityFeature(IconData icon, String title,
      String description) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(description),
    );
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);


  void _showBuildingDetails(BuildContext context, BuildingInfo building) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Allow the bottom sheet to take the full screen height
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to rebuild part of the UI
          builder: (BuildContext context, StateSetter setState) {
            // Check the favorite status inside the StatefulBuilder to ensure it's up-to-date
            final bool isFavorite = favoriteBuildings.contains(building);

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              // Set the initial size to 75% of the screen height
              maxChildSize: 0.75,
              // Set the max size to 75% to prevent full expansion
              minChildSize: 0.5,
              // Minimum size when the user drags down
              expand: false,
              // Prevent the sheet from expanding to full height
              builder: (BuildContext context,
                  ScrollController scrollController) {
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
                        Text(building.description),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isFavorite) {
                              _removeFromFavorites(building);
                            } else {
                              _addToFavorites(building);
                            }
                            // Use 'setState' provided by StatefulBuilder to rebuild the UI
                            setState(() {});
                          },
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.white : null,
                          ),
                          label: Text(
                            isFavorite
                                ? 'Remove from Favorites'
                                : 'Add to Favorites',
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO replace placeholder
                            print("changing");
                            widget.destinationChanged(building.latlong);
                            // Use 'setState' provided by StatefulBuilder to rebuild the UI
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.location_on
                          ),
                          label: Text('Navigate Test'),
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
                        _buildAccessibilityFeature(Icons.door_sliding, 'Doors',
                            building.accessibleDoors),
                        _buildAccessibilityFeature(Icons
                            .wheelchair_pickup_rounded, 'Ramps',
                            building.ramps),
                        _buildAccessibilityFeature(Icons.elevator, 'Elevator',
                            building.elevators),
                        _buildAccessibilityFeature(Icons.wc, 'Restroom',
                            building.restrooms),
                        Text(
                          'Address:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${building.address}'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the current bottom sheet
                            _showReportIssueForm(context, building); // Call the new method to show the report issue form
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
      },
    );
  }
}
void _showReportIssueForm(BuildContext context, BuildingInfo building) {
  final _formKey = GlobalKey<FormState>();
  String issueDescription = '';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        height: MediaQuery.of(ctx).size.height / 2, // Set the height to half the screen height
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Report Issue for ${building.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Describe the issue",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description of the issue.';
                  }
                  return null;
                },
                onSaved: (value) {
                  issueDescription = value ?? '';
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        // You can handle the issueDescription here
                        print('Issue reported: $issueDescription'); // For now, just print it to the console
                        Navigator.pop(ctx); // Close the form
                      }
                    },
                    child: Text("Send"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


