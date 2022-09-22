import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/constants.dart';

class IconCard extends StatefulWidget {
  const IconCard({Key? key, required this.icon, required this.value})
      : super(key: key);

  final String icon;
  final String value;

  @override
  _IconCardState createState() => _IconCardState();
}

class _IconCardState extends State<IconCard> {
  bool toggle = true;
  double boxWidth = 68;
  var boxColor = kBackgroundColor;
  bool visible = false;
  static const double maxWidthSize = 155;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void _expandBox() {
      setState(() {
        if (toggle) {
          boxWidth = maxWidthSize;
        } else {
          boxColor = kBackgroundColor;
          boxWidth = 68;
          visible = false;
        }
        toggle = !toggle;
      });
    }

    void toggleVisibility() {
      setState(() {
        if (boxWidth == maxWidthSize) visible = true;
      });
    }

    return AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      height: 63,
      width: boxWidth,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 15),
            blurRadius: 22,
            color: kPrimaryColor.withOpacity(0.22),
          ),
        ],
      ),
      child: Row(children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            widget.icon,
            color: kPrimaryColor,
          ),
          onPressed: () {
            _expandBox();
          },
        ),
        Visibility(visible: visible, child: const VerticalDivider()),
        const Spacer(),
        Visibility(
          visible: visible,
          child: Container(
              child: Text(widget.value),
              padding: const EdgeInsets.symmetric(horizontal: 10)),
        ),
        const Spacer()
      ]),
      duration: const Duration(milliseconds: 500),
      onEnd: () => toggleVisibility(),
    );
  }
}
