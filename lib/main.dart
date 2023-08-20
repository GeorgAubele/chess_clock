import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(VerticalTabsNavigationApp());
}

class VerticalTabsNavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: VerticalTabsNavigationScreen(),
    );
  }
}

class VerticalTabsNavigationScreen extends StatefulWidget {
  @override
  _VerticalTabsNavigationScreenState createState() =>
      _VerticalTabsNavigationScreenState();
}

class _VerticalTabsNavigationScreenState
    extends State<VerticalTabsNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vertical Tabs Navigation Example'),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          Container(
            color: Colors.black,
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              backgroundColor: Colors.black,
              unselectedIconTheme: IconThemeData(color: Colors.grey),
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
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
          VerticalDivider(thickness: 1, width: 1),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Spieler rechts',
                              style: TextStyle(fontSize: 30),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(80, 30, 80, 30),
                            ),
                          ),
                          // SizedBox(width: 150),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Spieler links',
                              style: TextStyle(fontSize: 30),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(80, 30, 80, 30),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TimerWidget(
                            duration: Duration(hours: 1, minutes: 30),
                          ),
                          //SizedBox(width: 90), // Erhöhe den horizontalen Abstand
                          TimerWidget(
                            duration: Duration(hours: 1, minutes: 30),
                          ),
                        ],
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: Center(
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

class TimerWidget extends StatefulWidget {
  final Duration duration;

  TimerWidget({required this.duration});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  Duration _currentTime = Duration();

  @override
  void initState() {
    super.initState();
    _currentTime = widget.duration;
    _timer = Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  void _updateTime(Timer timer) {
    if (_currentTime.inSeconds > 0) {
      setState(() {
        _currentTime -= Duration(seconds: 1);
      });
    } else {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${_currentTime.inHours.toString().padLeft(2, '0')}:${(_currentTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.white, fontSize: 80),
        ),
      ],
    );
  }
}
