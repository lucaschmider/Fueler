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

  bool _isDisabled(bool traveledDistanceAvailable) =>
      _amount == null ||
      _amount <= 0 ||
      _totalPrice == null ||
      _totalPrice <= 0 ||
      !_isTraveledDistanceValid(traveledDistanceAvailable);

  bool _isTraveledDistanceValid(bool traveledDistanceAvailable) =>
      !traveledDistanceAvailable ||
      _traveledDistance != null ||
      (_traveledDistance != null && _traveledDistance > 0);

  @override
  Widget build(BuildContext context) {
    final currentTheme = CupertinoTheme.of(context);
    final currentBrightness = CupertinoTheme.brightnessOf(context);
    final pageBackground = currentBrightness == Brightness.dark
        ? CupertinoColors.black
        : CupertinoColors.systemGroupedBackground;

    return Consumer<AppStateModel>(
      builder: (context, model, child) => CupertinoPageScaffold(
        backgroundColor: pageBackground,
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
                    buildFuelTypeSection(currentTheme),
                    buildLastRefuelingSection(model),
                    buildGeneralInformationSection(),
                    buildSubmitSection(model, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitSection(AppStateModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.maxFinite,
        child: CupertinoButton.filled(
          child: Text(
            "Tanken",
          ),
          onPressed:
              _isDisabled(model.hasAnyIncompleteRefuelingsOfType(_fuelType))
                  ? null
                  : () async {
                      var refueling =
                          Refueling.capture(_amount, _totalPrice, _fuelType);

                      await model.registerRefueling(
                          refueling, _traveledDistance);
                      Navigator.pop(context);
                    },
        ),
      ),
    );
  }

  CupertinoFormSection buildGeneralInformationSection() {
    return CupertinoFormSection(
      header: Text("Allgemeine Informationen"),
      children: [
        CupertinoTextFormFieldRow(
          prefix: Text("Menge"),
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: false),
          onChanged: (value) => setState(() {
            _amount = double.tryParse(value.replaceAll(",", "."));
          }),
          textAlign: TextAlign.end,
        ),
        CupertinoTextFormFieldRow(
          prefix: Text("Preis"),
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: false),
          onChanged: (value) => setState(() {
            _totalPrice = double.tryParse(value.replaceAll(",", "."));
          }),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget buildLastRefuelingSection(AppStateModel model) {
    if (!model.hasAnyIncompleteRefuelingsOfType(_fuelType)) return Container();
    return CupertinoFormSection(
      header: Text("Letzte Füllung"),
      children: [
        CupertinoTextFormFieldRow(
          prefix: Text("Kilometerstand"),
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: false),
          onChanged: (value) => setState(() {
            var parsedValue = double.tryParse(value.replaceAll(",", "."));
            _traveledDistance = parsedValue == 0 ? null : parsedValue;
          }),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget buildFuelTypeSection(CupertinoThemeData currentTheme) {
    return CupertinoFormRowOptions<FuelType>(
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
    );
  }
}
