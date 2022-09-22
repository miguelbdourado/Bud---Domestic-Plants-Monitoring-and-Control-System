import 'package:bud_app/constants.dart';
import 'package:bud_app/model/bud/bud.api.dart';
import 'package:bud_app/model/bud/bud.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

class BudDeleteForm extends StatefulWidget {
  const BudDeleteForm(
      {Key? key, required this.user, required this.group, required this.bud})
      : super(key: key);

  final MyUser user;
  final Group group;
  final Bud bud;

  @override
  State<BudDeleteForm> createState() => _BudDeleteFormState();
}

class _BudDeleteFormState extends State<BudDeleteForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Bud"),
      content: const Text("You are about to delete this bud. Are you sure?"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              BudApi.deleteBud(widget.user, widget.group.id, widget.bud.id);
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
