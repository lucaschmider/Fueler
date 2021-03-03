import 'package:flutter/cupertino.dart';
import 'package:fueler/services/uuid.service.dart';

class Refueling {
  Refueling(
      {@required this.refuelingId,
      @required this.amount,
      @required this.price,
      @required this.timestamp})
      : assert(refuelingId != null),
        assert(amount > 0),
        assert(price > 0),
        assert(timestamp != null);

  Refueling.capture(this.amount, this.price, this.timestamp)
      : assert(amount > 0),
        assert(price > 0),
        assert(timestamp != null),
        refuelingId = uuidService.newUuid();

  /// The unique id of the refueling
  final String refuelingId;

  /// The amount (in liters) that have been refueled
  final double amount;

  /// The total price in the users currency
  final double price;

  /// The day the refueling has occured
  final DateTime timestamp;
}
