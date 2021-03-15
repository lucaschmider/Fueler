import 'package:flutter/cupertino.dart';
import 'package:fueler/services/text.service.dart';

class RefuelingGroupHeader extends StatelessWidget {
  final DateTime commonTimestamp;

  const RefuelingGroupHeader({Key key, this.commonTimestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Text(
        textService.getRefuelingGroupTitle(commonTimestamp),
        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
      ),
    );
  }
}
