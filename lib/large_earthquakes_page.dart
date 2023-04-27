import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'earthquake_model.dart';
import 'package:latlong2/latlong.dart';

class LargeEarthquakesPage extends StatelessWidget {
  LargeEarthquakesPage({super.key, required this.earthquakes});

  final List<Earthquake> earthquakes;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Distribution of all historical earthquakes over 8.0 magnitude",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        createMap(),
        Padding(padding: EdgeInsets.all(10)),
        createEarthquakeList(),
      ],
    );
  }

  Widget createEarthquakeList() {
    return DataTable(
        columns: const [
          DataColumn(label: Text('Earthquake Location')),
          DataColumn(label: Text('Magnitude')),
        ],
        rows: earthquakes
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.place)),
                  DataCell(Text(e.magnitude)),
                ]))
            .toList());
  }

  Widget createMap() {
    return Container(
      width: 800,
      height: 400,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(30, 30),
          zoom: 1,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: earthquakes
                .map(
                  (e) => Marker(
                    point: LatLng(double.parse(e.y), double.parse(e.x)),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        // update some state to display the earthquake data
                      },
                      child: const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
