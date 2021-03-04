import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NavigationService {
  void openRefuelingDialog(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => CupertinoPageScaffold(
        child: Container(
          alignment: Alignment.center,
          child: Text("Hallo, Welt"),
        ),
      ),
    );
  }
}

final navigationService = NavigationService();
