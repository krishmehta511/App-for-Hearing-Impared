import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Transcribe extends StatefulWidget {
  const Transcribe({Key? key}) : super(key: key);

  @override
  State<Transcribe> createState() => _TranscribeState();
}

class _TranscribeState extends State<Transcribe> {
  SpeechToText speechToText = SpeechToText();
  bool _status = false;
  bool _permissionStatus = false;
  bool _isRecording = false;
  double _fontSize = 20;
  String _selectedLanguage = "en";

  String _transcribedText = "Hold the mic to start listening";

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    initSpeech();
    super.initState();
  }

  Future<void> initSpeech() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Permission Not Granted.";
    }
    _permissionStatus = true;
    _status = await speechToText.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            height: height * 0.4,
            width: width,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
                Text(
                  "Transcribed Text",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                SizedBox(
                  height: height * 0.33,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          _transcribedText,
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: _transcribedText ==
                                        "Hold the mic to start listening" ||
                                    _transcribedText ==
                                        "सुनना शुरू करने के लिए माइक को पकड़ें"
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: height * 0.1,
            width: width,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTapDown: (_) async {
                    if (_permissionStatus && !_isRecording) {
                      if (_status) {
                        setState(() {
                          _isRecording = true;
                          speechToText.listen(
                              localeId: _selectedLanguage,
                              onResult: (result) {
                                setState(() {
                                  _transcribedText = result.recognizedWords;
                                });
                              });
                        });
                      }
                    } else {
                      await initSpeech();
                    }
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isRecording = false;
                    });
                    speechToText.stop();
                  },
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_off,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _transcribedText = _selectedLanguage == "en"
                          ? "Hold the mic to start listening"
                          : "सुनना शुरू करने के लिए माइक को पकड़ें";
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedLanguage == "en") {
                        _selectedLanguage = "hi";
                        _transcribedText =
                            "सुनना शुरू करने के लिए माइक को पकड़ें";
                      } else {
                        _selectedLanguage = "en";
                        _transcribedText = "Hold the mic to start listening";
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.language,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_fontSize == 30) return;
                      _fontSize++;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: _fontSize < 30
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_fontSize == 15) return;
                      _fontSize--;
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    size: 30,
                    color: _fontSize > 15
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: height * 0.4,
            width: width,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
                Text(
                  "Typed Text",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                SizedBox(
                  height: height * 0.3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controller,
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Tap to enter text",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
