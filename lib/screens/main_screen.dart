import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

import '../widgets/audio_info_radar.dart';
import '../widgets/audio_list.dart';

import 'transcribe.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;

  bool _isInit = true;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      Provider.of<AudioClassification>(context).fetchAudio().then((value) {
        setState(() {});
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  static const List<List<Widget>> _widgetOptions = <List<Widget>>[
    [
      Spacer(),
      AudioInfoRadar(),
      SizedBox(height: 20),
      AudioList(),
      SizedBox(height: 10),
    ],
    [
      Spacer(),
      Transcribe(),
    ],
    [
      Spacer(),
      ProfileScreen(),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('MyApp'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: height,
          width: width,
          padding: const EdgeInsets.all(7),
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              ..._widgetOptions.elementAt(_selectedIndex),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transcribe),
            label: "Transcribe",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
          size: 25,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          size: 20,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        selectedItemColor: Colors.white,
      ),
    );
  }
}
