import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:provider/provider.dart';

class RefuelMain extends StatefulWidget {
  @override
  _RefuelMainState createState() => _RefuelMainState();
}

class _RefuelMainState extends State<RefuelMain> {
  FuelType _fuelType = FuelType.Gazoline5;
  double _amount = 0;
  double _totalPrice = 0;
  double _previouslyTraveledDistance;
  TextEditingController _amountController;
  TextEditingController _priceController;
  TextEditingController _distanceController;

  bool _isDisabled() =>
      _fuelType == null ||
      _amount == null ||
      _amount <= 0 ||
      _totalPrice == null ||
      _totalPrice <= 0;

  Widget _buildAmountField() {
    return CupertinoTextField(
      controller: _amountController,
      prefix: const Icon(
        CupertinoIcons.drop_fill,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      textAlign: TextAlign.end,
      suffix: Text("Liter"),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.number,
      autocorrect: false,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: "Menge",
      onChanged: (newAmount) {
        setState(() => _amount = double.tryParse(newAmount));
      },
    );
  }

  Widget _buildTotalPriceField() {
    return CupertinoTextField(
      controller: _priceController,
      prefix: const Icon(
        CupertinoIcons.creditcard_fill,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      suffix: Text("Euro"),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.number,
      autocorrect: false,
      textAlign: TextAlign.end,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: "Preis",
      onChanged: (newPrice) {
        setState(() {
          return _totalPrice = double.tryParse(newPrice);
        });
      },
    );
  }

  Widget _buildTraveledDistanceField() {
    return CupertinoTextField(
      controller: _distanceController,
      prefix: const Icon(
        CupertinoIcons.car_fill,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      suffix: Text("Kilometer"),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      autocorrect: false,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: "Strecke mit letzter Tankfüllung",
      onChanged: (previousDistance) {
        setState(() {
          return _previouslyTraveledDistance =
              double.tryParse(previousDistance);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          CupertinoNavigationBar(
            middle: Text("Nachtanken"),
            automaticallyImplyLeading: false,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: _fuelType,
                    children: {
                      FuelType.Gazoline5: Text("Super E5"),
                      FuelType.Gazoline10: Text("Super E10"),
                      FuelType.Diesel: Text("Diesel"),
                    },
                    onValueChanged: (fuelType) => setState(() {
                      _fuelType = fuelType;
                    }),
                  ),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _buildTraveledDistanceField()),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _buildAmountField()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildTotalPriceField(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: CupertinoButton.filled(
                    child: Text("Tanken"),
                    onPressed: _isDisabled()
                        ? null
                        : () async {
                            Refueling newRefueling = Refueling.capture(
                                _amount, _totalPrice, _fuelType);
                            Provider.of<AppStateModel>(context, listen: false)
                                .registerRefueling(
                                    newRefueling, _previouslyTraveledDistance);

                            Navigator.pop(context);
                          },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
