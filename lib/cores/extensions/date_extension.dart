import 'package:intl/intl.dart';
import '../utils/app_utils.dart';

extension DateExtensionStr on String? {
  /// format date = dd
  String toDateDay() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        DateTime dt = DateTime.parse(newStr);
        return DateFormat("EEEE, hh:mm", 'ID').format(dt);
      } catch (e) {
        DateTime dt = DateTime.parse(this!);
        return DateFormat("EEEE", 'ID').format(dt);
      }
    }
    return '';
  }

  /// format date = dd MMM
  String toDateDayMonth() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        DateTime dt = DateTime.parse(newStr);
        return DateFormat("dd MMM yyyy HH:mm", 'ID').format(dt);
      } catch (e) {
        DateTime dt = DateTime.parse(this!);
        return DateFormat("dd MMM yyyy HH:mm", 'ID').format(dt);
      }
    }
    return '';
  }

  /// format date = dd MMM yyyy HH:mm a
  String toDateStr() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        DateTime dt = DateTime.parse(newStr);
        return DateFormat("dd MMM yyyy HH:mm a", 'ID').format(dt);
      } catch (e) {
        DateTime dt = DateTime.parse(this!);
        return DateFormat("dd MMM yyyy HH:mm a", 'ID').format(dt);
      }
    }
    return '';
  }

  /// format date = dd MMM yyyy
  String toDateShortMonthStr() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        DateTime dt = DateTime.parse(newStr);
        return DateFormat("dd MMM yyyy", 'ID').format(dt);
      } catch (e) {
        DateTime dt = DateTime.parse(this!);
        return DateFormat("dd MMM yyyy", 'ID').format(dt);
      }
    }
    return '';
  }

  /// format date = dd MMMM yyyy
  String toDateLongMonthStr() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        DateTime dt = DateTime.parse(newStr);
        return DateFormat("dd MMMM yyyy", 'ID').format(dt);
      } catch (e) {
        DateTime dt = DateTime.parse(this!);
        return DateFormat("dd MMMM yyyy", 'ID').format(dt);
      }
    }
    return '';
  }

  DateTime? toDateTime() {
    if ((this ?? '').isNotEmpty) {
      try {
        var newStr = '${this!.substring(0, 10)} ${this!.substring(11, 19)}';
        return DateTime.parse(newStr);
      } catch (e) {
        return DateTime.parse(this!);
      }
    }
    return null;
  }
}

extension DateExtensionDT on DateTime? {
  /// format date = dd MMM yyyy HH:mm a
  String toDateStr(String format) {
    if (this != null) {
      try {
        return DateFormat(format, 'ID').format(this!);
      } catch (e) {
        appPrint('[DateExtensionDT][toDateStr]: $e');
      }
    }
    return '';
  }
}
