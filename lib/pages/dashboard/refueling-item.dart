import 'package:flutter/widgets.dart';
import 'package:fueler/model/refueling.model.dart';

class RefuelingItem extends StatefulWidget {
  final Refueling item;

  RefuelingItem({@required this.item}) : assert(item != null);

  @override
  _RefuelingItemState createState() => _RefuelingItemState();
}

class _RefuelingItemState extends State<RefuelingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.item.amount.toString() + " Liter"),
          Text(widget.item.amount.toString() + " Euro"),
        ],
      ),
    );
  }
}
