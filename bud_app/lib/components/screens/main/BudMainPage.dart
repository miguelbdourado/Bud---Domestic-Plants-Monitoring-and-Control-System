import 'package:bud_app/components/screens/main/sidebar_menu.dart';
import 'package:bud_app/constants.dart';
import 'package:bud_app/model/user/user.api.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bud_app/components/screens/main/body.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MyUser user;
  bool _isLoading = true;
  final firebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    createUserIfNotExist();
  }

  Future<void> createUserIfNotExist() async {
    MyUser? maybeUser = await UserApi.getUser(firebaseUser);
    maybeUser ??= await UserApi.createUser(firebaseUser);
    user = maybeUser;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: SvgPicture.asset("./assets/icons/menu.svg"),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : Body(user: user),
      drawer: const SidebarMenu(),
    );
  }
}
