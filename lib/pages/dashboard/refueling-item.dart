import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/pages/dashboard/fuel-type-icon.dart';
import 'package:fueler/services/text.service.dart';
import 'package:fueler/styles.dart';
import 'package:provider/provider.dart';

class RefuelingItem extends StatefulWidget {
  final Refueling item;
  final bool isLastItem;

  RefuelingItem({@required this.item, @required this.isLastItem})
      : assert(item != null);

  @override
  _RefuelingItemState createState() => _RefuelingItemState();
}

class _RefuelingItemState extends State<RefuelingItem> {
  Widget _buildItem() {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 16,
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
                    style: Styles.dashboardRowTitle.copyWith(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    textService.getRefuelingSubtitle(widget.item.timestamp,
                        widget.item.traveledDistance, widget.item.price),
                    style: Styles.dashboardRowSubtitle,
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
          height: 0.4,
          color: CupertinoTheme.brightnessOf(context) == Brightness.dark
              ? CupertinoColors.secondarySystemGroupedBackground
              : CupertinoColors.black,
          margin: EdgeInsets.only(left: 16, right: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onDismissed: (_) => Provider.of<AppStateModel>(context, listen: false)
            .deleteRefueling(widget.item.refuelingId),
        confirmDismiss: (_) {
          HapticFeedback.mediumImpact();
          return Future.value(true);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.trash_fill,
                  color: CupertinoColors.white,
                ),
                Text(
                  "Löschen",
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ],
            ),
          ),
          color: CupertinoColors.destructiveRed,
        ),
        key: Key(widget.item.refuelingId),
        child: _buildItem());
  }
}
