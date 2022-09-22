import 'dart:async';

import 'package:bud_app/components/screens/main/groupDeleteForm.dart';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/group/group.api.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';
import 'budGroupExpasionTile.dart';
import 'groupCreateForm.dart';
import 'header.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);

  final MyUser user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<Group> _groups;
  bool _isLoading = true;

  Future<void> getGroups() async {
    _groups = await GroupApi.getGroups(widget.user);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  Future<void> showInformationDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return GroupCreateForm(user: widget.user);
        }).then((value) => {
          setState(() => {_isLoading = true}),
          Future.delayed(const Duration(seconds: 2), () {
            getGroups();
          })
        });
  }

  Future<void> showDeleteGroupInformationDialog(
      BuildContext context, Group group) async {
    await showDialog(
        context: context,
        builder: (context) {
          return GroupDeleteForm(user: widget.user, group: group);
        }).then((value) => {
          setState(() => {_isLoading = true}),
          Future.delayed(const Duration(seconds: 2), () {
            getGroups();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.2,
              child: Stack(
                children: <Widget>[
                  Header(size: size, user: widget.user),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 12),
              height: 24,
              child: const Text(
                'Groups',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await showInformationDialog(context);
              },
            ),
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: kPrimaryColor))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      showDeleteGroupInformationDialog(context, _groups[index]);
                    },
                    child: BudGroupExpansionTile(
                        user: widget.user, group: _groups[index]),
                  );
                }),
      ]),
    );
  }
}
