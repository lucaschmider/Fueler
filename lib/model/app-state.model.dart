import 'package:flutter/foundation.dart' as foundation;
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/repositories/refuelings.repository.dart';

class AppStateModel extends foundation.ChangeNotifier {
  Map<String, Refueling> _refuelings = {};

  List<Refueling> getAllRefuelings() {
    var refuelings = _refuelings.values.toList();
    refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return refuelings;
  }

  Future<void> registerRefueling(
      Refueling refueling, double traveledDistance) async {
    var existingRefuelingsOfType = _refuelings.values
        .where((element) => element.fuelType == refueling.fuelType);

    if (traveledDistance != null && existingRefuelingsOfType.length > 0) {
      var lastRefuelingOfType = existingRefuelingsOfType.reduce(
          (accumulator, element) =>
              accumulator.timestamp.compareTo(element.timestamp) < 0
                  ? element
                  : accumulator);
      lastRefuelingOfType.complete(traveledDistance);
      await refuelingsRepository.updateRefuelingAsync(lastRefuelingOfType);
    }

    _refuelings.putIfAbsent(refueling.refuelingId, () => refueling);
    await refuelingsRepository.saveRefuelingAsync(refueling);

    notifyListeners();
  }

  Future<void> initializeAsync() async {
    var refuelings = await refuelingsRepository.getAllRefuelingsAsync();

    refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _refuelings = Map.fromIterable(refuelings, key: (r) => r.refuelingId);
    notifyListeners();
  }

  Future<void> deleteRefueling(String refuelingId) async {
    await refuelingsRepository.removeRefuelingAsync(refuelingId);
    _refuelings.remove(refuelingId);
    notifyListeners();
  }
}
