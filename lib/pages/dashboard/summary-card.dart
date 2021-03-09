import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/pages/dashboard/fuel-type-icon.dart';

class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Zusammenfassung",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
              ),
              Row(
                children: [
                  FuelTypeIcon(type: FuelType.Gazoline5),
                  Text("10km/€"),
                  Text("300km/Füllung")
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
