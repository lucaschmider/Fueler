import 'package:flutter/foundation.dart' as foundation;
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/repositories/refuelings.repository.dart';

class AppStateModel extends foundation.ChangeNotifier {
  Map<String, Refueling> _refuelings = Map<String, Refueling>();

  List<Refueling> getAllRefuelings() {
    var refuelings = _refuelings.values.toList();
    refuelings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return refuelings;
  }

  Future<void> registerRefueling(
      Refueling refueling, double previouslyTraveledDistance) async {
    if (previouslyTraveledDistance != null) {
      var lastRefuelingId = _refuelings.values
          .where((element) => element.fuelType == refueling.fuelType)
          .reduce((accumulator, element) =>
              accumulator.timestamp.compareTo(element.timestamp) < 0
                  ? element
                  : accumulator)
          .refuelingId;

      await refuelingsRepository.addDistanceToRefueling(
          lastRefuelingId, previouslyTraveledDistance);

      _refuelings.update(lastRefuelingId, (value) {
        value.distance = previouslyTraveledDistance;
        return value;
      });
    }

    await refuelingsRepository.saveRefuelingAsync(refueling);
    _refuelings.putIfAbsent(refueling.refuelingId, () => refueling);

    notifyListeners();
  }

  Future<void> initializeAsync() async {
    var refuelings = await refuelingsRepository.getAllRefuelingsAsync();
    _refuelings.clear();
    _refuelings.addEntries(refuelings.map((e) => MapEntry(e.refuelingId, e)));
    notifyListeners();
  }
}
