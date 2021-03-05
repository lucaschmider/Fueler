import 'package:flutter/foundation.dart' as foundation;
import 'package:fueler/model/refueling.model.dart';

class AppStateModel extends foundation.ChangeNotifier {
  List<Refueling> _refuelings = List();

  List<Refueling> getAllRefuelings() => _refuelings.sublist(0);
  void registerRefueling(Refueling refueling) {
    _refuelings.add(refueling);
    _refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }
}
