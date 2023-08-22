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
  int _seconds1 = (0*3600 + 1*60 + 12)*100;  // in Hundertstel
  int _seconds2 = (3*3600 + 15*60 + 12)*100;  // in Hundertstel

  bool _isButton1Disabled = true;
  bool _isButton2Disabled = false;

  int tapped = 1;

  // The state of the timer (running or not)
  // bool _isRunning1 = false;
  // bool _isRunning2 = false;

// Time formatting
  String showTime(int n) {
    if (n < 6000 ){
      n = n ~/10;
      return (n/10).toStringAsFixed(1);
    }
    else if (n < 360000) {
      n = n ~/100;
      int minutes = n ~/ 60;
      int seconds = n - (minutes * 60);
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    }
    else {
      n = n ~/100;
      int hours = n ~/ 3600;
      int minutes = (n - hours * 3600) ~/ 60;
      int seconds = n - hours * 3600 - minutes*60;
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }




// **** Timer
  // The timers
  Timer? _timer1;
  Timer? _timer2;

  // Start the timers
  // The timer will run every hundreth of a second
  // The timer will stop when the seconds are 0

  void _startTimer1() {
    setState(() {
      // _isRunning1 = true;
    });
    _timer1 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_seconds1 > 0) {
          _seconds1--;
        } else {
          // _isRunning1 = false;
          _timer1?.cancel();
            }
      });
    });
  }


  void _startTimer2() {
    setState(() {
      // _isRunning2 = true;
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_seconds2 > 0) {
          _seconds2--;
        } else {
          // _isRunning2 = false;
          _timer2?.cancel();
        }
      });
    });
  }

  // Pause the timers
  void _pauseTimer1() {
    setState(() {
      // _isRunning1 = false;
    });
    _timer1?.cancel();
  }

  void _pauseTimer2() {
    setState(() {
      // _isRunning2 = false;
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
                                setState(() {tapped = 1;});
                              }
                              else {null;}
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(120, 30, 120, 30),
                              backgroundColor: tapped == 1 ? Colors.grey : Colors.blue,
                              minimumSize: const Size(420,100),
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
                                setState(() {tapped = 2;});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(120, 30, 120, 30),
                              backgroundColor: tapped == 2 ? Colors.grey : Colors.blue,
                              minimumSize: const Size(420,100),
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
                          Container(
                            alignment: Alignment.center,
                            height: 120,
                            width: 420,
                              decoration: BoxDecoration(
                                color: _seconds1 == 0 ? Colors.red :  Colors.black ,
                                // Red border with the width is equal to 5
                                //border: Border.all(
                                    //width: 2,
                                    //color: Colors.blue
                                // ),
                                ),
                            child:
                              Text(
                                showTime(_seconds1).padLeft(2, '0'),
                                style: const TextStyle(
                                    fontSize: 100,
                                    color: Colors.white, ),
                              )
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 120,
                            width: 420,
                            decoration: BoxDecoration(
                                color: _seconds2 == 0 ? Colors.red :  Colors.black ,
                                // Red border with the width is equal to 5
                                // border: Border.all(
                                    // width: 2,
                                    // color: Colors.blue
                                //),
                            ),
                            child:
                              Text(
                                showTime(_seconds2).padLeft(2, '0'),
                                style: const TextStyle(
                                    fontSize: 100,
                                    color: Colors.white),
                              ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                        ElevatedButton(
                           onPressed: () {
                               _pauseTimer2();
                               _pauseTimer1();
                               setState(() {
                                 tapped = 0;

                               });
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

