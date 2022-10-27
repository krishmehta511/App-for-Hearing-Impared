import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:vibration/vibration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Audio {
  String tag;
  double distance;
  double angle;

  Audio({
    required this.distance,
    required this.angle,
    required this.tag,
  });
}

class AudioClassification with ChangeNotifier {
  Audio _tappedAudio =
      Audio(tag: '',distance: 0, angle: 0);

  Audio get tappedAudio {
    return _tappedAudio;
  }

  Widget audioIcon(String tag) {
    Widget icon = const Iconify(Twemoji.minus_sign, color: Colors.white,);
    if (tag == 'car_horn' || tag == 'engine_idling') {
      icon = const Iconify(Twemoji.automobile);
    } else if (tag == 'dog_barking') {
      icon = const Iconify(Twemoji.dog);
    } else if (tag == 'alert') {
      icon = const Iconify(Twemoji.warning);
    } else if (tag == 'children_playing') {
      icon = Image.asset(
        'lib/images/people_talking.png',
        scale: 3,
      );
    } else if(tag == 'air_conditioner'){
      icon = const Icon(Icons.ac_unit);
    } else if (tag == 'street_music') {
      icon = const Iconify(Twemoji.musical_note);
    } else if (tag == 'gun_shot') {
      icon = const Iconify(Twemoji.pistol);
    } else if (tag == 'siren') {
      icon = const Iconify(Twemoji.ambulance);
    } else if (tag == 'jackhammer' || tag == 'drilling') {
      icon = const Iconify(Twemoji.construction);
    }
    return icon;
  }

  void changeTappedAudio(Audio audio) async {
    _tappedAudio = Audio(
      tag: audio.tag,
      distance: audio.distance,
      angle: audio.angle,
    );
    notifyListeners();
  }

  Future<void> addAudio(Audio audio) async {
    if(audio.tag == 'Alert'){
      if (await Vibration.hasVibrator() == true) {
        Timer(const Duration(seconds: 5), () => Vibration.vibrate(pattern: [0, 200, 100, 200]));
      }
    }
    await FirebaseFirestore.instance.collection('audio').add({
      'tag': audio.tag,
      'distance': audio.distance.toString(),
      'angle': audio.angle.toString(),
    });
  }
}
