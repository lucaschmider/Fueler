import 'package:flutter/cupertino.dart';
import 'package:fueler/services/text.service.dart';
import 'package:fueler/styles.dart';

class RefuelingGroupHeader extends StatelessWidget {
  final DateTime commonTimestamp;
  final int childCount;

  const RefuelingGroupHeader(
      {Key key, @required this.commonTimestamp, @required this.childCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textService.getRefuelingGroupTitle(commonTimestamp),
            style: theme.textTheme.navTitleTextStyle,
          ),
          Text(
            "$childCount Vorgänge",
            style: theme.textTheme.navTitleTextStyle
                .copyWith(color: Styles.dashboardRowSubtitle.color),
          )
        ],
      ),
    );
  }
}
