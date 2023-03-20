import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:vibration/vibration.dart';

class Audio {
  String id;
  String tag;
  double distance;
  double angle;
  String time;

  Audio({
    required this.id,
    required this.distance,
    required this.angle,
    required this.tag,
    required this.time,
  });
}

class AudioClassification with ChangeNotifier {
  final List<Audio> _audio = [];

  List<Audio> get audio {
    return _audio;
  }

  int get lenAudio {
    return _audio.length;
  }

  void addToAudio(Audio audio) {
    if (_audio.where((element) => element.time == audio.time).isEmpty) {
      _audio.add(audio);
    }
  }

  Future<void> fetchAudio() async {
    var db = FirebaseDatabase.instance.ref("audio").limitToLast(10);
    db.onValue.listen((DatabaseEvent event) {
      final keys = (event.snapshot.value as Map<dynamic, dynamic>).keys.toList();
      final audio =
          (event.snapshot.value as Map<dynamic, dynamic>).values.toList();
      for (int i = 0; i < audio.length; i++) {
        var distance = 0.0;
        if (_audio.where((element) => element.id == keys[i]).isEmpty){
          if (audio[i]['tag'] == 'siren' || audio[i]['tag'] == 'car_horn') {
            if(audio[i]['loudness'] <= -14) {
              distance = Random().nextInt(5).toDouble() + 5;
            } else if (audio[i]['loudness'] >= -14 && audio[i]['loudness'] <= -13){
              distance = Random().nextInt(3).toDouble() + 3;
            } else if (audio[i]['loudness'] >= -13){
              distance = Random().nextInt(3).toDouble();
            }
            var angle = Random().nextInt(360).toDouble();
            addToAudio(Audio(
              id: keys[i],
              distance: distance,
              angle: angle,
              tag: audio[i]['tag'],
              time: DateTime.now().toIso8601String(),
            ));
          }
        }
      }
      checkAll();
      deleteFirst();
    });
  }

  void checkAll(){
    for (int i = 0; i < audio.length; i++){
      if (audio[i].distance <= 2){
        fireAlert();
      }
    }
  }

  Future<void> fireAlert() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 1500, amplitude: 200);
    }
  }

  void deleteFirst(){
    if (_audio.length > 5){
      _audio.removeAt(0);
    }
    notifyListeners();
  }

  Widget audioIcon(String tag) {
    Widget icon = const Iconify(
      Twemoji.minus_sign,
      color: Colors.white,
    );
    if (tag == 'car_horn') {
      icon = const Iconify(Twemoji.automobile);
    } else if (tag == 'siren') {
      icon = const Iconify(Twemoji.ambulance);
    }
    return icon;
  }

  Future<void> onTappedAudio(Audio audio) async {
    _audio.remove(audio);
    await FirebaseDatabase.instance.ref("audio").child(audio.id).remove();
    notifyListeners();
  }


}
