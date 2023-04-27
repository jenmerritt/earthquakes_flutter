class Earthquake {
  final String place;
  final String magnitude;
  final String url;
  final String x;
  final String y;
  final String z;

  const Earthquake(
      {required this.place,
      required this.magnitude,
      required this.url,
      required this.x,
      required this.y,
      required this.z});

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
        place: json['properties']['place'],
        magnitude: json['properties']['mag'].toString(),
        url: json['properties']['url'].toString(),
        x: json['geometry']['coordinates'][0].toString(),
        y: json['geometry']['coordinates'][1].toString(),
        z: json['geometry']['coordinates'][2].toString());
  }
}
