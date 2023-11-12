import 'package:accesstech/src/mapScreen/location_service.dart';
import 'package:flutter/material.dart';
import 'buildingData.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});
  @override
  _MyDraggableSheetState createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  //for search bar:
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: DraggableScrollableSheet(
            key: _sheet,
            initialChildSize: 0.5,
            maxChildSize: 1,
            minChildSize: 0.15,
            snap: true,
            snapSizes: [0.15, 0.5, 1],
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onTap: () {
                        _expand();
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                style: TextStyle(fontSize: 18), "Favorites"))),
                    ListView.builder(
                      //controller: scrollController,
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
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                style: TextStyle(fontSize: 18), "Buildings"))),
                    ListView.builder(
                      //controller: scrollController,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: buildingData.length,
                      itemBuilder: (context, index) {
                        final building = buildingData[index];
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            leading: Icon(Icons.house),
                            title: Text(building.name),
                            onTap: () {},
                          ),
                        );
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
}
