import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
        final refuelings = model.getAllRefuelings();
        final historyItems = createHistoryItems(refuelings);
        final items = [
          SummaryCard(refuelings: refuelings),
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

  List<Widget> createHistoryItems(List<Refueling> refuelings) {
    return groupBy<Refueling, DateTime>(
            refuelings, (r) => DateTime(r.timestamp.year, r.timestamp.month))
        .entries
        .fold<List<Widget>>(<Widget>[], (accumulator, element) {
      accumulator.add(
        RefuelingGroupHeader(
          commonTimestamp: element.key,
          childCount: element.value.length,
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

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    Key key,
    @required this.refuelings,
  }) : super(key: key);

  final List<Refueling> refuelings;

  List<Widget> buildSummaryRows(List<Refueling> refuelings) {
    return groupBy<Refueling, FuelType>(refuelings, (r) => r.fuelType)
        .entries
        .map((element) {
      final cumulatedRange = element.value
          .map((e) => e.traveledDistance)
          .reduce((accumulator, currentRange) => accumulator + currentRange);
      final meanRange = cumulatedRange / element.value.length;

      final cumulatedPricePerKilometer = element.value
          .map((e) => e.price / e.traveledDistance)
          .reduce((accumulator, currentPricePerKilometer) =>
              accumulator + currentPricePerKilometer);
      final meanPricePerKilometer =
          cumulatedPricePerKilometer / element.value.length;

      return SummaryRow(
        fuelType: element.key,
        meanRange: meanRange.round(),
        pricePerKilometer: meanPricePerKilometer,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final relevantRefuelings = refuelings
        .where((element) => element.traveledDistance != null)
        .toList();
    if (relevantRefuelings.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        color: CupertinoTheme.of(context).barBackgroundColor,
        elevation: 14,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: buildSummaryRows(relevantRefuelings),
          ),
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final FuelType fuelType;
  final int meanRange;
  final double pricePerKilometer;

  const SummaryRow({
    Key key,
    @required this.fuelType,
    @required this.meanRange,
    @required this.pricePerKilometer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final centsPerKilometer = (100 * pricePerKilometer).round();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          FuelTypeIcon(type: fuelType),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Etwa ${meanRange}km Reichweite",
                      style: Styles.dashboardRowTitle.copyWith(
                          color: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .color)),
                  Text(
                    "Ungefähr $centsPerKilometer Cent pro Kilometer",
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
}

enum RowPosition { First, Last, Intermediate }
