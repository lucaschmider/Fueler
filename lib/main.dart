import 'package:flutter/cupertino.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  initializeDateFormatting("de", null);
  initializeDateFormatting("de_DE", null);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (_) => AppStateModel()..initializeAsync(),
    child: FuelerApp(),
  ));
}
