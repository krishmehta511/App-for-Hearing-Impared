import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

import '../screens/add_audio_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/audio_info_card.dart';
import '../widgets/audio_info_radar.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AudioClassification>(context).fetchAudio().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final audioData = Provider.of<AudioClassification>(context);

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
          decoration: const BoxDecoration(
            color: Color.fromRGBO(40, 51, 63, 1),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(7),
                  height: height,
                  child: Column(
                    children: [
                      AudioInfoCard(
                        title: audioData
                            .audioItems[audioData.audioItemsLength].title,
                        tag: audioData
                            .audioItems[audioData.audioItemsLength].tag,
                        angle: audioData.audioItems[audioData.audioItemsLength].angle,
                        distance: audioData
                            .audioItems[audioData.audioItemsLength].distance,
                      ),
                      SizedBox(height: height * 0.05),
                      const AudioInfoRadar(),
                      SizedBox(height: height * 0.05),
                      AudioInfoCard(
                        title: audioData.tappedAudio.title,
                        tag: audioData.tappedAudio.tag,
                        angle: audioData.tappedAudio.angle,
                        distance: audioData.tappedAudio.distance,
                      ),
                    ],
                  ),
                ),
        ));
  }
}
