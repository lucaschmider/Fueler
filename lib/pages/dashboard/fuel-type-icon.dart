import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/styles.dart';

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
        child: Text(
          this._texts[this.type] ?? "",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w300, color: Colors.white),
        ),
        height: 40,
        width: 76,
        color: Styles.fuelColors[this.type],
        alignment: Alignment.center,
      ),
    );
  }
}
