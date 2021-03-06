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
          fuelType: fuelType,
          timestamp: timestamp,
          traveledDistance: r["traveledDistance"]);
    });

    return refuelings.toList();
  }

  Future<void> saveRefuelingAsync(Refueling refueling) async {
    var database = await databaseService.getDatabaseAsync();
    await database.insert(_refuelingsTable, refueling.toMap());
  }

  Future<void> updateRefuelingAsync(Refueling refueling) async {
    var database = await databaseService.getDatabaseAsync();
    await database.update(
      _refuelingsTable,
      refueling.toMap(),
      where: "refuelingId = ?",
      whereArgs: [refueling.refuelingId],
    );
  }

  Future<void> removeRefuelingAsync(String refuelingId) async {
    var database = await databaseService.getDatabaseAsync();
    await database.delete(
      _refuelingsTable,
      where: "refuelingId = ?",
      whereArgs: [refuelingId],
    );
  }
}

RefuelingsRepository refuelingsRepository = RefuelingsRepository();
