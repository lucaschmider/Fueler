import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';

abstract class Styles {
  static const TextStyle dashboardRowTitle = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle dashboardRowSubtitle = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const Color listItemDivider = Color(0xFFD9D9D9);

  static const Map<FuelType, Color> fuelColors = {
    FuelType.Diesel: Color.fromRGBO(0, 0, 0, 1.0),
    FuelType.Gazoline10: Color.fromRGBO(46, 82, 104, 1.0),
    FuelType.Gazoline5: Color.fromRGBO(112, 146, 85, 1.0)
  };
}
