import 'dart:ui';

import 'package:flutter/material.dart';

import '../screens/main_screen.dart';
import '../screens/ml_ouput.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Drawer(
        backgroundColor: const Color.fromRGBO(40, 51, 63, 1).withOpacity(0.3),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                ListTile(
                  //contentPadding: const EdgeInsets.all(10),
                  minLeadingWidth: 30,
                  leading: const CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                  title: Text(
                    "User Name",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: const Text("ussername@gmail.com"),
                ),
                SizedBox(height: height * 0.05),
                ListTile(
                  onTap: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                  leading: const Icon(
                    Icons.home_filled,
                    size: 20,
                  ),
                  title: Text(
                    "Home",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(MLOutput.routeName);
                  },
                  leading: const Icon(
                    Icons.settings,
                    size: 20,
                  ),
                  title: Text(
                    "ML Model",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
