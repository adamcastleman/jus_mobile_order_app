import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/determine_user_status.dart';

import '../../Views/points_detail_page.dart';

class LoyaltyCard extends StatelessWidget {
  const LoyaltyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserProviderWidget(
      builder: (user) => PointsDetailsProviderWidget(
        builder: (points) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rewards',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white),
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: DetermineUserStatus(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Available Points',
                              style: TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              NumberFormat('#,###').format(user.points),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          ModalBottomSheet().fullScreen(
                            context: context,
                            builder: (context) =>
                                const PointsDetailPage(closeButton: true),
                          );
                        },
                        child: Text(
                          '${determinePointsMultiple(user, points)}x points/\$1 >',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  determinePointsMultiple(UserModel user, PointsDetailsModel points) {
    if (user.uid == null || !user.isActiveMember!) {
      return '${points.pointsPerDollar}';
    } else {
      return '${points.memberPointsPerDollar}';
    }
  }
}
