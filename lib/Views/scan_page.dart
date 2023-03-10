import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/current_payment_tile.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Models/user_model.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetail = ref.watch(pointsDetailsProvider);
    final categoryIndex = ref.watch(scanCategoryProvider);
    return pointsDetail.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (points) => currentUser.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (user) => Scaffold(
          backgroundColor: ref.watch(backgroundColorProvider),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: user.uid == null
                ? const PointsDetailPage(isScanPage: true)
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextButton(
                                  child: const Text(
                                    'Scan and pay',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(scanCategoryProvider.notifier)
                                        .state = 0;
                                  },
                                ),
                                Container(
                                  height: 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: categoryIndex == 0
                                          ? Colors.black
                                          : Colors.transparent),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  child: const Text(
                                    'Scan only',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(scanCategoryProvider.notifier)
                                        .state = 1;
                                  },
                                ),
                                Container(
                                  height: 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: categoryIndex == 1
                                          ? Colors.black
                                          : Colors.transparent),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Points: ${user.totalPoints}',
                                        style: const TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacing().horizontal(6.0),
                                      InfoButton(
                                        size: 16,
                                        color: Colors.black,
                                        onTap: () {
                                          ModalBottomSheet().fullScreen(
                                            context: context,
                                            builder: (context) =>
                                                const PointsDetailPage(
                                                    isScanPage: false),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.5),
                                    ),
                                    child: Text(
                                      user.isActiveMember!
                                          ? points.memberPointsStatus
                                              .toUpperCase()
                                          : points.pointsStatus.toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Spacing().vertical(50),
                              Text(
                                categoryIndex == 0
                                    ? 'One scan for everything.'
                                    : 'Scan before you pay',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacing().vertical(4),
                              categoryIndex == 0
                                  ? Text(
                                      displayScanAndPayDescriptor(user),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  : Text(
                                      displayScanOnlyDescriptor(user),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                              Spacing().vertical(30),
                              QrImage(
                                data: categoryIndex == 0
                                    ? ref.watch(encryptedQrProvider)
                                    : user.uid!,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                              Spacing().vertical(30),
                              Text(
                                pointValueDisplay(ref, points, user),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Spacing().vertical(40),
                              categoryIndex == 0
                                  ? JusDivider().thin()
                                  : const SizedBox(),
                              categoryIndex == 0
                                  ? const CurrentPaymentTile(
                                      isScanPage: true,
                                    )
                                  : const SizedBox(),
                              categoryIndex == 0
                                  ? JusDivider().thin()
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

displayScanAndPayDescriptor(UserModel user) {
  if (user.isActiveMember!) {
    return 'Check-in to Membership, earn points, and pay.';
  } else {
    return 'Earn points and pay.';
  }
}

displayScanOnlyDescriptor(UserModel user) {
  if (user.isActiveMember!) {
    return 'Check-in to Membership and earn points.';
  } else {
    return 'Scan to earn points.';
  }
}

String pointValueDisplay(
    WidgetRef ref, PointsDetailsModel points, UserModel user) {
  final selectedCard = ref.watch(selectedCreditCardProvider);
  num pointValue;

  if (!user.isActiveMember! && selectedCard['isGiftCard'] != true) {
    pointValue = points.pointsPerDollar;
  } else if (!user.isActiveMember! && selectedCard['isGiftCard'] == true) {
    pointValue = points.jusCardPointsPerDollar;
  } else if (user.isActiveMember! && selectedCard['isGiftCard'] != true) {
    pointValue = points.memberPointsPerDollar;
  } else if (user.isActiveMember! && selectedCard['isGiftCard'] == true) {
    pointValue = points.jusCardPointsPerDollarMember;
  } else {
    return '';
  }

  return 'Earn $pointValue ${pointValue == 1 ? 'point' : 'points'}/\$1';
}
