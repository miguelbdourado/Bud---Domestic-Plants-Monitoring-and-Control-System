import 'package:flutter/material.dart';

import '/constants.dart';

class ValueDisplayer extends StatefulWidget {
  const ValueDisplayer(
      {Key? key,
      required this.measureName,
      required this.measureUnit,
      required this.minValue,
      required this.maxValue,
      required this.currentValue})
      : super(key: key);

  final String measureName;
  final String measureUnit;
  final double minValue;
  final double maxValue;
  final double currentValue;

  @override
  _ValueDisplayerState createState() => _ValueDisplayerState();
}

class _ValueDisplayerState extends State<ValueDisplayer> {
  bool outOfBounds = false;
  double displayedValue = 0;

  void currValueBetweenBounds() {
    //TODO: redo this
    if (widget.currentValue <= widget.minValue) {
      setState(() {
        outOfBounds = true;
      });
    } else if (widget.currentValue >= widget.maxValue) {
      setState(() {
        outOfBounds = true;
        displayedValue = 1.0;
      });
    } else {
      setState(() {
        displayedValue = widget.currentValue / widget.maxValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    currValueBetweenBounds();
    return Center(
      child: Column(
        children: [
          RichText(
              text: TextSpan(
            text: widget.measureName,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kTextColor, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(fit: StackFit.expand, children: [
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: displayedValue),
                duration: const Duration(seconds: 4),
                builder: (BuildContext context, double value, Widget? child) {
                  return CircularProgressIndicator(
                    value: value,
                    color: kPrimaryColor,
                    backgroundColor: kDisplayerEmptyColor,
                    strokeWidth: 5,
                  );
                },
              ),
              Visibility(
                visible: !outOfBounds,
                child: Center(
                  child: Text(widget.currentValue.toString() +
                      " " +
                      widget.measureUnit),
                ),
              ),
              Visibility(
                visible: outOfBounds,
                child: const Center(
                  child: Icon(
                    Icons.report_problem,
                    size: 35,
                    color: kErrorColor,
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
