import 'dart:math';

class Formulas {
  metersToMiles({required double meters}) {
    int decimals = 1;
    double miles = meters * 0.00062137;
    num fac = pow(10, decimals);
    double d = miles;
    d = (d * fac).round() / fac;

    return d;
  }

  getWeekdayFromName({required String dayOfWeek}) {
    switch (dayOfWeek) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
    }
  }

  getNameFromWeekday({required int dayOfWeek}) {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
    }
  }

  static String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}
