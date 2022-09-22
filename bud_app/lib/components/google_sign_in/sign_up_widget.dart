import 'package:bud_app/components/google_sign_in/google_sign_in.dart';
import 'package:bud_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
              ),
              Container(
                child: Image.asset(
                  "assets/logos/bud_icon.png",
                  width: 70,
                  height: 70,
                ),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 30,
                      )
                    ]),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Bud",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: "Monitoring app for your plants",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36)),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.40))
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.40))
              ],
            ),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                icon:
                    const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                label: const Text('Sign in With Google'),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                }),
          ),
        ],
      );
}
