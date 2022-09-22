import 'package:bud_app/model/bud/bud.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';
import 'body.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(
      {Key? key, required this.user, required this.group, required this.bud})
      : super(key: key);

  final MyUser user;
  final Group group;
  final Bud bud;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(user: widget.user, group: widget.group, bud: widget.bud));
  }
}
