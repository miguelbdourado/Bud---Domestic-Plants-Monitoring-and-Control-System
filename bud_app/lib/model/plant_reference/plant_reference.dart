class PlantReference {
  final String id, name;
  final double humidityMin,
      humidityMax,
      luminosityMin,
      luminosityMax,
      phMin,
      phMax,
      temperatureMin,
      temperatureMax;

  PlantReference(
      this.id,
      this.name,
      this.humidityMin,
      this.humidityMax,
      this.luminosityMin,
      this.luminosityMax,
      this.phMin,
      this.phMax,
      this.temperatureMin,
      this.temperatureMax);

  factory PlantReference.fromJson(dynamic json) {
    return PlantReference(
      json["id"] as String,
      json["name"] as String,
      json["humidity_min"] + 0.0,
      json["humidity_max"] + 0.0,
      json["luminosity_min"] + 0.0,
      json["luminosity_max"] + 0.0,
      json["ph_min"] + 0.0,
      json["ph_max"] + 0.0,
      json["temperature_min"] + 0.0,
      json["temperature_max"] + 0.0,
    );
  }

  static List<PlantReference> plantRefsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return PlantReference.fromJson(data);
    }).toList();
  }
}
