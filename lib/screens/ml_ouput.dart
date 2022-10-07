import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';

import '../widgets/app_drawer.dart';

class MLOutput extends StatefulWidget {
  static const routeName = '/MLOutput';

  const MLOutput({Key? key}) : super(key: key);

  @override
  State<MLOutput> createState() => _MLOutputState();
}

class _MLOutputState extends State<MLOutput> {
  bool _recording = false;
  String _sound = "Press the button to start";
  late Stream<Map<dynamic, dynamic>> result;

  @override
  void initState() {
    TfliteAudio.loadModel(
      model: 'lib/assets/audio_classifier.tflite',
      label: 'lib/assets/label.txt',
      isAsset: true,
      numThreads: 1,
      inputType: 'rawAudio',
    );
    super.initState();
  }

  void _recorder() {
    String recognition = "";
    if (!_recording) {
      setState(() => _recording = true);
      result = TfliteAudio.startAudioRecognition(
        bufferSize: 22016,
        sampleRate: 22050,
      ).handleError((error) {
        debugPrint(error);
      });
      result.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[0];
          debugPrint('Sound heard: $_sound');
        });
      });
    }
  }

  void _stop() async {
    TfliteAudio.stopAudioRecognition();
    setState(() {
      _sound = 'Press the button to start';
    });
    await result.drain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Machine Learning Model'),
      ),
      // body: Container(
      //   color: Colors.white10,
      //   height: MediaQuery.of(context).size.height * 0.4,
      //   child: StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance.collection('audio').snapshots(),
      //     builder: (ctx, snapshot) {
      //       if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      //       final docs = snapshot.data!.docs;
      //       return ListView.builder(
      //         itemCount: docs.length,
      //         itemBuilder: (ctx, index) => ListTile(
      //           title: Text(docs[index]['title']),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                _recorder();
                Timer(const Duration(seconds: 6), _stop);
              },
              child: const Text('Start')),
          //TextButton(onPressed: _stop, child: const Text('Stop')),
          Text(_sound),
        ],
      ),
    );
  }
}
