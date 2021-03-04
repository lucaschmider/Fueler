import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/pages/dashboard/fuel-type-icon.dart';
import 'package:fueler/services/text.service.dart';
import 'package:fueler/styles.dart';

class RefuelingItem extends StatefulWidget {
  final Refueling item;
  final bool isLastItem;

  RefuelingItem({@required this.item, @required this.isLastItem})
      : assert(item != null);

  @override
  _RefuelingItemState createState() => _RefuelingItemState();
}

class _RefuelingItemState extends State<RefuelingItem> {
  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: Row(
        children: [
          FuelTypeIcon(type: widget.item.fuelType),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textService.getRefuelingTitleLine(
                        widget.item.amount, widget.item.price),
                    style: Styles.productRowItemName,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    textService.getRefuelingSubtitle(widget.item.timestamp,
                        widget.item.amount, widget.item.price),
                    style: Styles.productRowItemPrice,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.isLastItem) return row;

    return Column(
      children: <Widget>[
        row,
        Container(
          height: 1,
          color: Styles.productRowDivider,
          margin: EdgeInsets.only(left: 8, right: 8),
        ),
      ],
    );
  }
}
