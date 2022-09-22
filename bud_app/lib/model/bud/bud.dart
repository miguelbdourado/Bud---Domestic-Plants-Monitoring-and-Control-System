import 'package:bud_app/model/plant_reference/plant_reference.dart';

class Bud {
  final String id, name;
  final double humidity, luminosity, ph, temperature;
  final bool interior, watering;
  final PlantReference plant_ref;

  Bud(this.id, this.name, this.humidity, this.luminosity, this.ph,
      this.temperature, this.plant_ref, this.interior, this.watering);

  factory Bud.fromJson(dynamic json) {
    return Bud(
        json["id"] as String,
        json["name"] as String,
        json["humidity"] + 0.0,
        json["luminosity"] + 0.0,
        json["ph"] + 0.0,
        json["temperature"] + 0.0,
        PlantReference.fromJson(json["plant_ref"]),
        json["interior"] as bool,
        json["watering"] as bool);
  }

  static List<Bud> budsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Bud.fromJson(data);
    }).toList();
  }
}
