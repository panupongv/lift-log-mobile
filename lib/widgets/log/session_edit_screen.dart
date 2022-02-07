import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/quick_dialog.dart';

class SessionEditScreen extends StatefulWidget {
  Session? _session;

  SessionEditScreen(this._session);

  @override
  State<SessionEditScreen> createState() => _SessionEditScreenState();
}

class _SessionEditScreenState extends State<SessionEditScreen> {
  bool _saving = false;

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    if (widget._session != null) {
      _selectedDate = widget._session!.date;
      _nameController.text = widget._session!.name;
      _locationController.text = widget._session!.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets labelInsets = const EdgeInsets.only(left: 8, top: 20);
    EdgeInsets fieldInsets = const EdgeInsets.only(left: 8, right: 8, top: 8);

    Widget _datePicker() => Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Styles.datePicker(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                _selectedDate = newDate;
              },
            ),
          ),
        );

    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: navigationBarTitle(
            context, widget._session == null ? "New Session" : "Edit Session"),
        trailing: navigationBarTextButton(
          context,
          "Save",
          () async {
            if (_nameController.text == "") {
              await showCupertinoDialog(
                context: context,
                builder: (BuildContext buildContext) => quickAlertDialog(
                    buildContext,
                    "Error Saving",
                    "Please enter a valid session name.",
                    "Dismiss"),
              );
              return;
            }

            setState(() {
              _saving = true;
            });

            if (widget._session == null) {
              Session sessionToCreate = Session("", _nameController.text,
                  _selectedDate, _locationController.text);
              Session? createdSession =
                  await APIService.createSession(sessionToCreate);
              if (createdSession != null) {
                Navigator.pop(context, createdSession);
              } else {
                showCupertinoDialog(
                    context: context,
                    builder: (buildContext) => quickAlertDialog(
                        buildContext,
                        "Error Saving",
                        "Failed to create the session.",
                        "Dismiss"));
              }
            } else {
              Session updatedSession = Session(
                  widget._session!.id,
                  _nameController.text,
                  _selectedDate,
                  _locationController.text);
              bool isUpdateSuccessful =
                  await APIService.updateSession(updatedSession);
              if (isUpdateSuccessful) {
                Navigator.pop(context, updatedSession);
              } else {
                showCupertinoDialog(
                    context: context,
                    builder: (buildContext) => quickAlertDialog(
                        buildContext,
                        "Error Saving",
                        "Unable to update the session.",
                        "Dismiss"));
              }
            }

            setState(() {
              _saving = false;
            });
          },
          isActive: !_saving,
        ),
      ),
      child: SafeArea(
        top: true,
        child: ListView(
          children: [
            Padding(
              padding: labelInsets,
              child: Text("Session Name",
                  style: Styles.editSessionLabels(context)),
            ),
            Padding(
              padding: fieldInsets,
              child: CupertinoTextField(
                controller: _nameController,
              ),
            ),
            Padding(
              padding: labelInsets,
              child: Text("Location (Optional)",
                  style: Styles.editSessionLabels(context)),
            ),
            Padding(
              padding: fieldInsets,
              child: CupertinoTextField(
                controller: _locationController,
              ),
            ),
            Padding(
              padding: labelInsets,
              child: Text("Date", style: Styles.editSessionLabels(context)),
            ),
            _datePicker(),
          ],
        ),
      ),
    );
  }
}
