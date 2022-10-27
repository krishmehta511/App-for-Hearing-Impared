import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        child: Container(
          padding: const EdgeInsets.all(7),
          height: height,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('audio').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = snapshot.data!.docs;
              return Column(
                children: [
                  AudioInfoCard(
                    tag: documents[0]['tag'],
                    angle: double.parse(documents[0]['angle']),
                    distance: double.parse(documents[0]['distance']),
                  ),
                  SizedBox(height: height * 0.05),
                  const AudioInfoRadar(),
                  SizedBox(height: height * 0.05),
                  AudioInfoCard(
                    tag: audioData.tappedAudio.tag,
                    angle: audioData.tappedAudio.angle,
                    distance: audioData.tappedAudio.distance,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
