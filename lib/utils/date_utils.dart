import 'dart:developer';

import 'package:intl/intl.dart';



class DateComponents {
  int day = 0;
  int month = 0;
  int? year;
  int? hour;
  int? minute;
  int? second;

  DateComponents({required this.day, required this.month, this.year});

  DateComponents.withTime({required this.day, required this.month, this.year, this.hour, this.minute, this.second});
}

class TempoDateUtils {
  static const int dateMax = 99999;

  static bool daysBeforeDate(DateTime date, int days) {
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    date = DateTime(date.year, date.month, date.day);
    final diff = now.difference(date).inDays;
    return diff >= days;
  }

  static String secondsToMMss(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static int currentDayHour() => DateTime.now().hour;

  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  static String convertTwoDigits(int n) => n.toString().padLeft(2, "0");

  bool getIfExpired(String timestamp) {
    final dateToCheck = timestamp.parseUtcMillisecondsEpochToDateTime();
    final dateToday = DateTime.now().toUtc().toLocal();
    log("Expiration date ${dateToCheck.toString()}");

    if (dateToday.isAfter(dateToCheck)) {
      log('EXPIRED');
      return true;
    } else {
      log('NOT EXPIRED');
      return false;
    }
  }
}

extension DateTimeSringHelper on String {
  String parseIsoStringToLocal() {
    final date = DateTime.parse(this).toLocal();
    final formattedDate = DateFormat("yyyy-MM-dd ").format(date);
    return formattedDate;
  }

  DateTime parseUtcMillisecondsEpochToDateTime() {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this), isUtc: true).toLocal();
    return date;
  }
  String displayTimeInHourSecond() {
    if (isEmpty) {
      return "";
    } else {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
      return date.displayTimeInHoursAndMinutes();
    }
  }


  String displayTimeInHoursAndMinutesForString() {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
    String formattedDate = DateFormat("hh:mm a").format(dateValue);
    return formattedDate;
  }

  String displayTimeStampAsYYYYMMDD() {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    String formattedDate = DateFormat("yyyy-MM-dd").format(date);
    return formattedDate;
  }

  bool isSameDay(String timestamp) {
    final today = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    final nextDay = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

    return today.year == nextDay.year && today.month == nextDay.month && today.day == nextDay.day;
  }

  bool isToday(String timestamp) {
    final today = DateTime.now();
    final nextDay = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

    return today.year == nextDay.year && today.month == nextDay.month && today.day == nextDay.day;
  }

  String displayMessageDay() {
    if (isToday(this)) {
      return 'Today';
    } else {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));

      var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
      String formattedDate = DateFormat("dd MMMM yyyy").format(dateValue);

      return formattedDate;
    }
  }

  String displayTimeInYearMonthDayView() {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
    String formattedDate = DateFormat("dd/MM/yyyy").format(dateValue);

    return formattedDate;
  }

  String displayTimeInDayDateMonthView() {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
    String formattedDate = DateFormat.MMMMEEEEd().format(dateValue);

    return formattedDate;
  }

  String displayDateInAmericanStd() {
    if (isNotEmpty) {
      try {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
        var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
        String formattedDate = DateFormat("MMMM dd, yyyy").format(dateValue);
        return formattedDate;
      } catch (e) {
        var dateValue = DateTime.parse(this).toUtc().toString();
        String formattedDate = DateFormat("MMMM dd, yyyy").format(DateTime.parse(dateValue).toLocal());
        return formattedDate;
      }
    }
    return '';
  }

  String displayDateInAmericanStdWithTime() {
    if (isNotEmpty) {
      try {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
        var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(date.toUtc().toString()).toLocal();
        String formattedDate = DateFormat("MMMM dd, yyyy, hh:mm a").format(dateValue);
        return formattedDate;
      } catch (e) {
        var dateValue = DateTime.parse(this).toUtc().toString();
        String formattedDate = DateFormat("MMMM dd, yyyy, hh:mm a").format(DateTime.parse(dateValue).toLocal());
        return formattedDate;
      }
    }
    return '';
  }
}

extension DateTimeHelper on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String displayTimeInHoursAndMinutes() {
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(toUtc().toString()).toLocal();
    String formattedDate = DateFormat("hh:mm a").format(dateValue);
    return formattedDate;
  }

  String displayDateTimeAsYYYYMMDD() {
    String formattedDate = DateFormat("yyyy-MM-dd").format(this);
    return formattedDate;
  }

  String displayDateTimeInAmericanStandard() {
    String formattedDate = DateFormat("MMMM dd, yyyy").format(this);
    return formattedDate;
  }

  bool daysBeforeDate(DateTime date, int days) {
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    date = DateTime(date.year, date.month, date.day);
    final diff = now.difference(date).inDays;
    return diff >= days;
  }

  String displayTimeInDayDateMonthView() {
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ssZ").parseUTC(toUtc().toString()).toLocal();
    String formattedDate = DateFormat.MMMMEEEEd().format(dateValue);

    return formattedDate;
  }

  int toUtcMilliSeconds() {
    return toUtc().millisecondsSinceEpoch;
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
