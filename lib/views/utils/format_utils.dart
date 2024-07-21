import 'package:intl/intl.dart';

class FormatUtils {
  static String formatTanggal(String tanggal) {
    DateTime date = DateTime.parse(tanggal);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }

  static String formatTimestamp(String tanggal) {
    DateTime date = DateTime.parse(tanggal);
    return DateFormat('EEEE, dd MMMM yyyy hh:mm', 'id_ID').format(date);
  }
}
