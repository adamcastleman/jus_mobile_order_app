import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/General/determine_user_status.dart';

class UserPointsStatusWidget extends StatelessWidget {
  final UserModel user;
  final PointsDetailsModel points;

  const UserPointsStatusWidget(
      {required this.user, required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Points: ${NumberFormat('#,###').format(user.points)}',
            style: const TextStyle(
                letterSpacing: 1, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: const DetermineUserStatus(),
          ),
        ],
      ),
    );
  }
}
