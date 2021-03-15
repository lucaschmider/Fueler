import 'package:flutter/cupertino.dart';
import 'package:fueler/pages/refuel/refuel-main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NavigationService {
  void openRefuelingDialog(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (context) => RefuelMain(),
    );
  }
}

final navigationService = NavigationService();
