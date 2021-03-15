import 'package:intl/intl.dart';

class TextService {
  String getRefuelingTitleLine(double amount, double price) =>
      "$amount Liter für $price€";
  String getRefuelingSubtitle(
      DateTime timestamp, double traveledDistance, double price) {
    final dateString = DateFormat.yMMMMd("de_DE").format(timestamp);
    final pricePerKilometerString = traveledDistance != null
        ? " (${(price / traveledDistance).toStringAsPrecision(1)} €/km)"
        : "";

    return "Am $dateString$pricePerKilometerString";
  }

  String getRefuelingGroupTitle(DateTime commonTimestamp) =>
      DateFormat.yMMMM("de_DE").format(commonTimestamp);
}

final TextService textService = TextService();
