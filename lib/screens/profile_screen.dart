import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: const Center(
        child: Text("Profile"),
      ),
    );
  }
}
