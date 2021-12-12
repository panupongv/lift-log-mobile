import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/auth/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/widgets/exercise_library/exercise_list_item.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

import 'add_exercise_item.dart';

class ExerciseLibraryTab extends StatefulWidget {
  final Function _reloadExercises;
  final Map<String, Exercise> _exerciseMap;

  ExerciseLibraryTab(this._reloadExercises, this._exerciseMap);

  @override
  State<ExerciseLibraryTab> createState() => _ExerciseLibraryTabState();
}

class _ExerciseLibraryTabState extends State<ExerciseLibraryTab> {
  bool _showSearch = false;
  String _searchText = "";
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Widget _navigationBarLeadingWidget() {
    return _showSearch
        ? Container(width: 0)
        : GestureDetector(
            child: const Icon(CupertinoIcons.search),
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
    bool loggingOut = false;
    return navigationBarTextButton(
      context,
      "Logout",
      () async {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "Logout",
                style: Styles.dialogTitle(context),
              ),
              content: Text(
                "Are you sure?",
                style: Styles.dialogContent(context),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    "Cancel",
                    style: Styles.dialogActionNormal(context),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Logout",
                    style: Styles.cautiousDialogAction(context, !loggingOut)
                  ),
                  onPressed: () async {
                    setState(() {
                      loggingOut = true;  
                    });
                    await LocalStorageService.removeSavedUser();
                    CupertinoPageRoute backToLoginRoute =
                        CupertinoPageRoute(builder: (context) => LoginScreen());
                    Navigator.pushReplacement(context, backToLoginRoute);
                    setState(() {
                      loggingOut = false;  
                    });
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
            padding: const EdgeInsets.only(left: 8),
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
      backgroundColor: Styles.defaultBackground(context),
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
              widget._exerciseMap.values
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
