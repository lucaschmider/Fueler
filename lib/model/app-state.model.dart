import 'package:flutter/foundation.dart' as foundation;
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/repositories/refuelings.repository.dart';

class AppStateModel extends foundation.ChangeNotifier {
  List<Refueling> _refuelings = List();

  List<Refueling> getAllRefuelings() => _refuelings.sublist(0);
  Future<void> registerRefueling(Refueling refueling) async {
    await refuelingsRepository.saveRefuelingAsync(refueling);

    _refuelings.add(refueling);
    _refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<void> initializeAsync() async {
    var refuelings = await refuelingsRepository.getAllRefuelingsAsync();

    refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _refuelings = refuelings;
    notifyListeners();
  }
}
