import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

import '../screens/add_audio_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/audio_info_radar.dart';
import '../widgets/audio_list.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('MyApp'),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(AddAudio.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromRGBO(40, 51, 63, 1),
        child: Container(
            padding: const EdgeInsets.all(7),
            height: height,
            child: Column(
              children: [
                const AudioInfoRadar(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_timer != null && _timer!.isActive) {
                        _timer!.cancel();
                      } else {
                        _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
                          await Provider.of<AudioClassification>(context, listen: false).fetchAudioFromStorage();
                        });
                      }
                    });
                    debugPrint(_timer!.isActive.toString());
                  },
                  child: Text(_timer != null && _timer!.isActive ? "Stop" : "Start"),
                ),
                const AudioList(),
              ],
            )),
      ),
    );
  }
}
