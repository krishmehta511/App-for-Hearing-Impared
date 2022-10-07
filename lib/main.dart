import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/main_screen.dart';
import 'screens/add_audio_screen.dart';
import 'screens/ml_ouput.dart';

import 'providers/audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AudioClassification()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyApp',
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        home: FutureBuilder(
          future: _fbapp,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const MainScreen();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        routes: {
          MainScreen.routeName: (ctx) => const MainScreen(),
          AddAudio.routeName: (ctx) => const AddAudio(),
          MLOutput.routeName: (ctx) => const MLOutput(),
        },
      ),
    );
  }
}
