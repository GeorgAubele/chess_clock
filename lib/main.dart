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
  int _seconds1 = (3*3600 + 15*60 + 12)*100;  // in Hundertstel
  int _seconds2 = (3*3600 + 15*60 + 12)*100;  // in Hundertstel

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
        } else {
          _isRunning1 = false;
          _timer1?.cancel();
            }
      });
    });
  }

  String show_time(int n) {
    if (n < 6000 ){
      n = n ~/10;
      return (n/10).toStringAsFixed(1);
    }
    else if (n < 360000) {
      n = n ~/100;
      int _minutes = n ~/ 60;
      int _seconds = n - (_minutes * 60);
      return "${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}";

    }
    else {
      n = n ~/100;
      int _hours = n ~/ 3600;
      int _minutes = (n - _hours * 3600) ~/ 60;
      int _seconds = n - _hours * 3600 - _minutes*60;
      return "${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}";
    }
  }

  void _startTimer2() {
    setState(() {
      _isRunning2 = true;
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_seconds2 > 0) {
          _seconds2--;
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
                            show_time(_seconds1).padLeft(2, '0'),
                            style: const TextStyle(
                                fontSize: 100,
                                color: Colors.white, ),
                          ),
                          Text(
                            show_time(_seconds2).padLeft(2, '0'),
                            style: const TextStyle(
                                fontSize: 100,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                        ElevatedButton(
                           onPressed: () {
                               _pauseTimer2();
                               _pauseTimer1();
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.green,
                             padding: const EdgeInsets.fromLTRB(80, 30, 80, 30),
                           ),
                           child: const Text(
                             'Pause',
                             style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                      ),
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

