import 'package:intl/intl.dart';

class TextService {
  String getRefuelingTitleLine(double amount, double price) =>
      "$amount Liter für $price€";
  String getRefuelingSubtitle(
          DateTime timestamp, double amount, double price) =>
      "Am ${DateFormat.yMMMMd("de_DE").format(timestamp)} (${(price / amount).toStringAsPrecision(3)} €/L)";
}

final TextService textService = TextService();