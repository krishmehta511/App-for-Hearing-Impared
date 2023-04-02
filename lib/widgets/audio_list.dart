import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    final audioData = Provider.of<AudioClassification>(context, listen: false);
    final database = FirebaseDatabase.instance.ref();
    return StreamBuilder(
      stream: database.child("audio").orderByKey().onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          height: height * 0.38,
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
          decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "   Recent Audio",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const Divider(),
              Expanded(
                child: Consumer<AudioClassification>(
                  builder: (_, data, __) => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    padding: const EdgeInsets.all(0),
                    itemCount: data.lenAudio,
                    itemBuilder: (context, index) {
                      if(data.audio.isEmpty){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var angle =
                      (audioData.audio[index].angle);
                      final side = (audioData.audio[index].angle) > 90 && (audioData.audio[index].angle) < 270
                          ? "Left"
                          : "Right";
                      if(side == "Right"){
                        if (angle >= 270){
                          angle = (360-angle+90);
                        } else {
                          angle = 90 - angle;
                        }
                      } else if(side == "Left") {
                        angle = (angle-90);
                      }
                      final time = DateTime.now().difference(DateTime.parse(audioData.audio[index].time)).inMinutes;
                      return ListTile(
                        leading: audioData.audioIcon(audioData.audio[index].tag),
                        title: Text(audioData.audio[index].tag),
                        subtitle: Text(
                            "${audioData.audio[index].distance} away and $angle° to your $side"),
                        trailing: Text('${time}m ago'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
