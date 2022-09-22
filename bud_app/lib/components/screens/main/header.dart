import 'package:bud_app/constants.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.size,
    required this.user,
  }) : super(key: key);

  final Size size;
  final MyUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: 36 + kDefaultPadding),
      height: size.height * 0.20 - 20,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: kPrimaryColor.withOpacity(0.40))
        ],
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Hello,\n' + user.name,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            child: CircleAvatar(
              radius: 25,
              backgroundImage: user.avatar,
              backgroundColor: Colors.black,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                    color: Colors.black54)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
