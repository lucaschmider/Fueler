import 'package:flutter/cupertino.dart';
import 'package:fueler/services/uuid.service.dart';

class Refueling {
  Refueling(
      {@required this.refuelingId,
      @required this.amount,
      @required this.price,
      @required this.fuelType,
      @required this.timestamp,
      double traveledDistance})
      : assert(refuelingId != null),
        assert(amount > 0),
        assert(price > 0),
        assert(fuelType != null),
        assert(timestamp != null) {
    _traveledDistance = traveledDistance;
  }

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

  /// The day the refueling has occured
  final DateTime timestamp;

  /// The type of fuel
  final FuelType fuelType;

  /// The distance traveld with this refueling
  double _traveledDistance;
  double get traveledDistance => _traveledDistance;

  /// Completes the refueling by setting remaining information
  void complete(double traveledDistance) {
    if (isCompleted) {
      throw new RefuelingChangedAfterItWasCompletedError();
    }

    _traveledDistance = traveledDistance;
  }

  bool get isCompleted => _traveledDistance != null;

  Map<String, dynamic> toMap() {
    return {
      "refuelingId": refuelingId,
      "amount": amount,
      "price": price,
      "timestamp": timestamp.toString(),
      "fuelType": fuelType.index,
      "traveledDistance": _traveledDistance
    };
  }
}

enum FuelType { Gazoline5, Gazoline10, Diesel }

class RefuelingChangedAfterItWasCompletedError extends Error {}
