import 'package:flutter/cupertino.dart';

class MyUser {
  final String uid, name, email;
  final NetworkImage? avatar;
  final String idToken;

  MyUser(this.uid, this.name, this.email, this.avatar, this.idToken);

  factory MyUser.fromJson(dynamic json, String? avatarURL, String idToken) {
    return MyUser(json["uid"] as String, json["name"] as String,
        json["email"] as String, NetworkImage(avatarURL!), idToken);
  }
}
