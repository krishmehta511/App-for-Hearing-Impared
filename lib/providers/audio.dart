import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:vibration/vibration.dart';

class Audio {
  String key;
  String title;
  double distance;
  double angle;
  String tag;

  Audio({
    required this.key,
    required this.title,
    required this.distance,
    required this.angle,
    required this.tag,
  });
}

class AudioClassification with ChangeNotifier {
  List<Audio> _audioItems = [];

  Audio _tappedAudio =
      Audio(key: '', title: '', distance: 0, angle: 0, tag: '');

  Audio get tappedAudio {
    return _tappedAudio;
  }

  List<Audio> get audioItems {
    return [..._audioItems];
  }

  int get audioItemsLength {
    return (_audioItems.length - 1);
  }

  Future<void> fetchAudio() async {
    final url = Uri.parse(
        'https://third-year-mini-project-default-rtdb.firebaseio.com/audio.json');
    try {
      final response = await http.get(url);
      final extractedData =
          jsonDecode(response.body == 'null' ? '{}' : response.body)
              as Map<String, dynamic>;
      final List<Audio> loadedData = [];
      extractedData.forEach(
        (key, value) {
          loadedData.add(
            Audio(
              key: key,
              title: value['title'],
              distance: value['distance'].toDouble(),
              angle: value['angle'],
              tag: value['tag'],
            ),
          );
        },
      );
      _audioItems = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Widget audioIcon(String tag) {
    Widget icon = const Iconify(Twemoji.minus_sign);
    if (tag == 'Vehicle') {
      icon = const Iconify(Twemoji.automobile);
    } else if (tag == 'Animal') {
      icon = const Iconify(Twemoji.dog);
    } else if (tag == 'Alert') {
      icon = const Iconify(Twemoji.warning);
    } else if (tag == 'Human') {
      icon = Image.asset(
        'lib/images/people_talking.png',
        scale: 3,
      );
    }
    return icon;
  }

  void changeTappedAudio(Audio audio) async {
    _tappedAudio = Audio(
      key: audio.key,
      title: audio.title,
      distance: audio.distance,
      angle: audio.angle,
      tag: audio.tag,
    );
    notifyListeners();
  }

  Future<void> addAudio(Audio audio) async {
    // if(audioItemsLength > 8){
    //   final key = _audioItems[8].key;
    //   await removeAudio(key);
    // }
    if(audio.tag == 'Alert'){
      if (await Vibration.hasVibrator() == true) {
        Timer(const Duration(seconds: 5), () => Vibration.vibrate(pattern: [0, 200, 100, 200]));
      }
    }
    final url = Uri.parse(
        'https://third-year-mini-project-default-rtdb.firebaseio.com/audio.json');
    try {
      await http.post(
        url,
        body: jsonEncode({
          'title': audio.title,
          'distance': audio.distance,
          'angle': audio.angle,
          'tag': audio.tag,
        }),
      );
    } catch (error) {
      rethrow;
    }
    await fetchAudio();
  }
}
