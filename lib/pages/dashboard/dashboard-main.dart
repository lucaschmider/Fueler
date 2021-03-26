import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/model/refueling.model.dart';
import 'package:fueler/pages/dashboard/refueling-group-header.dart';
import 'package:fueler/pages/dashboard/refueling-item.dart';
import 'package:fueler/pages/dashboard/summary-card.dart';
import 'package:fueler/services/navigation.service.dart';

import 'package:provider/provider.dart';
import "package:collection/collection.dart";

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
