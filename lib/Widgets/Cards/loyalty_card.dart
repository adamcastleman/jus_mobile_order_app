import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/determine_user_status.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_multiple_text_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

import '../../Views/points_detail_page.dart';

class LoyaltyCard extends ConsumerWidget {
  const LoyaltyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return PointsDetailsProviderWidget(
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
            height: 110,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const PointsMultipleText(
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Spacing.horizontal(5),
                          const ChevronRightIcon(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
