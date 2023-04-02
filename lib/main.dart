import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/main_screen.dart';

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
          backgroundColor: const Color.fromRGBO(40, 51, 63, 1),
          primaryColor: Colors.white,
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      ),
    );
  }
}
