import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/repositories/refuelings.repository.dart';
import 'package:provider/provider.dart';

class RefuelMain extends StatefulWidget {
  @override
  _RefuelMainState createState() => _RefuelMainState();
}

class _RefuelMainState extends State<RefuelMain> {
  FuelType _fuelType = FuelType.Gazoline5;
  double _amount = 0;
  double _totalPrice = 0;
  TextEditingController _amountController;
  TextEditingController _priceController;

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
        CupertinoIcons.money_euro,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
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
      placeholder: "Preis",
      onChanged: (newPrice) {
        setState(() {
          return _totalPrice = double.tryParse(newPrice);
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _buildAmountField()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildTotalPriceField(),
              ),
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
                                .registerRefueling(newRefueling);

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
