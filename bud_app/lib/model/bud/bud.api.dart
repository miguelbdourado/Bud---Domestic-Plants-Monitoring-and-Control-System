import 'dart:convert';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/user/user.dart';
import 'bud.dart';
import 'package:http/http.dart' as http;

class BudApi {
  static Future<List<Bud>> getBuds(MyUser user, String budgroupId) async {
    var uri =
        Uri.http(authority, '/bud-api/user/${user.uid}/group/$budgroupId/bud');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': user.idToken,
      },
    );
    List data = jsonDecode(response.body);
    return Bud.budsFromSnapshot(data);
  }

  static Future<Bud> getBud(
      MyUser user, String budgroupId, String budId) async {
    var uri = Uri.http(
        authority, '/bud-api/user/${user.uid}/group/$budgroupId/bud/$budId');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': user.idToken,
      },
    );
    var data = jsonDecode(response.body);
    return Bud.fromJson(data);
  }

  static Future<void> createBud(MyUser user, String budgroupId, Bud bud) async {
    var uri =
        Uri.http(authority, '/bud-api/user/${user.uid}/group/$budgroupId/bud/');
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': user.idToken,
        },
        body: jsonEncode(<String, dynamic>{
          'name': bud.name,
          'plant_ref': bud.plant_ref.id,
          'interior': bud.interior,
        }));
  }

  static Future<void> deleteBud(
      MyUser user, String budgroupId, String budId) async {
    var uri = Uri.http(
        authority, '/bud-api/user/${user.uid}/group/$budgroupId/bud/$budId');
    await http.delete(
      uri,
      headers: <String, String>{
        'Authorization': user.idToken,
      },
    );
  }

  static Future<void> waterBud(
      MyUser user, String budgroupId, String budId) async {
    var uri = Uri.http(
        authority, '/bud-api/user/${user.uid}/group/$budgroupId/bud/$budId');
    await http.put(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': user.idToken,
        },
        body: jsonEncode(<String, dynamic>{
          'watering': true,
        }));
  }
}
