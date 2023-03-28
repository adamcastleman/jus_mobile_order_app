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
import 'package:jus_mobile_order_app/Hooks/confetti_controller.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
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
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_tile.dart';

class OrderConfirmationSheet extends HookConsumerWidget {
  const OrderConfirmationSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useConfettiController();
    return ProductsProviderWidget(
      builder: (products) {
        Future.delayed(
          const Duration(milliseconds: 150),
          () {
            if (controller.state == ConfettiControllerState.playing) {
              controller.stop();
              controller.play();
              HapticFeedback.heavyImpact();
            } else {
              controller.play();
              HapticFeedback.heavyImpact();
            }
          },
        );

        return Container(
          color: ref.watch(backgroundColorProvider),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          invalidateAllProviders(context, ref);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: AutoSizeText(
                        'We\'ve received your order.',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    _buildLocationDisplay(ref),
                    _buildNonScheduledDisplay(ref, products),
                    _buildScheduledDisplay(context, ref, products),
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
        );
      },
    );
  }

  Widget _buildLocationDisplay(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    return Column(
      children: [
        JusDivider().thick(),
        ListTile(
          leading: const Icon(CupertinoIcons.house),
          title: Text(
            location.name,
            style: const TextStyle(),
          ),
          trailing: TextButton(
            child: const Text(
              'Directions',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            onPressed: () {
              Launcher().launchMaps(
                  latitude: location.latitude,
                  longitude: location.longitude,
                  label: location.name);
            },
          ),
        ),
      ],
    );
  }

  _buildNonScheduledDisplay(WidgetRef ref, List<ProductModel> product) {
    final nonScheduledItems = OrderHelpers(ref: ref).nonScheduledItems();
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
      mainAxisSize: MainAxisSize.min,
      children: [
        JusDivider().thick(),
        ListTile(
          leading: const Icon(CupertinoIcons.clock),
          title: Text(dateDisplay),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: matchingIndices.length,
          itemBuilder: (context, index) {
            return OrderTile(orderIndex: matchingIndices[index]);
          },
        ),
        Spacing().vertical(20),
        JusDivider().thick(),
      ],
    );
  }

  Widget _buildScheduledDisplay(
      BuildContext context, WidgetRef ref, List<ProductModel> product) {
    final nonScheduledItems = OrderHelpers(ref: ref).nonScheduledItems();
    final scheduledItems = OrderHelpers(ref: ref).scheduledItems();
    if (scheduledItems.isEmpty) {
      return const SizedBox();
    }
    List matchingIndices = getOrderIndices(ref, isNonScheduled: false);
    final pickupDate =
        DateFormat('MM/dd/yyyy').format(ref.watch(selectedPickupDateProvider)!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        nonScheduledItems.isEmpty ? JusDivider().thick() : const SizedBox(),
        ListTile(
          leading: const Icon(CupertinoIcons.calendar),
          title: Text(pickupDate),
          trailing: TextButton(
            child: const Text(
              'Add to calendar',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            onPressed: () {
              HandlePermissions(context, ref).calendarPermission();
              Launcher().launchCalendar(ref);
            },
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: scheduledItems.length,
          separatorBuilder: (context, index) => Spacing().vertical(20),
          itemBuilder: (context, index) {
            return OrderTile(orderIndex: matchingIndices[index]);
          },
        ),
        Spacing().vertical(20),
        JusDivider().thick(),
      ],
    );
  }

  List getOrderIndices(WidgetRef ref, {required bool isNonScheduled}) {
    final OrderHelpers orderHelpers = OrderHelpers(ref: ref);
    final List items = isNonScheduled
        ? orderHelpers.nonScheduledItems()
        : orderHelpers.scheduledItems();
    final currentOrder = ref.watch(currentOrderItemsProvider);

    List productIds = items.map((item) => item['productID'] as int).toList();
    List matchingIndices = [];

    for (int index = 0; index < currentOrder.length; index++) {
      if (productIds.contains(currentOrder[index]['productID'])) {
        matchingIndices.add(index);
      }
    }

    return matchingIndices;
  }

  invalidateAllProviders(BuildContext context, WidgetRef ref) {
    ref.read(bottomNavigationProvider.notifier).state = 0;
    ref.invalidate(currentOrderItemsProvider);
    ref.invalidate(currentOrderItemsIndexProvider);
    ref.invalidate(currentOrderCostProvider);
    ref.invalidate(discountTotalProvider);
    ref.invalidate(selectedPaymentMethodProvider);
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
    ref.invalidate(checkOutPageProvider);
    ref.invalidate(locationsProvider);
    Navigator.pop(context);
  }
}
