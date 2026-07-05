import 'package:intl/intl.dart';

class DateFormatterUtils {
  static String formatBuildDate(DateTime date) {
    // Formats like: 05 Jul 2027
    return DateFormat('dd MMM yyyy').format(date);
  }
}
