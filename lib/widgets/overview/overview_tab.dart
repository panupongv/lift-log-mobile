import 'package:flutter/widgets.dart';
import 'package:liftlogmobile/utils/styles.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Overview",
      style: Styles.dialogTitle(context),
    );
  }
}
