import 'package:bud_app/constants.dart';
import 'package:bud_app/model/group/group.api.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

class GroupCreateForm extends StatefulWidget {
  const GroupCreateForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  final MyUser user;

  @override
  State<GroupCreateForm> createState() => _GroupCreateFormState();
}

class _GroupCreateFormState extends State<GroupCreateForm> {
  String _name = "";

  final _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Group Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid name';
        }
        return null;
      },
      onSaved: (value) => setState(() => _name = value!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildName()],
          )),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                GroupApi.createGroup(widget.user, _name);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                    'Added group.',
                    style: TextStyle(color: kPrimaryColor),
                  )),
                );
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
