import 'package:bud_app/components/screens/detail/DetailsScreen.dart';
import 'package:bud_app/components/screens/main/budCreateForm.dart';
import 'package:bud_app/components/screens/main/budDeleteForm.dart';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/bud/bud.api.dart';
import 'package:bud_app/model/bud/bud.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

import 'plantCardWidget.dart';

class BudGroupExpansionTile extends StatefulWidget {
  const BudGroupExpansionTile(
      {Key? key, required this.user, required this.group})
      : super(key: key);
  final MyUser user;
  final Group group;

  @override
  _BudGroupExpansionTileState createState() => _BudGroupExpansionTileState();
}

class _BudGroupExpansionTileState extends State<BudGroupExpansionTile> {
  late List<Bud> _buds;
  bool _isLoading = true;

  Future<void> getBuds() async {
    //dasuihhuasoiudh2/group/YC6zdQXrfoS3MKG7oWNM/bud/l1sSLsQK4phxGRcMxsBa
    _buds = await BudApi.getBuds(widget.user, widget.group.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBuds();
  }

  Future<void> showInformationDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return BudCreateForm(user: widget.user, group: widget.group);
        }).then((value) => {
          setState(() => {_isLoading = true}),
          Future.delayed(const Duration(seconds: 2), () {
            getBuds();
          }).then((value) => {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text("You're almost done"),
                        content: Text(
                            "After creating your bud make sure to check your bud details to configure your microcontroller."),
                      );
                    })
              })
        });
  }

  Future<void> showDeleteBudInformationDialog(
      BuildContext context, Bud bud) async {
    await showDialog(
        context: context,
        builder: (context) {
          return BudDeleteForm(
              user: widget.user, group: widget.group, bud: bud);
        }).then((value) => {
          setState(() => {_isLoading = true}),
          Future.delayed(const Duration(seconds: 2), () {
            getBuds();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: kPrimaryColor.withOpacity(0.23),
            ),
          ],
        ),
        margin: const EdgeInsets.only(
            left: kDefaultPadding,
            top: kDefaultPadding / 2,
            bottom: kDefaultPadding * 0.2,
            right: kDefaultPadding),
        child: ExpansionTile(
          iconColor: kPrimaryColor,
          textColor: kPrimaryColor,
          title: Row(children: [
            Text(widget.group.name),
            const Spacer(),
            Text(widget.group.date.toString()),
          ]),
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buds.isNotEmpty
                            ? SizedBox(
                                height: 280,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _buds.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsScreen(
                                                          user: widget.user,
                                                          group: widget.group,
                                                          bud: _buds[index])));
                                        },
                                        onLongPress: () {
                                          showDeleteBudInformationDialog(
                                              context, _buds[index]);
                                        },
                                        child: PlantCardWidget(
                                          image: "assets/images/image_1.png",
                                          title: _buds[index].name,
                                          plantRefType:
                                              _buds[index].plant_ref.name,
                                        ),
                                      );
                                    }),
                              )
                            : const SizedBox(
                                height: 120,
                                width: 170,
                                child: Center(
                                  child: Text(
                                    "This group is empty",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 15),
                                blurRadius: 50,
                                color: kPrimaryColor.withOpacity(0.40),
                              ),
                            ],
                          ),
                          child: TextButton(
                              onPressed: () async {
                                await showInformationDialog(context);
                              },
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
