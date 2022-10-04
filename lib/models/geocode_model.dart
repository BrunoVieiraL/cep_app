class GeocodeModel {
  GeocodeModel({
    this.results,
  });

  List<Result>? results;

  factory GeocodeModel.fromMap(Map<String, dynamic> json) => GeocodeModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );
}

class Result {
  Result({
    this.geometry,
  });

  Geometry? geometry;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        geometry: Geometry.fromMap(json["geometry"]),
      );
}

class Geometry {
  Geometry({
    this.location,
  });

  Location? location;

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        location: Location.fromMap(json["location"]),
      );
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );
}
