import 'package:intl/intl.dart';

class AppFormat {
  static String date(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('d MMM yyyy', 'id_ID').format(dateTime);
  }

  static String currency(String number) {
    return NumberFormat.currency(
      decimalDigits: 2,
      locale: 'id_ID',
      symbol: 'Rp ',
    ).format(double.parse(number));
  }

}