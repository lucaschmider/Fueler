import 'package:flutter/cupertino.dart';
import 'package:fueler/services/uuid.service.dart';

class Refueling {
  Refueling(
      {@required this.refuelingId,
      @required this.amount,
      @required this.price,
      @required this.fuelType,
      @required this.timestamp,
      @required this.distance})
      : assert(refuelingId != null),
        assert(amount > 0),
        assert(price > 0),
        assert(fuelType != null),
        assert(distance > 0),
        assert(timestamp != null);

  Refueling.capture(this.amount, this.price, this.fuelType)
      : assert(amount > 0),
        assert(price > 0),
        assert(fuelType != null),
        refuelingId = uuidService.newUuid(),
        timestamp = DateTime.now();

  /// The unique id of the refueling
  final String refuelingId;

  /// The amount (in liters) that have been refueled
  final double amount;

  /// The total price in the users currency
  final double price;

  /// The distance traveld with this refueling (in kilometers)
  double distance;

  /// The day the refueling has occured
  final DateTime timestamp;

  /// The type of fuel
  final FuelType fuelType;

  Map<String, dynamic> toMap() {
    return {
      "refuelingId": refuelingId,
      "amount": amount,
      "price": price,
      "timestamp": timestamp.toString(),
      "fuelType": fuelType.index,
      "distance": distance
    };
  }
}

enum FuelType { Gazoline5, Gazoline10, Diesel }
