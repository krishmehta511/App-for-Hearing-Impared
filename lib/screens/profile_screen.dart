import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../providers/audio.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    final audioData = Provider.of<AudioClassification>(context);

    return Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height*0.05),
            Text(
              "Add / Update User Name",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: height*0.05),
            Row(
              children: [
                Container(
                  height: height * 0.1,
                  width: width * 0.7,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: _controller,
                      decoration:
                      const InputDecoration.collapsed(hintText: "Enter User Name"),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if(_controller.text != ""){
                      await audioData.updateUserName(_controller.text);
                    }
                    _controller.clear();
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
            // Text(
            //   "Add Custom Alerts",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            // Row(
            //   children: [
            //     Container(
            //       height: height * 0.1,
            //       width: width * 0.7,
            //       padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
            //       decoration: const BoxDecoration(
            //         color: Colors.white10,
            //         borderRadius: BorderRadius.all(Radius.circular(20)),
            //       ),
            //       child: Center(
            //         child: TextFormField(
            //           controller: _controller,
            //           decoration:
            //           const InputDecoration.collapsed(hintText: "Add an alert"),
            //         ),
            //       ),
            //     ),
            //     const Spacer(),
            //     ElevatedButton(
            //       onPressed: () async {
            //         if(_controller.text != ""){
            //           await audioData.addAlert(_controller.text);
            //         }
            //         _controller.clear();
            //       },
            //       child: const Text("Add"),
            //     ),
            //   ],
            // ),
            SizedBox(height: height*0.05),
            // Container(
            //   height: height * 0.3,
            //   width: width,
            //   decoration: const BoxDecoration(
            //     color: Colors.white10,
            //     borderRadius: BorderRadius.all(Radius.circular(20)),
            //   ),
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         SizedBox(height: height * 0.01),
            //         Text(
            //           "List of Added Alerts",
            //           style: Theme.of(context).textTheme.titleMedium,
            //         ),
            //         const Divider(),
            //
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
