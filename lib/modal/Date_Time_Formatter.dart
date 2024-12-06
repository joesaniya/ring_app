import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDateTime(String inputDateTime) {
    // Parse the input date string into a DateTime object
    DateTime dateTime = DateTime.parse(inputDateTime);

    // Get the current date
    DateTime now = DateTime.now();

    // Determine if the date is today, yesterday, or earlier
    if (DateFormat('yyyy-MM-dd').format(dateTime) == DateFormat('yyyy-MM-dd').format(now)) {
      return 'Today ${DateFormat('hh:mm a').format(dateTime)}';
    } else if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)))) {
      return 'Yesterday ${DateFormat('hh:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    }
  }
}