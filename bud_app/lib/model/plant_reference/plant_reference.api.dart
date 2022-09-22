import 'dart:convert';

import 'package:bud_app/constants.dart';
import 'package:http/http.dart' as http;

import 'plant_reference.dart';

class PlantReferenceApi {
  static Future<List<PlantReference>> getPlantRefs() async {
    var uri = Uri.http(authority, '/bud-api/plant');
    final response = await http.get(uri, headers: {});
    List data = jsonDecode(response.body);
    return PlantReference.plantRefsFromSnapshot(data);
  }

  static Future<PlantReference> getPlantRef(String refId) async {
    var uri = Uri.http(authority, '/bud-api/plant/$refId');
    final response = await http.get(uri, headers: {});
    var data = jsonDecode(response.body);
    return PlantReference.fromJson(data);
  }
}
