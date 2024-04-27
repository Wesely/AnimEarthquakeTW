import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/earthquake_data.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<EventData> dataList = EventData.parsedSourceData;
  DateTime startTime = DateTime.parse("2023-04-01 00:00");
  DateTime endTime = DateTime.parse("2023-04-27 09:00");
  DateTime currentDateTime = DateTime.parse("2023-04-01 00:00");
  int speed =
      5; // This could be a factor to increase or decrease animation speed

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _centerTW = CameraPosition(
    target: LatLng(23.7421288, 120.6801905),
    zoom: 8,
  );

  Map<CircleId, Circle> circles = {};
  late Timer timer;

  @override
  void initState() {
    super.initState();
    animateMap();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void animateMap() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentDateTime.isBefore(endTime)) {
        setState(() {
          currentDateTime = currentDateTime.add(Duration(minutes: speed));
          updateMarkers();
        });
      } else {
        timer.cancel();
      }
    });
  }

  void updateMarkers() {
    circles.clear();
    for (var data in dataList) {
      DateTime dataTime = DateTime.parse(data.time);
      if (dataTime.isBefore(currentDateTime)) {
        var circleId = CircleId(data.hashCode.toString());
        circles[circleId] = Circle(
          circleId: circleId,
          center: LatLng(data.latitude, data.longitude),
          radius: data.magnitude * 50, // Example: radius depends on magnitude
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 2,
        );
      }
    }
    // todo:??
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _centerTW,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: Set<Circle>.of(circles.values),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              '${currentDateTime.toString()}',
              style: TextStyle(fontSize: 24, color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }
}
