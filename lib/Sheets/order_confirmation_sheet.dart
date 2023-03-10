import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/launchers.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Hooks/confetti_controller.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_display_modifications.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_display_quantity.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_size_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';

class OrderConfirmationSheet extends HookConsumerWidget {
  const OrderConfirmationSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final controller = useConfettiController();
    return products.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (product) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (controller.state == ConfettiControllerState.playing) {
            controller.stop();
            controller.play();
          } else {
            controller.play();
          }
        });

        return Container(
          color: ref.watch(backgroundColorProvider),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Stack(
              children: [
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
                ListView(
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
                    _buildNonScheduledDisplay(ref, product),
                    _buildScheduledDisplay(context, ref, product),
                    const TotalPrice(),
                  ],
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
          itemCount: nonScheduledItems.length,
          itemBuilder: (context, index) {
            final item = nonScheduledItems[index];
            final productID = item['productID'];
            final currentProduct =
                product.firstWhere((element) => element.productID == productID);
            return ListTile(
              leading: Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              title: Row(
                children: [
                  Text(
                    currentProduct.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacing().horizontal(10),
                  _buildQuantityDisplay(index),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderTileSizeDisplay(
                    orderIndex: index,
                    currentProduct: currentProduct,
                  ),
                  OrderTileDisplayModifications(
                    orderIndex: index,
                    currentProduct: currentProduct,
                  ),
                ],
              ),
            );
          },
        ),
        Spacing().vertical(20),
        JusDivider().thick(),
      ],
    );
  }

  Widget _buildQuantityDisplay(int index) {
    return OrderTileDisplayQuantity(orderIndex: index);
  }

  Widget _buildScheduledDisplay(
      BuildContext context, WidgetRef ref, List<ProductModel> product) {
    final nonScheduledItems = OrderHelpers(ref: ref).nonScheduledItems();
    final scheduledItems = OrderHelpers(ref: ref).scheduledItems();
    if (scheduledItems.isEmpty) {
      return const SizedBox();
    }

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
              addToCalendar(ref);
            },
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: scheduledItems.length,
          separatorBuilder: (context, index) => Spacing().vertical(20),
          itemBuilder: (context, index) {
            final item = scheduledItems[index];
            final productID = item['productID'];
            final currentProduct =
                product.firstWhere((element) => element.productID == productID);
            return ListTile(
              leading: Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              title: Text(
                currentProduct.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderTileSizeDisplay(
                    orderIndex: index,
                    currentProduct: currentProduct,
                  ),
                  OrderTileDisplayModifications(
                    orderIndex: index,
                    currentProduct: currentProduct,
                  ),
                ],
              ),
            );
          },
        ),
        Spacing().vertical(20),
        JusDivider().thick(),
      ],
    );
  }

  addToCalendar(WidgetRef ref) {
    var time = ref.watch(selectedPickupDateProvider)!;
    var formatStart = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(time.year, time.month, time.day, 08, 00, 00));
    var formatEnd = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(time.year, time.month, time.day, 09, 00, 00));
    var start = DateTime.parse(formatStart);
    var end = DateTime.parse(formatEnd);
    return Add2Calendar.addEvent2Cal(
      Event(
        startDate: start,
        endDate: end,
        title: 'Pickup jüs order',
        allDay: false,
        iosParams: const IOSParams(
          reminder: Duration(hours: 0),
        ),
      ),
    );
  }

  invalidateAllProviders(BuildContext context, WidgetRef ref) {
    ref.read(bottomNavigationProvider.notifier).state = 0;
    ref.invalidate(currentOrderItemsProvider);
    ref.invalidate(currentOrderItemsIndexProvider);
    ref.invalidate(currentOrderCostProvider);
    ref.invalidate(discountTotalProvider);
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
