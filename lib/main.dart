import 'package:flutter/cupertino.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppStateModel()
      ..registerRefueling(Refueling.capture(12, 14, DateTime.now()))
      ..registerRefueling(Refueling.capture(16, 20, DateTime.now())),
    child: FuelerApp(),
  ));
}
