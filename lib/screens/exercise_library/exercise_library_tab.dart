import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/auth/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/screens/exercise_library/exercise_list_item.dart';
import 'package:liftlogmobile/widgets/navigation_bar_text.dart';

import 'add_exercise_item.dart';

class ExerciseLibraryTab extends StatefulWidget {
  Function _reloadExercises;
  List<Exercise> _exercises;

  ExerciseLibraryTab(this._reloadExercises, this._exercises);

  @override
  State<ExerciseLibraryTab> createState() => _ExerciseLibraryTabState();
}

class _ExerciseLibraryTabState extends State<ExerciseLibraryTab> {
  bool _showSearch = false;
  String _searchText = "";
  TextEditingController _searchTextController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Widget _navigationBarLeadingWidget() {
    return _showSearch
        ? Container(width: 0)
        : GestureDetector(
            child: Icon(CupertinoIcons.search),
            onTap: () {
              setState(() {
                _showSearch = true;
                _focusNode.requestFocus();
              });
            },
          );
  }

  Widget _navigationBarMiddleWidget() {
    return _showSearch
        ? CupertinoSearchTextField(
            focusNode: _focusNode,
            controller: _searchTextController,
            onChanged: (String searchText) {
              setState(() {
                _searchText = searchText;
              });
            },
          )
        : navigationBarTitle(context, "My Exercises");
  }

  Widget _logoutButton(BuildContext context) {
    return navigationBarTextButton(
      context,
      "Logout",
      () async {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    "Confirm",
                  ),
                  onPressed: () async {
                    await LocalStorageService.removeSavedUser();
                    CupertinoPageRoute backToLoginRoute =
                        CupertinoPageRoute(builder: (context) => LoginScreen());
                    Navigator.pushReplacement(context, backToLoginRoute);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _navigationBarTrailingWidget() {
    return _showSearch
        ? Padding(
            padding: EdgeInsets.only(left: 8),
            child: navigationBarTextButton(context, "Cancel", () {
              setState(() {
                _focusNode.unfocus();
                _searchTextController.clear();
                _searchText = "";
                _showSearch = false;
              });
            }),
          )
        : _logoutButton(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: _navigationBarLeadingWidget(),
        middle: _navigationBarMiddleWidget(),
        trailing: _navigationBarTrailingWidget(),
      ),
      child: SafeArea(
        top: true,
        child: ListView(
          children: <Widget>[AddExerciseItem(widget._reloadExercises)] +
              widget._exercises
                  .where((Exercise element) {
                    return element.name.toLowerCase().contains(_searchText);
                  })
                  .map((ex) => ExerciseListItem(ex, widget._reloadExercises))
                  .toList(),
        ),
      ),
    );
  }
}
