import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';

class UserCurrentPointsWidget extends StatelessWidget {
  final UserModel user;
  final double fontSize;
  final Color? fontColor;
  const UserCurrentPointsWidget(
      {required this.user, required this.fontSize, this.fontColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Total Points: ${NumberFormat.decimalPattern('en_US').format(user.points)}',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: fontColor ?? Colors.black),
    );
  }
}
