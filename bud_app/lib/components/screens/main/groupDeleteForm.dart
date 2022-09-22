import 'package:bud_app/constants.dart';
import 'package:bud_app/model/group/group.api.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

class GroupDeleteForm extends StatefulWidget {
  const GroupDeleteForm({Key? key, required this.user, required this.group})
      : super(key: key);

  final MyUser user;
  final Group group;

  @override
  State<GroupDeleteForm> createState() => _GroupDeleteFormState();
}

class _GroupDeleteFormState extends State<GroupDeleteForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Group"),
      content: const Text("You are about to delete this Group. Are you sure?"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              GroupApi.deleteGroup(widget.user, widget.group.id);
              return Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: const Text("Delete")),
        TextButton(
            onPressed: () {
              return Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: kPrimaryColor),
            )),
      ],
    );
  }
}
