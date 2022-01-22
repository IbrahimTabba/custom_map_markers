import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Marker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Custom Marker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final locations = const [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.41796133580664, -122.085749655962),
    LatLng(37.43796133580664, -122.085749655962),
    LatLng(37.42796133580664, -122.095749655962),
    LatLng(37.42796133580664, -122.075749655962),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomGoogleMapMarkerBuilder(
        //screenshotDelay: const Duration(seconds: 4),
        customMarkers: [
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-1'), position: locations[0]),
              child: _customMarker3('Everywhere\nis a Widgets', Colors.blue)),
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-5'), position: locations[4]),
              child: _customMarker('A', Colors.black)),
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-2'), position: locations[1]),
              child: _customMarker('B', Colors.red)),
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-3'), position: locations[2]),
              child: _customMarker('C', Colors.green)),
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-4'), position: locations[3]),
              child: _customMarker2('D', Colors.purple)),
          MarkerData(
              marker: Marker(
                  markerId: const MarkerId('id-5'), position: locations[4]),
              child: _customMarker('A', Colors.blue)),
        ],
        builder: (BuildContext context, Set<Marker>? markers) {
          if (markers == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {

            },
          );
        },
      ),
    );
  }

  _customMarker(String symbol, Color color) {
    return Stack(
      children: [
        Icon(
          Icons.add_location,
          color: color,
          size: 50,
        ),
        Positioned(
          left: 15,
          top: 8,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(symbol)),
          ),
        )
      ],
    );
  }

  _customMarker2(String symbol, Color color) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: color , width: 2),
          color: Colors.white, borderRadius: BorderRadius.circular(15),boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 6
            )
      ]),
      child: Center(child: Text(symbol)),
    );
  }

  _customMarker3(String text, Color color) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: color , width: 2),
          color: Colors.white, borderRadius: BorderRadius.circular(4),boxShadow: [
        BoxShadow(
            color: color,
            blurRadius: 6
        )
      ]),
      child: Center(child: Text(text , textAlign: TextAlign.center,)),
    );
  }
}
