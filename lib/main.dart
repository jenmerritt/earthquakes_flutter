import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'earthquake_model.dart';
import 'large_earthquakes_page.dart';

Future<List<Earthquake>> fetchEarthquakes() async {
  final response = await http.get(Uri.parse(
      'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=1700-01-01&endtime=2021-01-01&minmagnitude=8&orderby=magnitude'));

  if (response.statusCode == 200) {
    List<Earthquake> earthquakes = [];
    var json = jsonDecode(response.body);
    List<dynamic> features = json['features'];
    for (var i = 0; i < features.length - 1; i++) {
      earthquakes.add(Earthquake.fromJson(features[i]));
    }
    return earthquakes;
  } else {
    throw Exception('Failed to fetch');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Earthquake>> futureEarthquake;

  @override
  void initState() {
    super.initState();
    futureEarthquake = fetchEarthquakes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USGS Earthquake Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('USGS Earthquake Data'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<List<Earthquake>>(
              future: futureEarthquake,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return LargeEarthquakesPage(earthquakes: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
