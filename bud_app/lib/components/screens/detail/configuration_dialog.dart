import 'package:bud_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigurationDialog extends StatelessWidget {
  const ConfigurationDialog(
      {Key? key, required this.budUrl, required this.userToken})
      : super(key: key);

  final String budUrl;
  final String userToken;
  static const String description =
      "To Configure your MicroController make sure to follow these steps:\n\n\t1- Scan your Wi-Fi Network and make sure there is a Network called 'Bud System'.\n\t2- After Connecting, select your home Wi-Fi, enter your credentials and the URI and id token given below.";

  _copyBudUrl() {
    Clipboard.setData(ClipboardData(text: budUrl));
  }

  _copyUserIdToken() {
    Clipboard.setData(ClipboardData(text: userToken));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configuring your MicroController"),
      content: SizedBox(
        height: 300,
        child: Column(
          children: [
            const Text(description),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 210,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: kBackgroundColor),
                          color: kBackgroundColor),
                      child: Text(
                        budUrl,
                        style: const TextStyle(fontSize: 15, color: kTextColor),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _copyBudUrl,
                  icon: const Icon(
                    Icons.content_copy,
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 210,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: kBackgroundColor),
                          color: kBackgroundColor),
                      child: Text(
                        userToken,
                        style: const TextStyle(fontSize: 15, color: kTextColor),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _copyUserIdToken,
                  icon: const Icon(
                    Icons.content_copy,
                  ),
                )
              ],
            )
          ],
        ),
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
