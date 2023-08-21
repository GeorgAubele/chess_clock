import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(const ChessClockApp());
}

class ChessClockApp extends StatelessWidget {
  const ChessClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ChessClockScreen(),
    );
  }
}

class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key});

  @override
  _ChessClockScreenState createState() =>
      _ChessClockScreenState();
}

// ********** State ***********************

class _ChessClockScreenState extends State<ChessClockScreen> {

// ***** Variables
  int _selectedIndex = 0;
  int _seconds1 = 5500;  // in Hundertstel
  double _time1 = 55.0;
  int _seconds2 = 5500;  // in Hundertstel
  double _time2 = 55.0;
  bool _isButton1Disabled = false;
  bool _isButton2Disabled = true;

  // The state of the timer (running or not)
  bool _isRunning1 = false;
  bool _isRunning2 = false;

// **** Timer
  // The timers
  Timer? _timer1;
  Timer? _timer2;

  // Start the timers
  // The timer will run every hundreth of a second
  // The timer will stop when the seconds are 0

  void _startTimer1() {
    setState(() {
      _isRunning1 = true;
    });
    _timer1 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_seconds1 > 0) {
          _seconds1--;
          _time1 = _seconds1/10;
          _time1 = _time1.floorToDouble();
          _time1 = _time1/10;
        } else {
          _isRunning1 = false;
          _timer1?.cancel();
            }
      });
    });
  }

  void _startTimer2() {
    setState(() {
      _isRunning2 = true;
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_seconds2 > 0) {
          _seconds2--;
          _time2 = _seconds2/10;
          _time2 = _time2.floorToDouble();
          _time2 = _time2/10;
        } else {
          _isRunning2 = false;
          _timer2?.cancel();
        }
      });
    });
  }

  // Pause the timers
  void _pauseTimer1() {
    setState(() {
      _isRunning1 = false;
    });
    _timer1?.cancel();
  }

  void _pauseTimer2() {
    setState(() {
      _isRunning2 = false;
    });
    _timer2?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Clock V 0.0.1'),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          Container(
            color: Colors.black,
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              backgroundColor: Colors.black,
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home, color: Colors.white),
                  label: Text('Tab 1'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(Icons.settings, color: Colors.white),
                  label: Text('Tab 2'),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
// *********  Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (! _isButton1Disabled) {
                                _startTimer2();
                                _pauseTimer1();
                                _isButton2Disabled = ! _isButton2Disabled;
                                _isButton1Disabled = ! _isButton1Disabled;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(80, 30, 80, 30),
                            ),
                            child: const Text(
                              'Spieler rechts',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          // SizedBox(width: 150),
                          ElevatedButton(
                            onPressed: () {
                              if (! _isButton2Disabled) {
                                _startTimer1();
                                _pauseTimer2();
                                _isButton1Disabled = ! _isButton1Disabled;
                                _isButton2Disabled = ! _isButton2Disabled;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(80, 30, 80, 30),
                            ),
                            child: const Text(
                              'Spieler links',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ],
                      ),
// ************** Timers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _time1.toString().padLeft(2, '0'),
                            style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white, ),
                          ),
                          Text(
                            _time2.toString().padLeft(2, '0'),
                            style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: const Center(
                      child: Text('Inhalt Tab 2',
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

