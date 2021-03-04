import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fueler/model/app-state.model.dart';
import 'package:fueler/pages/dashboard/refueling-item.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final refuelings = model.getAllRefuelings();
        return CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text("Übersicht"),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return RefuelingItem(
                    item: refuelings[index],
                    isLastItem: index + 1 == refuelings.length,
                  );
                },
                childCount: refuelings.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
