extension StringExtension on String {
  String get capitalize {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension DateTimeExt on DateTime {
  DateTime get earliestRoundedTime {
    int rounded = minute + 10;
    int remainder = rounded % 5;
    int roundedUp = rounded - remainder;
    return DateTime(year, month, day, hour, roundedUp);
  }
}

extension NumExtension on num {
  bool isWhole() {
    return remainder(1) == 0;
  }
}
