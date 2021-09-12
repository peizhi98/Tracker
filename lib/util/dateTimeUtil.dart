
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static final String databaseDateTimeFormat = 'yyyy-MM-dd hh:mm:ss';
  static final String dateFormat = 'yyyy-MM-dd';
  static final String monthDateFormat = 'dd-MM';

  static String displayTime(DateTime dateTime) {
    initializeDateFormatting('zh');
    return DateFormat.jm('zh').format(dateTime);
  }

  static String displayDate(DateTime dateTime) {
    initializeDateFormatting('zh');
    return DateFormat.yMMMd('zh').format(dateTime);
  }

  static String displayMonthAndDay(DateTime dateTime) {
    return DateFormat(monthDateFormat).format(dateTime);
  }
}

extension DateOnlyMethod on DateTime {
// return 0 if this date equal other date, 1 if this date is after other date, -1 if this date is before other date
  int compareDate(DateTime other) {
    if (this.year == other.year &&
        this.month == other.month &&
        this.day == other.day) return 0;
    return (this.year > other.year ||
            this.month > other.month ||
            this.day > other.day)
        ? 1
        : -1;
  }
}
