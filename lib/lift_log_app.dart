import 'package:flutter/material.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';

import 'models/user.dart';
import 'screens/overview/overview_tab.dart';
import 'screens/exercise_library/exercise_library_tab.dart';
import 'screens/log/log_tab.dart';

class LiftLogApp extends StatefulWidget {
  //const LiftLogApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<LiftLogApp> createState() => _LiftLogAppState();
}

class _LiftLogAppState extends State<LiftLogApp> {
  int _currentTab = 0;
  final List<Widget> _tabs = [
    OverviewTab(),
    LogTab(),
    ExerciseLibraryTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListView(
        children: [
          TextButton(
            onPressed: () async {
              await LocalStorageService.saveUser(User("Dis Username", "Tokennn"));
            },
            child: Text("save"),
          ),

          TextButton(
            onPressed: () async {
              User? user = await LocalStorageService.loadSavedUser();
              print(user!.toJson());
            },
            child: Text("load"),
          ),

          TextButton(
            onPressed: () async {
              await LocalStorageService.removeSavedUser();
            },
            child: Text("clear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget _build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: _tabs,
          ),
        ),
      ),
    );
  }
}
