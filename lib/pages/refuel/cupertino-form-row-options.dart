import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CupertinoFormRowOptions<TValue> extends StatefulWidget {
  final Widget header;
  final Map<TValue, Widget> values;
  final Function(TValue) onChanged;
  final TValue defaultValue;

  const CupertinoFormRowOptions(
      {Key key, this.header, this.values, this.onChanged, this.defaultValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CupertinoFormRowOptionsState<TValue>(defaultValue);
}

class _CupertinoFormRowOptionsState<TValue>
    extends State<CupertinoFormRowOptions> {
  TValue _currentValue;

  _CupertinoFormRowOptionsState(TValue defaultValue) {
    _currentValue = defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      header: widget.header,
      children: widget.values.entries
          .map(
            (e) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _currentValue = e.key;
                });
                widget.onChanged.call(e.key);
              },
              child: CupertinoFormRow(
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(e.key == _currentValue
                            ? CupertinoIcons.check_mark
                            : null),
                      ),
                      e.value
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
