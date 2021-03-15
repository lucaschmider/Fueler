import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:provider/provider.dart';

import 'cupertino-form-row-options.dart';

class RefuelMain extends StatefulWidget {
  @override
  _RefuelMainState createState() => _RefuelMainState();
}

class _RefuelMainState extends State<RefuelMain> {
  FuelType _fuelType = FuelType.Gazoline5;
  double _amount = 0;
  double _totalPrice = 0;
  double _traveledDistance;

  bool _isDisabled() =>
      _amount == null ||
      _amount <= 0 ||
      _totalPrice == null ||
      _totalPrice <= 0;

  @override
  Widget build(BuildContext context) {
    final currentTheme = CupertinoTheme.of(context);
    final currentBrightness = CupertinoTheme.brightnessOf(context);
    final pageBackground = currentBrightness == Brightness.dark
        ? CupertinoColors.black
        : CupertinoColors.systemGroupedBackground;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Nachtanken"),
      ),
      resizeToAvoidBottomInset: false,
      child: SafeArea(
        child: Container(
          color: pageBackground,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  CupertinoFormRowOptions(
                    header: Text("Kraftstoff"),
                    values: {
                      FuelType.Gazoline5: Text(
                        "Super E5",
                        style: currentTheme.textTheme.textStyle,
                      ),
                      FuelType.Gazoline10: Text(
                        "Super E10",
                        style: currentTheme.textTheme.textStyle,
                      ),
                      FuelType.Diesel: Text(
                        "Diesel",
                        style: currentTheme.textTheme.textStyle,
                      ),
                    },
                    onChanged: (type) => setState(() {
                      _fuelType = type;
                    }),
                    defaultValue: FuelType.Gazoline5,
                  ),
                  CupertinoFormSection(
                    header: Text("Letzte Füllung"),
                    children: [
                      CupertinoTextFormFieldRow(
                        prefix: Text("Kilometerstand"),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        onChanged: (value) => setState(() {
                          var parsedValue =
                              double.tryParse(value.replaceAll(",", "."));
                          _traveledDistance =
                              parsedValue == 0 ? null : parsedValue;
                        }),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  CupertinoFormSection(
                    header: Text("Allgemeine Informationen"),
                    children: [
                      CupertinoTextFormFieldRow(
                        prefix: Text("Menge"),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        onChanged: (value) => setState(() {
                          _amount = double.tryParse(value.replaceAll(",", "."));
                        }),
                        textAlign: TextAlign.end,
                      ),
                      CupertinoTextFormFieldRow(
                        prefix: Text("Preis"),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        onChanged: (value) => setState(() {
                          _totalPrice =
                              double.tryParse(value.replaceAll(",", "."));
                        }),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: CupertinoButton.filled(
                        child: Text(
                          "Tanken",
                        ),
                        onPressed: _isDisabled()
                            ? null
                            : () async {
                                var provider = Provider.of<AppStateModel>(
                                    context,
                                    listen: false);
                                var refueling = Refueling.capture(
                                    _amount, _totalPrice, _fuelType);

                                await provider.registerRefueling(
                                    refueling, _traveledDistance);
                                Navigator.pop(context);
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
