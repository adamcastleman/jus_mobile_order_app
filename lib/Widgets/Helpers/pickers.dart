import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

import 'spacing_widgets.dart';

class Picker {
  time(BuildContext context, WidgetRef ref) {
    final earliestTime = Time().earliestPickUpTime(ref);
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final openTime = Time().openTime(ref);
    final closeTime = Time().closeTime(ref);

    determineMinimumDate() {
      if (Time().now(ref).isBefore(openTime)) {
        return openTime;
      } else {
        return earliestTime.subtract(const Duration(seconds: 1));
      }
    }

    return ModalBottomSheet().partScreen(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 50.0),
                child: Text(
                  'Choose a pickup time',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                height: 175,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime ?? earliestTime,
                  minuteInterval: 5,
                  minimumDate: determineMinimumDate(),
                  maximumDate: closeTime,
                  onDateTimeChanged: (value) {
                    ref.read(selectedPickupTimeProvider.notifier).state = value;
                  },
                ),
              ),
              JusDivider().thin(),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                child: Center(
                  child: LargeElevatedButton(
                    buttonText: 'Select',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  date(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> scheduledList) {
    return ModalBottomSheet().partScreen(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Schedule your pickup date',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacing().vertical(10),
                  Text(
                      'These items require at least ${scheduledList[0]['hoursNotice']} hours\' notice:'),
                  Spacing().vertical(10),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: scheduledList.length,
                        itemBuilder: (context, index) => Center(
                          child: Center(
                            child: ListTile(
                              title: Text(
                                '${scheduledList[index]['name']}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Column(
                                children: [
                                  Text(
                                    'Quantity: ${scheduledList[index]['itemQuantity']}',
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Number of days: ${scheduledList[index]['itemQuantity']}',
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  JusDivider().thin(),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      minimumDate: Time()
                          .convertLocalTimeToLocationTime(
                              location: LocationHelper().selectedLocation(ref))
                          .add(Duration(hours: scheduledList[0]['hoursNotice']))
                          .subtract(const Duration(minutes: 5)),
                      initialDateTime: ref.watch(selectedPickupDateProvider) ??
                          Time()
                              .convertLocalTimeToLocationTime(
                                  location:
                                      LocationHelper().selectedLocation(ref))
                              .add(Duration(
                                  hours: scheduledList[0]['hoursNotice'])),
                      onDateTimeChanged: (value) {
                        ref.read(selectedPickupDateProvider.notifier).state =
                            DateTime(value.year, value.month, value.day, 17, 0);
                      },
                    ),
                  ),
                  JusDivider().thin(),
                  ref.watch(scheduledAndNowItemsInCartProvider) == true
                      ? Column(
                          children: [
                            Consumer(
                              builder: (context, ref, child) =>
                                  CheckboxListTile(
                                title: const Text(
                                    'Schedule all remaining items in this order to be picked up on this date?'),
                                value: ref.watch(scheduleAllItemsProvider),
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  ref
                                      .read(scheduleAllItemsProvider.notifier)
                                      .state = value!;
                                },
                              ),
                            ),
                            JusDivider().thin(),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: LargeElevatedButton(
                buttonText: 'Select',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
