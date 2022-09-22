import 'dart:convert';

import 'package:bud_app/constants.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:http/http.dart' as http;

class GroupApi {
  static Future<List<Group>> getGroups(MyUser user) async {
    var uri = Uri.http(authority, '/bud-api/user/${user.uid}/group/');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': user.idToken,
      },
    );
    List data = jsonDecode(response.body);
    return Group.groupsFromSnapshot(data);
  }

  static Future<void> deleteGroup(MyUser user, String groupId) async {
    var uri = Uri.http(authority, '/bud-api/user/${user.uid}/group/$groupId');
    await http.delete(
      uri,
      headers: <String, String>{
        'Authorization': user.idToken,
      },
    );
  }

  static Future<void> createGroup(MyUser user, String name) async {
    var uri = Uri.http(authority, '/bud-api/user/${user.uid}/group/');
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': user.idToken,
        },
        body: jsonEncode(<String, String>{
          'name': name,
        }));
  }
}
