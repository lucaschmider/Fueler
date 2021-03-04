import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';

class FuelTypeIcon extends StatelessWidget {
  final FuelType type;
  final Map<FuelType, String> _texts = {
    FuelType.Gazoline5: "E5",
    FuelType.Gazoline10: "E10",
    FuelType.Diesel: "D"
  };

  FuelTypeIcon({Key key, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        child: Text(this._texts[this.type] ?? ""),
        height: 76,
        width: 76,
        color: Colors.amber,
        alignment: Alignment.center,
      ),
    );
  }
}
