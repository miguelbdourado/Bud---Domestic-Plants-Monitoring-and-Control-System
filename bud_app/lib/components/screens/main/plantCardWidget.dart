import 'package:bud_app/constants.dart';
import 'package:flutter/material.dart';

class PlantCardWidget extends StatelessWidget {
  const PlantCardWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.plantRefType,
  }) : super(key: key);

  final String image, title, plantRefType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          right: kDefaultPadding),
      width: size.width * 0.4,
      child: Column(children: <Widget>[
        Image.asset(image),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 50,
                  color: kPrimaryColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Row(children: <Widget>[
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: title.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                  const TextSpan(text: "\n"),
                  TextSpan(
                    text: plantRefType.toUpperCase(),
                    style: TextStyle(
                      color: kPrimaryColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ))
            ]),
          ),
        )
      ]),
    );
  }
}
