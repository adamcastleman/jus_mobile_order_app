import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/offers_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/points_information_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/screenshot_dialog.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/display_user_current_points_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/payment_method_selector.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_multiple_text_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/qr_code_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/scan_descriptor_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/scan_type_tabs_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_grid_view.dart';

import '../Providers/scan_providers.dart';

class ScanPage extends StatelessWidget {
  final WidgetRef ref;
  const ScanPage({required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final points = ref.watch(pointsInformationProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    final categoryIndex = ref.watch(scanCategoryProvider);
    final darkGreen = ref.watch(darkGreenProvider);
    final isLoading = ref.watch(qrLoadingProvider);

    ref.watch(screenshotCallbackProvider);
    final isScreenshotTaken = ref.watch(screenshotDetectedProvider);

    if (user.uid == null || user.uid!.isEmpty) {
      return const PointsInformationPage(
        showCloseButton: false,
      );
    }
    if ((PlatformUtils.isIOS() || PlatformUtils.isAndroid()) &&
        (user.subscriptionStatus!.isActive == true && isScreenshotTaken)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const ScreenshotDialog(),
        );
        // Reset the state to avoid showing the dialog repeatedly
        ref.read(screenshotDetectedProvider.notifier).state = false;
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ScanTypeTabsWidget(
              ref: ref,
            ),
          ),
        ),
      ),
      body: OffersProviderWidget(
        builder: (offers) => SingleChildScrollView(
          primary: false,
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacing.vertical(15),
                      _buildPointsRow(context, user, points),
                      Spacing.vertical(15),
                      _buildScanCard(
                          context, darkGreen, categoryIndex, user, isLoading),
                      if (categoryIndex == 0)
                        Column(
                          children: [
                            Spacing.vertical(15),
                            const CategoryWidget(text: 'Payment Method'),
                            Spacing.vertical(15),
                            _buildPaymentSection(),
                          ],
                        ),
                      Spacing.vertical(20),
                      const CategoryWidget(
                        text: 'Offers',
                      ),
                      Spacing.vertical(15),
                      Flexible(
                        child: OffersGridView(user: user, offers: offers),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard(
    BuildContext context,
    Color darkGreen,
    int categoryIndex,
    UserModel user,
    bool isLoading,
  ) {
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
        color: darkGreen,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ScanDescriptorWidget(
                isScanAndPay: categoryIndex == 0,
                isActiveMember: user.subscriptionStatus!.isActive,
              ),
              Spacing.vertical(15),
              CircleAvatar(
                radius: 110,
                backgroundColor: Colors.white,
                child: isLoading ? const Loading() : const QrCodeDisplay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsRow(
      BuildContext context, UserModel user, PointsDetailsModel points) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserCurrentPointsWidget(
            user: user,
            fontSize: 18,
          ),
          Row(
            children: [
              PointsMultipleText(
                  points: points,
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Spacing.horizontal(5),
              InfoButton(
                size: 20,
                onTap: () => NavigationHelpers.navigateToPointsInformationPage(
                  context,
                  ref,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: PaymentMethodSelector(
        whenComplete: () {
          ScanHelpers.cancelQrTimer(ref);
          ScanHelpers.handleScanAndPayPageInitializers(ref);
        },
      ),
    );
  }
}
