import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants.dart';
import 'icon_card.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader(
      {Key? key,
      required this.luminosity,
      required this.temperature,
      required this.ph,
      required this.humidity})
      : super(key: key);

  final double luminosity, temperature, ph, humidity;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: size.height * 0.8,
        child: Row(
          children: <Widget>[
            Stack(children: [
              Container(
                margin: EdgeInsets.only(left: size.width * 0.25),
                alignment: Alignment.centerRight,
                height: size.height * 0.8,
                width: size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(63),
                    bottomLeft: Radius.circular(63),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 60,
                        color: kPrimaryColor.withOpacity(0.29))
                  ],
                  image: const DecorationImage(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/image_1.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding * 2),
                child: Column(
                  children: <Widget>[
                    Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            icon:
                                SvgPicture.asset("assets/icons/back_arrow.svg"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        IconCard(
                            icon: "assets/icons/sun.svg",
                            value: luminosity.toString() + " lx"),
                        IconCard(
                            icon: "assets/icons/thermostat.svg",
                            value: temperature.toString() + " ºC"),
                        IconCard(
                            icon: "assets/icons/icon_3.svg",
                            value: ph.toString() + " pH"),
                        IconCard(
                            icon: "assets/icons/icon_4.svg",
                            value: humidity.toString() + " %"),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
