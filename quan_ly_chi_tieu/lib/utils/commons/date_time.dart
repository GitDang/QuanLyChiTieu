import 'package:intl/intl.dart';

class DateFormatType {
  static const String ddMMyyyy = 'dd/MM/yyyy';
  static const String ddMMyyyy_hhmmss = 'dd/MM/yyyy - hh:mm:ss';
  static const String yyyyMMdd = 'yyyy/MM/dd';
  static const String yyyyMMddThhmmss = 'yyyy-MM-ddThh:mm:ss';
}

class DateTimeUtil {
  static String stringFromDateTime(DateTime date, {String dateFormat = DateFormatType.yyyyMMdd}) {
    return DateFormat(dateFormat).format(date);
  }

  static DateTime dateTimeFromString(String strDate, {String dateFormat = DateFormatType.yyyyMMdd}) {
    return DateFormat(dateFormat).parseLoose(strDate);
  }

  static DateTime? getMaximumBetweenDates(DateTime? dFirst, DateTime? dSecond) {
    if (dFirst == null) return dSecond;
    if (dSecond == null) return dFirst;
    if (dFirst.isAfter(dSecond)) return dFirst;
    return dSecond;
  }

  static String stringFromDateTimeNow({String dateFormat = DateFormatType.yyyyMMdd}) {
    return DateFormat(dateFormat).format(DateTime.now());
  }
}
