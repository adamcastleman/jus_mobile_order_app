import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_multiple_text_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/qr_code_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/scan_descriptor_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/scan_type_tabs_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/user_points_status_display.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/payment_method_selector.dart';

import '../Providers/scan_providers.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryIndex = ref.watch(scanCategoryProvider);

    return UserProviderWidget(builder: (user) {
      if (user.uid == null) {
        return const PointsDetailPage(closeButton: false);
      }
      return PointsDetailsProviderWidget(
        builder: (points) => Scaffold(
          backgroundColor: ref.watch(backgroundColorProvider),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const ScanTypeTabsWidget(),
                Spacing().vertical(15),
                UserPointsStatusWidget(
                  user: user,
                  points: points,
                ),
                Spacing().vertical(50),
                ScanDescriptorWidget(
                    isScanAndPay: categoryIndex == 0 ? true : false,
                    isActiveMember: user.isActiveMember!),
                Spacing().vertical(30),
                const QrCodeDisplay(),
                Spacing().vertical(30),
                const PointsMultipleText(),
                Spacing().vertical(20),
                categoryIndex == 0 ? JusDivider().thin() : const SizedBox(),
                categoryIndex == 0
                    ? const PaymentMethodSelector()
                    : const SizedBox(),
                categoryIndex == 0 ? JusDivider().thin() : const SizedBox(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
