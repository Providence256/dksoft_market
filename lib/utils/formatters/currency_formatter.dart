import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String format(num amount) => _format.format(amount);
}
