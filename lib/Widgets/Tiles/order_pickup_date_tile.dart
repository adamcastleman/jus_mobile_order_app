import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/dates.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/pickers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

class OrderPickupDateTile extends ConsumerWidget {
  const OrderPickupDateTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final products = ref.watch(productsProvider);
    final deviceTime = ref.watch(deviceTimezoneProvider);

    return deviceTime.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(error: e.toString()),
      data: (deviceTimezone) => products.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(error: e.toString()),
        data: (data) {
          var scheduledItems = currentOrder
              .where((element) => element['isScheduled'] == true)
              .toList();

          var scheduledList = scheduledItems
              .map((item) => {
                    'name': data
                        .firstWhere(
                            (element) => element.productID == item['productID'])
                        .name,
                    'daysQuantity': item['daysQuantity'],
                    'itemQuantity': item['itemQuantity'],
                    'hoursNotice': data
                        .firstWhere(
                            (element) => element.productID == item['productID'])
                        .hoursNotice,
                  })
              .toList();

          return Column(
            children: [
              JusDivider().thin(),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.clock),
                title: const Text('Schedule your pickup date'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your cart contains items that must be scheduled in advance.',
                      style: TextStyle(fontSize: 12),
                    ),
                    Spacing().vertical(
                        ref.watch(selectedPickupDateProvider) == null ? 0 : 10),
                    Row(
                      children: [
                        Text(
                          DateHelper().displayPickupDate(ref),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacing().horizontal(5),
                        determineTimezoneAbbreviation(ref, deviceTimezone),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                ),
                onTap: () {
                  openScheduleOrLocationPicker(context, ref, scheduledList);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  determineTimezoneAbbreviation(WidgetRef ref, dynamic deviceTimezone) {
    if (ref.read(selectedPickupDateProvider) == null ||
        LocationHelper().selectedLocation(ref) == null ||
        deviceTimezone == LocationHelper().selectedLocation(ref).timezone) {
      return const SizedBox();
    } else {
      return Text(
        Time().locationTimezoneAbbreviation(
          deviceTimezone: deviceTimezone,
          locationTimezone: LocationHelper().selectedLocation(ref).timezone,
        ),
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  openScheduleOrLocationPicker(
      BuildContext context, WidgetRef ref, dynamic scheduledList) {
    if (LocationHelper().selectedLocation(ref) == null) {
      LocationHelper().chooseLocation(context, ref);
    } else {
      setScheduleDateProvider(ref, scheduledList);
      Picker().date(context, ref, scheduledList);
    }
  }

  void setScheduleDateProvider(
      WidgetRef ref, List<Map<String, dynamic>> scheduledList) {
    var date = ref.read(selectedPickupDateProvider);
    date ??= date = Time()
        .convertLocalTimeToLocationTime(
            location: LocationHelper().selectedLocation(ref))
        .add(Duration(hours: scheduledList[0]['hoursNotice'], minutes: 5));

    ref.read(selectedPickupDateProvider.notifier).state = date;
  }
}
