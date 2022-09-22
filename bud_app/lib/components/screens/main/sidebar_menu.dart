import 'package:bud_app/components/google_sign_in/google_sign_in.dart';
import 'package:bud_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: kPrimaryColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            const SizedBox(
              height: 48,
            ),
            DrawerTile(icon: Icons.person, text: "Profile", tapped: () {}),
            const Divider(color: Colors.white70),
            DrawerTile(icon: Icons.settings, text: "Settings", tapped: () {}),
            DrawerTile(
                icon: Icons.info_outline_rounded,
                text: "Support",
                tapped: () {}),
            const Divider(color: Colors.white70),
            DrawerTile(
                icon: Icons.logout_outlined,
                text: "Log Out",
                tapped: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                }),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.tapped,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Function() tapped;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: tapped,
    );
  }
}
