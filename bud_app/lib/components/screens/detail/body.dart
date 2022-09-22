import 'package:bud_app/components/screens/detail/configuration_dialog.dart';
import 'package:bud_app/components/screens/detail/value_displayer.dart';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/bud/bud.api.dart';
import 'package:bud_app/model/bud/bud.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

import 'details_header.dart';

class Body extends StatefulWidget {
  const Body(
      {Key? key, required this.user, required this.group, required this.bud})
      : super(key: key);

  final MyUser user;
  final Group group;
  final Bud bud;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> showInformationDialog(BuildContext context) async {
    String budUrl =
        "http://$authority/bud-api/user/${widget.user.uid}/group/${widget.group.id}/bud/${widget.bud.id}";

    await showDialog(
        context: context,
        builder: (context) {
          return ConfigurationDialog(
              budUrl: budUrl, userToken: widget.user.idToken);
        });
  }

  Future<void> waterPlant() async {
    BudApi.waterBud(widget.user, widget.group.id, widget.bud.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          DetailsHeader(
              luminosity: widget.bud.luminosity,
              temperature: widget.bud.temperature,
              ph: widget.bud.ph,
              humidity: widget.bud.humidity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              children: <Widget>[
                PlantNameAndRefName(
                    budName: widget.bud.name,
                    refName: widget.bud.plant_ref.name),
                const Spacer(),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () => waterPlant(),
                    icon: const Icon(Icons.water_drop_outlined),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: size.width / 3.5,
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        "Details",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                      onPressed: () => {showInformationDialog(context)},
                    )),
              ],
            ),
          ),
          SizedBox(
            //complete here and down
            height: size.height * 0.05,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: Row(
              children: <Widget>[
                Column(children: [
                  ValueDisplayer(
                    measureName: "Temperature",
                    measureUnit: "ºC",
                    minValue: widget.bud.plant_ref.temperatureMin,
                    currentValue: widget.bud.temperature,
                    maxValue: widget.bud.plant_ref.temperatureMax,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ValueDisplayer(
                    measureName: "Luminosity",
                    measureUnit: "lx",
                    minValue: widget.bud.plant_ref.luminosityMin,
                    currentValue: widget.bud.luminosity,
                    maxValue: widget.bud.plant_ref.luminosityMax,
                  ),
                ]),
                const SizedBox(
                  width: 100,
                ),
                Column(children: [
                  ValueDisplayer(
                    measureName: "Humidity",
                    measureUnit: "%",
                    minValue: widget.bud.plant_ref.humidityMin,
                    currentValue: widget.bud.humidity,
                    maxValue: widget.bud.plant_ref.humidityMax,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ValueDisplayer(
                    measureName: "pH",
                    measureUnit: "pH",
                    minValue: widget.bud.plant_ref.phMin,
                    currentValue: widget.bud.ph,
                    maxValue: widget.bud.plant_ref.phMax,
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}

class PlantNameAndRefName extends StatelessWidget {
  const PlantNameAndRefName(
      {Key? key, required this.budName, required this.refName})
      : super(key: key);

  final String budName;
  final String refName;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: budName + "\n",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: kTextColor, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: refName,
            style: const TextStyle(
              fontSize: 25,
              color: kPrimaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
