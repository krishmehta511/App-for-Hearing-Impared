import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

class AudioList extends StatefulWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final audioData = Provider.of<AudioClassification>(context);
    return Container(
      height: height * 0.38,
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      decoration: const BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "   Recent Audio",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("audio")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final angle =
                        (double.parse(docs[index]["angle"]) - 90).abs();
                    final side = double.parse(docs[index]["angle"]) - 90 > 0
                        ? "Left"
                        : "Right";
                    Timestamp getTime = docs[index]["time"];
                    final time = DateTime.now().difference(getTime.toDate()).inSeconds;
                    return ListTile(
                      leading: audioData.audioIcon(docs[index]["tag"]),
                      title: Text(docs[index]["tag"]),
                      subtitle: Text(
                          "${docs[index]["distance"]} away and $angle° to your $side"),
                      trailing: Text("${time}s ago"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
