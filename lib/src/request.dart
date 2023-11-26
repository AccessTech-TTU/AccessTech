import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'RequestsHistory.dart';

enum ReqStatus {
  received,
  processing,
  finished,
}

class Request {
  final String name;
  final String r_number;
  final String title;
  final String message;
  final DateTime date;
  final ReqStatus status;
  late final Position location;

  Request({
    required this.name,
    required this.r_number,
    required this.title,
    required this.message,
  })  : date = new DateTime.timestamp(),
        status = ReqStatus.received {
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          Position currentPosition = await Geolocator.getCurrentPosition();
          location = currentPosition;
        } else {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse) {
            Position currentPosition = await Geolocator.getCurrentPosition();
            location = currentPosition;
          }
        }
      } else {
        // Handle if location services are not enabled
        // You can prompt the user to enable location services here
      }
    } catch (e) {
      print("Error fetching location: $e");
      // Handle errors while fetching location
    }
  }

  String getDate() {
    return "${this.date.month}/${this.date.day}/${this.date.year} at ${this.date.hour}:${this.date.minute}}";
  }

  String getStatus() {
    switch (status) {
      case ReqStatus.received:
        return "Received";
      case ReqStatus.processing:
        return "Processing";
      case ReqStatus.finished:
        return "Finished";
    }
  }

  Future<Position?> getLocation() async {
    if (location.latitude != null && location.longitude != null) {
      return location;
    } else {
      // If the location is not fetched yet, attempt to fetch it again
      await _fetchLocation();
      return location;
    }
  }

  Future<void> getCoordinatesAsString() async {
    await _fetchLocation(); // Ensure location is fetched before accessing it

    if (location.latitude != null && location.longitude != null) {
      // Format the coordinates as a string
      print("(Lat: ${location.latitude}, Long: ${location.longitude})");
    } else {
      print("Coordinates not available");
    }
  }
}

class NewRequest extends StatefulWidget {
  const NewRequest({super.key, required this.onAddRequest});

  final void Function(Request request) onAddRequest;

  @override
  State<NewRequest> createState() {
    return _NewRequestState();
  }
}

class _NewRequestState extends State<NewRequest> {
  final _nameController = TextEditingController();
  final _rController = TextEditingController();
  final _titleController = TextEditingController();
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _rController.dispose();
    _titleController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _addRequest(Request r) {
    req_hist.add(r);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        Align(
          child: Text(
            "New Help Request",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Name*",
            //hintText: "Your name",
          ),
        ),
        TextField(
          controller: _rController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: "R",
            labelText: "R Number*",
            //hintText: "R Number",
          ),
        ),
        TextField(
          controller: _titleController,
          maxLines: 1,
          decoration: InputDecoration(
            labelText: "Title*",
            //hintText: "Describe your problem",
          ),
        ),
        TextField(
          controller: _msgController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: "Message",
            //hintText: "Describe your problem",
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                if (_nameController.text.trim().isNotEmpty &&
                    _rController.text.trim().isNotEmpty &&
                    _titleController.text.trim().isNotEmpty) {
                  _addRequest(new Request(
                      name: _nameController.text,
                      r_number: "R" + _rController.text,
                      title: _titleController.text,
                      message: _msgController.text));
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Invalid Inputs"),
                      content: Text("* fields cannot be empty."),
                    ),
                  );
                }
              },
              child: Text("Send"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        ),
      ]),
    );
  }
}
