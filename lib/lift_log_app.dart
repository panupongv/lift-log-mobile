import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/screens/authentication/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';

import 'models/user.dart';
import 'screens/overview/overview_tab.dart';
import 'screens/exercise_library/exercise_library_tab.dart';
import 'screens/log/log_tab.dart';

class LiftLogApp extends StatefulWidget {
  final User _user;
  const LiftLogApp(this._user, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<LiftLogApp> createState() => _LiftLogAppState(_user);
}

class _LiftLogAppState extends State<LiftLogApp> {
  User _user;
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey0 =
          GlobalKey<NavigatorState>(debugLabel: 'key0'),
      navigatorKey1 = GlobalKey<NavigatorState>(debugLabel: 'key1'),
      navigatorKey2 = GlobalKey<NavigatorState>(debugLabel: 'key2');

  _LiftLogAppState(this._user);

  final List<Widget> _tabs = [
    OverviewTab(),
    LogTab(),
    ExerciseLibraryTab(),
  ];

  Widget _build(BuildContext context) {
    return ListView(
      children: [
        CupertinoButton(
          onPressed: () async {
            await LocalStorageService.saveUser(User("Dis Username", "Tokennn"));
          },
          child: Text("save"),
        ),
        CupertinoButton(
          onPressed: () async {
            User? user = await LocalStorageService.loadSavedUser();
            if (user != null) {
              print(user.toJson());
            } else {
              print("No saved user");
            }
          },
          child: Text("load"),
        ),
        CupertinoButton(
          onPressed: () async {
            await LocalStorageService.removeSavedUser();
          },
          child: Text("clear"),
        ),
        CupertinoButton(
          onPressed: () async {
            await LocalStorageService.removeSavedUser();
            CupertinoPageRoute backToLoginRoute =
                CupertinoPageRoute(builder: (context) => LoginScreen());
            Navigator.pushReplacement(context, backToLoginRoute);
          },
          child: Text("Logout"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: "Overview",
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: "Log",
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear),
            label: "Exercises",
          ),
        ],
        onTap: (int index) {
          if (_currentIndex == index) {
            switch (index) {
              case 0:
                navigatorKey0.currentState!.popUntil((Route r) => r.isFirst);
                break;
              case 1:
                navigatorKey1.currentState!.popUntil((Route r) => r.isFirst);
                break;
              case 2:
                navigatorKey2.currentState!.popUntil((Route r) => r.isFirst);
                break;
            }
          }
          _currentIndex = index;
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return _tabs[index];
      },
    );
  }
}
