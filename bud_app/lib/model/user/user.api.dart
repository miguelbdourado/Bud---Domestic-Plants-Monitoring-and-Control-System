import 'dart:convert';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<MyUser?> getUser(User firebaseUser) async {
    var uri = Uri.http(authority, '/bud-api/user/${firebaseUser.uid}');
    String? idToken;
    await firebaseUser
        .getIdTokenResult()
        .then((value) => idToken = value.token);
    print(idToken);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': idToken!,
      },
    );
    if (response.statusCode == 404) return null;
    var data = jsonDecode(response.body);
    return MyUser.fromJson(data, firebaseUser.photoURL, idToken!);
  }

  static Future<MyUser> createUser(User firebaseUser) async {
    var uri = Uri.http(authority, '/bud-api/user/');
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': firebaseUser.getIdToken().toString(),
        },
        body: jsonEncode(<String, String>{
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName!,
          'email': firebaseUser.email!,
        }));
    var data = jsonDecode(response.body);
    return MyUser.fromJson(
        data, firebaseUser.photoURL!, firebaseUser.getIdToken().toString());
  }
}
