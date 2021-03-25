import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/pages/dashboard/refueling-group-header.dart';
import 'package:fueler/pages/dashboard/refueling-item.dart';
import 'package:fueler/services/navigation.service.dart';
import 'package:fueler/styles.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

import 'fuel-type-icon.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final theme = CupertinoTheme.of(context);
        final refuelings = model.getAllRefuelings();
        final historyItems = createHistoryItems(refuelings);
        final items = [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              color: CupertinoTheme.of(context).barBackgroundColor,
              elevation: 14,
              child: Column(
                children: [
                  _buildSummary(context, FuelType.Gazoline5, RowPosition.First),
                  _buildSummary(
                      context, FuelType.Gazoline10, RowPosition.Intermediate),
                  _buildSummary(context, FuelType.Diesel, RowPosition.Last),
                ],
              ),
            ),
          ),
          ...historyItems,
        ];
        return CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              trailing: CupertinoButton(
                child: Icon(CupertinoIcons.add_circled_solid),
                padding: EdgeInsets.zero,
                onPressed: () => navigationService.openRefuelingDialog(context),
              ),
              largeTitle: Text("Übersicht"),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => items[index],
                childCount: items.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Padding _buildSummary(
      BuildContext context, FuelType type, RowPosition position) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: position == RowPosition.Last ? 24 : 8,
          left: 24,
          right: 24,
          top: position == RowPosition.First ? 24 : 8),
      child: Row(
        children: [
          FuelTypeIcon(type: type),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Etwa 325km Reichweite",
                      style: Styles.dashboardRowTitle.copyWith(
                          color: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .color)),
                  Text(
                    "Ungefähr 5 Cent pro Kilometer",
                    style: Styles.dashboardRowSubtitle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createHistoryItems(List<Refueling> refuelings) {
    return groupBy<Refueling, DateTime>(
            refuelings, (r) => DateTime(r.timestamp.year, r.timestamp.month))
        .entries
        .fold<List<Widget>>(<Widget>[], (accumulator, element) {
      accumulator.add(
        RefuelingGroupHeader(
          commonTimestamp: element.key,
        ),
      );
      accumulator.addAll(element.value.mapIndexed((index, e) => RefuelingItem(
            item: e,
            isLastItem: index == element.value.length - 1,
          )));
      return accumulator;
    });
  }
}

enum RowPosition { First, Last, Intermediate }
