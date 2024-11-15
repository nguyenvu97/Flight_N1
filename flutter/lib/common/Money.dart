import 'package:intl/intl.dart';

class MoneyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN', // Định dạng cho Việt Nam
    symbol: '₫', // Ký hiệu tiền tệ của Việt Nam
    decimalDigits: 0, // Không cần chữ số thập phân
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }
}
