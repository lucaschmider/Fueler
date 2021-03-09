import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/services/database.service.dart';

class RefuelingsRepository {
  final String _refuelingsTable = "refuelings";

  Future<List<Refueling>> getAllRefuelingsAsync() async {
    var database = await databaseService.getDatabaseAsync();
    var refuelings = (await database.query(_refuelingsTable)).map((r) {
      var fuelType = FuelType.values[r["fuelType"]];
      var timestamp = DateTime.parse(r["timestamp"]);

      return Refueling(
          refuelingId: r["refuelingId"],
          amount: r["amount"],
          price: r["price"],
          distance: r["distance"],
          fuelType: fuelType,
          timestamp: timestamp);
    });

    return refuelings.toList();
  }

  Future<void> saveRefuelingAsync(Refueling refueling) async {
    var database = await databaseService.getDatabaseAsync();
    await database.insert(_refuelingsTable, refueling.toMap());
  }

  Future<void> addDistanceToRefueling(
      String refuelingId, double distance) async {
    var database = await databaseService.getDatabaseAsync();
    await database.update(_refuelingsTable, {"distance": distance},
        where: "refuelingId = ?", whereArgs: [refuelingId]);
  }
}

RefuelingsRepository refuelingsRepository = RefuelingsRepository();
