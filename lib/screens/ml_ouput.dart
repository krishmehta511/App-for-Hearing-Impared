import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_drawer.dart';

class MLOutput extends StatefulWidget {
  static const routeName = '/MLOutput';

  const MLOutput({Key? key}) : super(key: key);

  @override
  State<MLOutput> createState() => _MLOutputState();
}

class _MLOutputState extends State<MLOutput> {
  // final _recorder = FlutterSoundRecorder();
  // final _audioPlayer = FlutterSoundPlayer();
  // bool _isRecorderReady = false;
  // bool _isRecording = false;
  // String outputFile = "";
  // String predictedClass = "";
  //
  // final _storageRef = FirebaseStorage.instance.ref().child("audio/audio.wav");
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _audioPlayer.openAudioSession();
  //   initRecorder();
  // }
  //
  // @override
  // void dispose() {
  //   _recorder.closeAudioSession();
  //   _audioPlayer.closeAudioSession();
  //   super.dispose();
  // }
  //
  // Future initRecorder() async {
  //   Directory? dir = await getApplicationSupportDirectory();
  //   outputFile = '${dir.path}/audio.wav';
  //   final status1 = await Permission.microphone.request();
  //   final status2 = await Permission.storage.request();
  //   final status3 = await Permission.manageExternalStorage.request();
  //   if (status1 != PermissionStatus.granted &&
  //       status2 != PermissionStatus.granted &&
  //       status3 != PermissionStatus.granted) {
  //     throw 'Permission not granted';
  //   }
  //   await _recorder.openAudioSession(
  //     focus: AudioFocus.requestFocusAndStopOthers,
  //     category: SessionCategory.playAndRecord,
  //     mode: SessionMode.modeDefault,
  //     device: AudioDevice.speaker,
  //   );
  //   _recorder.setSubscriptionDuration(
  //     const Duration(milliseconds: 300),
  //   );
  //   _isRecorderReady = true;
  // }
  //
  // Future start() async {
  //   if (!_isRecorderReady) return;
  //   await _recorder.startRecorder(
  //     toFile: outputFile,
  //     codec: Codec.pcm16WAV,
  //   );
  // }
  //
  // Future stop() async {
  //   if (!_isRecorderReady) return;
  //   final filepath = await _recorder.stopRecorder();
  //   final audioFile = File(filepath!);
  //   debugPrint("Recorded audio : $audioFile");
  // }
  //
  // Future play() async {
  //   if(!_audioPlayer.isOpen()){
  //     debugPrint("NO");
  //     return;
  //   }
  //   await _audioPlayer.startPlayer(
  //     fromURI: outputFile,
  //     codec: Codec.pcm16WAV,
  //   );
  // }
  //
  // Future uploadFile() async {
  //   File file = File(outputFile);
  //   try{
  //     await _storageRef.putFile(file);
  //   } catch(e){
  //     debugPrint(e.toString());
  //   }
  // }
  //
  // Future getClass() async {
  //   const url = "https://api-for-te-project.herokuapp.com/predict";
  //   var req = http.MultipartRequest('POST', Uri.parse(url));
  //   req.files.add(
  //       await http.MultipartFile.fromPath("files", outputFile)
  //   );
  //   var response = await req.send();
  //   var responseData = await response.stream.bytesToString();
  //   setState(() {
  //     predictedClass = jsonDecode(responseData);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Machine Learning Model'),
      ),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   color: const Color.fromRGBO(40, 51, 63, 1),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       const SizedBox(width: 20),
      //       StreamBuilder<RecordingDisposition>(
      //         stream: _recorder.onProgress,
      //         builder: (ctx, snapshot) {
      //           final duration =
      //               snapshot.hasData ? snapshot.data!.duration : Duration.zero;
      //           return Text("${duration.inSeconds} s", style: const TextStyle(fontSize:30),);
      //         },
      //       ),
      //       GestureDetector(
      //         onTap: () async {
      //           if (_recorder.isRecording) {
      //             await stop();
      //           } else {
      //             await start();
      //           }
      //           setState(() {
      //             _isRecording = !_isRecording;
      //           });
      //         },
      //         child: Container(
      //           padding: const EdgeInsets.all(20),
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Colors.white),
      //             borderRadius: const BorderRadius.all(Radius.circular(100)),
      //           ),
      //           child: Icon(
      //             _isRecording ? Icons.stop : Icons.mic,
      //             size: 80,
      //           ),
      //         ),
      //       ),
      //       ElevatedButton(
      //         onPressed: () async {
      //           await play();
      //         },
      //         child: const Text('Play Audio'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () async {
      //           await uploadFile();
      //           await getClass();
      //         },
      //         child: const Text('Classify Audio'),
      //       ),
      //       Text(predictedClass, style: const TextStyle(fontSize: 40)),
      //     ],
      //   ),
      // ),
      body: const Center(
        child: Text("ML Output"),
      ),
    );
  }
}
