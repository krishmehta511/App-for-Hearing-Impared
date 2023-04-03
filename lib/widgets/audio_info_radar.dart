import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/audio.dart';
import 'package:provider/provider.dart';

class AudioInfoRadar extends StatefulWidget {
  const AudioInfoRadar({Key? key}) : super(key: key);

  @override
  State<AudioInfoRadar> createState() => _AudioInfoRadarState();
}

class _AudioInfoRadarState extends State<AudioInfoRadar> {
  Widget boundaryLines(double width, double multiple) {
    return Container(
      width: width * multiple,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54),
      ),
    );
  }

  List<Widget> directions(double radius) {
    return [
      const Positioned(
        top: 2,
        child: Text('0°'),
      ),
      const Positioned(
        bottom: 2,
        child: Text('180°'),
      ),
      const Positioned(
        left: 2,
        child: Text('90°'),
      ),
      const Positioned(
        right: 2,
        child: Text('90°'),
      ),
    ];
  }

  Widget radarLines(double radius, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        height: (2 * radius) - 55,
        width: 1,
        color: Colors.white54,
      ),
    );
  }

  Offset getAudioCoords(double radius, double distance, double angle) {
    double angleInRad = pi / 180 * angle;
    return Offset((radius * distance / 10) * sin((pi / 2) + angleInRad),
        (radius * distance / 10) * cos((pi / 2) + angleInRad));
  }

  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final radius = width * 0.5;
    final audioData = Provider.of<AudioClassification>(context);
    return SizedBox(
      height: (2 * radius) - 14,
      width: 2 * radius,
      child: StreamBuilder(
        stream: _database.child("audio").orderByKey().onValue,
        builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.0),
                  border: Border.all(color: Colors.white),
                ),
              ),
              for (int i = 1; i <= 4; i++) boundaryLines(2 * radius, 0.2 * i),
              const Icon(Icons.circle, size: 10),
              ...directions(radius),
              radarLines(radius, 0),
              radarLines(radius, pi / 2),
              ...audioData.audio.map((e){
                return Transform.translate(
                  offset: getAudioCoords(
                    radius,
                    e.distance,
                    e.angle,
                  ),
                  child: GestureDetector(
                    onTap: () => audioData.onTappedAudio(e),
                    child: audioData.audioIcon(e.tag),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
