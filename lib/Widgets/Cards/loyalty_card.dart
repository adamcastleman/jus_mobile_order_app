import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';

class LoyaltyCard extends ConsumerWidget {
  const LoyaltyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsDetailsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => points.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (points) => UnconstrainedBox(
          child: SizedBox(
            height: 170,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              color: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Available Points',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              determineUserStatus(user, points),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Text(
                          '246',
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, left: 4.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              ModalBottomSheet().fullScreen(
                                context: context,
                                builder: (context) => const PointsDetailPage(),
                              );
                            },
                            child: Text(
                              '${determinePointsMultiple(user, points)}x points/\$1 >',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          const Text(
                            'History',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  determineUserStatus(UserModel user, PointsDetailsModel points) {
    if (user.uid == null || !user.isActiveMember!) {
      return points.pointsStatus;
    } else {
      return points.memberPointsStatus;
    }
  }
}
