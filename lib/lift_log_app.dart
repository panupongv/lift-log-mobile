import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/services/api_service.dart';

import 'models/exercise.dart';
import 'widgets/overview/overview_tab.dart';
import 'widgets/exercise_library/exercise_library_tab.dart';
import 'widgets/log/log_tab.dart';

class LiftLogApp extends StatefulWidget {
  @override
  State<LiftLogApp> createState() => _LiftLogAppState();
}

class _LiftLogAppState extends State<LiftLogApp> {
  int _currentTabIndex = 0;
  Map<String, Exercise> _exerciseMap = Map<String, Exercise>();

  _LiftLogAppState();

  @override
  void initState() {
    _reloadExerciseList();
  }

  GlobalKey<NavigatorState> navigatorKey0 =
          GlobalKey<NavigatorState>(debugLabel: 'key0'),
      navigatorKey1 = GlobalKey<NavigatorState>(debugLabel: 'key1'),
      navigatorKey2 = GlobalKey<NavigatorState>(debugLabel: 'key2');

  void _reloadExerciseList() async {
    List<Exercise> updatedExercises = await APIService.getExercises();
    setState(() {
      _exerciseMap = {for (Exercise e in updatedExercises) e.id: e};
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: "Log",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "Profile",
          ),
        ],
        onTap: (int index) {
          if (_currentTabIndex == index) {
            switch (index) {
              case 0: navigatorKey0.currentState!.popUntil((Route r) => r.isFirst); break;
              case 1: navigatorKey1.currentState!.popUntil((Route r) => r.isFirst); break;
            }
          }
          _currentTabIndex = index;
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          navigatorKey: () {
            switch (index) {
              case 0:
                return navigatorKey0;
              case 1:
                return navigatorKey1;
              case 2:
                return navigatorKey2;
            }
          }(),
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return OverviewTab(_exerciseMap);
              case 1:
                return LogTab(_exerciseMap);
              case 2:
                return ExerciseLibraryTab(_reloadExerciseList, _exerciseMap);
              default:
                return const Text("Tab Unavailable");
            }
          },
        );
      },
    );
  }
}
