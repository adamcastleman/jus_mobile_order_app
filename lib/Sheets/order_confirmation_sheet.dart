import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/launchers.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Hooks/confetti_controller.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/open_app_settings_calendar.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class OrderConfirmationSheet extends HookConsumerWidget {
  const OrderConfirmationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useConfettiController();
    final isTabletOrSmaller =
        MediaQuery.of(context).size.width <= AppConstants.tabletWidth;

    if (isTabletOrSmaller) {
      _displayConfettiAnimation(controller);
    }
    if (isTabletOrSmaller) {
      return _mobileLayout(context, ref, controller);
    } else {
      return _webLayout(context, ref);
    }
  }

  Widget _mobileLayout(
      BuildContext context, WidgetRef ref, ConfettiController controller) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      color: ref.watch(backgroundColorProvider),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.mobilePhoneWidth),
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                primary: false,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: JusCloseButton(
                      removePadding: true,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        invalidateAllProviders(context, ref);
                        _popToHomeScreen(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.black,
                      size: 100,
                    ),
                  ),
                  _displayTitleText(),
                  _buildLocationDisplay(ref),
                  _buildNonScheduledDisplay(ref),
                  _buildScheduledDisplay(context, ref),
                  JusDivider.thick(),
                  const TotalPrice(),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: controller,
                    shouldLoop: false,
                    blastDirection: 3.14,
                    blastDirectionality: BlastDirectionality.explosive,
                    maxBlastForce: 30,
                    numberOfParticles: 50,
                    gravity: 0.5,
                    colors: const [
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _webLayout(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final pastelTan = ref.watch(pastelTanProvider);
    return DisplayImagesProviderWidget(
      builder: (images) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: pastelTan,
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 600,
                    maxWidth: 600,
                  ),
                  child: CallToActionBanner(
                    backgroundColor: pastelTan,
                    imagePath: images['images'][25]['url'],
                    title: 'We\'ve received your order',
                    description: 'Thank you for shopping with us.',
                    callToActionText: 'Close',
                    callToActionOnPressed: () {
                      invalidateAllProviders(context, ref);
                      _popToHomeScreen(context);
                    },
                  ).buildMobileLayout(context),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: double.infinity,
            color: backgroundColor,
            child: Center(
              // Center horizontally
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                    maxWidth: 400, // Set your max width here
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Center horizontally the column items
                    children: [
                      _buildLocationDisplay(ref),
                      _buildNonScheduledDisplay(ref),
                      _buildScheduledDisplay(context, ref),
                      JusDivider.thick(),
                      const TotalPrice(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayTitleText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 22.0),
      child: AutoSizeText(
        'We\'ve received your order.',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  void _displayConfettiAnimation(ConfettiController controller) {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        if (controller.state == ConfettiControllerState.playing) {
          controller.stop();
          controller.play();
        } else {
          controller.play();
        }
      },
    );
  }

  Widget _buildLocationDisplay(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    return Column(
      children: [
        JusDivider.thin(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location: ${location.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              InkWell(
                child: const Text(
                  'Directions',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                onTap: () {
                  Launcher().launchMaps(
                      latitude: location.latitude,
                      longitude: location.longitude,
                      label: location.name);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildNonScheduledDisplay(WidgetRef ref) {
    final nonScheduledItems = OrderHelpers.nonScheduledItems(ref);
    if (nonScheduledItems.isEmpty) {
      return const SizedBox();
    }
    final now = DateTime.now();
    final dateToDisplay = ref.watch(selectedPickupTimeProvider)!;
    final pickupTime = DateFormat('h:mm a').format(dateToDisplay).toLowerCase();
    final isToday = now.day == dateToDisplay.day &&
        now.month == dateToDisplay.month &&
        now.year == dateToDisplay.year;
    final dateDisplay = isToday ? 'Today, $pickupTime' : pickupTime;
    List matchingIndices = getOrderIndices(ref, isNonScheduled: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacing.vertical(10),
        Text(
          'Pickup Time: $dateDisplay',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Spacing.vertical(20),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: matchingIndices.length,
          separatorBuilder: (context, index) => JusDivider.thin(),
          itemBuilder: (context, index) {
            return OrderTile(orderIndex: matchingIndices[index]);
          },
        ),
      ],
    );
  }

  Widget _buildScheduledDisplay(BuildContext context, WidgetRef ref) {
    final nonScheduledItems = OrderHelpers.nonScheduledItems(ref);
    final scheduledItems = OrderHelpers.scheduledItems(ref);
    if (scheduledItems.isEmpty) {
      return const SizedBox();
    }
    List matchingIndices = getOrderIndices(ref, isNonScheduled: false);
    final pickupDate =
        DateFormat('MM/dd/yyyy').format(ref.watch(selectedPickupDateProvider)!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        nonScheduledItems.isEmpty ? const SizedBox() : JusDivider.thin(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scheduled: $pickupDate',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              InkWell(
                onTap: () {
                  PermissionHandler().calendarPermission(isDenied: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const CalendarPermissionAlertDialog(),
                    );
                  });
                  Launcher().launchCalendar(ref);
                },
                child: const Text(
                  'Add to calendar',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: scheduledItems.length,
          separatorBuilder: (context, index) => JusDivider.thin(),
          itemBuilder: (context, index) {
            return OrderTile(orderIndex: matchingIndices[index]);
          },
        ),
      ],
    );
  }

  List getOrderIndices(WidgetRef ref, {required bool isNonScheduled}) {
    final List items = isNonScheduled
        ? OrderHelpers.nonScheduledItems(ref)
        : OrderHelpers.scheduledItems(ref);
    final currentOrder = ref.watch(currentOrderItemsProvider);

    List productIds = items.map((item) => item['productId']).toList();
    List matchingIndices = [];

    for (int index = 0; index < currentOrder.length; index++) {
      if (productIds.contains(currentOrder[index]['productId'])) {
        matchingIndices.add(index);
      }
    }

    return matchingIndices;
  }

  invalidateAllProviders(BuildContext context, WidgetRef ref) {
    ref.invalidate(applePayLoadingProvider);
    ref.invalidate(applePaySelectedProvider);
    ref.read(loadingProvider.notifier).state = false;
    ref.invalidate(selectedLoadAmountProvider);
    ref.invalidate(selectedLoadAmountIndexProvider);
    ref.invalidate(currentOrderItemsProvider);
    ref.invalidate(currentOrderItemsIndexProvider);
    ref.invalidate(currentOrderCostProvider);
    ref.invalidate(discountTotalProvider);
    ref.invalidate(selectedPaymentMethodProvider);
    ref.invalidate(applePaySelectedProvider);
    ref.invalidate(emailProvider);
    ref.invalidate(phoneProvider);
    ref.invalidate(firstNameProvider);
    ref.invalidate(lastNameProvider);
    ref.invalidate(pointsMultiplierProvider);
    ref.invalidate(pointsInUseProvider);
    ref.invalidate(selectedPickupTimeProvider);
    ref.invalidate(selectedPickupDateProvider);
    ref.invalidate(scheduleAllItemsProvider);
    ref.invalidate(scheduledAndNowItemsInCartProvider);
    ref.invalidate(selectedTipPercentageProvider);
    ref.invalidate(selectedTipIndexProvider);
    ref.invalidate(isCheckOutPageProvider);
    ref.invalidate(locationsProvider);
    _setPageProviders(ref);
  }

  _setPageProviders(WidgetRef ref) {
    if (PlatformUtils.isWeb()) {
      ref.read(webNavigationProvider.notifier).state = AppConstants.homePage;
      ref
          .read(webNavigationPageControllerProvider)
          .jumpToPage(AppConstants.homePage);
    } else {
      ref.read(bottomNavigationProvider.notifier).state = 0;
      ref.read(bottomNavigationPageControllerProvider).jumpToPage(0);
    }
  }

  _popToHomeScreen(BuildContext context) {
    if (PlatformUtils.isWeb()) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
