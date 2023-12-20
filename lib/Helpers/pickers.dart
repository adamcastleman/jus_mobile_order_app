import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_date_calendar.dart';

class Picker {
  time(BuildContext context, WidgetRef ref) {
    return ModalBottomSheet().partScreen(
      context: context,
      enableDrag: false,
      isDismissible: false,
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
                  initialDateTime: ref
                          .watch(selectedPickupTimeProvider)!
                          .isBefore(ref.watch(originalMinimumTimeProvider)!)
                      ? ref.watch(originalMinimumTimeProvider)
                      : ref.watch(selectedPickupTimeProvider),
                  minuteInterval: 5,
                  minimumDate: ref.watch(originalMinimumTimeProvider),
                  maximumDate: Time().closeTime(ref),
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

  date(BuildContext context, List<Map<String, dynamic>> scheduledList) {
    ModalBottomSheet().partScreen(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          return ProductQuantityLimitProviderWidget(
              productUID: scheduledList.first['productUID'],
              builder: (quantityLimit) {
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Schedule your pickup date',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Spacing.vertical(10),
                            Text(
                                'These items require at least ${quantityLimit.hoursNotice} hours\' notice:'),
                            Spacing.vertical(10),
                            Flexible(
                              child: SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: scheduledList.length,
                                    itemBuilder: (context, index) => Center(
                                      child: Center(
                                        child: SizedBox(
                                          width: 150,
                                          child: ListTile(
                                            title: Text(
                                              '${scheduledList[index]['name']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            subtitle: Column(
                                              children: [
                                                Text(
                                                  'Quantity: ${scheduledList[index]['itemQuantity']}',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Number of days: ${scheduledList[index]['scheduledQuantity']}',
                                                  style: const TextStyle(
                                                      fontSize: 12),
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
                              ),
                            ),
                            JusDivider().thick(),
                            Consumer(
                              builder: (context, ref, child) {
                                return Container(
                                  height: 360,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: const SelectDateCalendar(),
                                );
                              },
                            ),
                            ref.watch(scheduledAndNowItemsInCartProvider) ==
                                    true
                                ? Column(
                                    children: [
                                      Spacing.vertical(12.0),
                                      JusDivider().thick(),
                                      Spacing.vertical(4.0),
                                      Consumer(
                                        builder: (context, ref, child) =>
                                            CheckboxListTile(
                                          title: const Text(
                                              'Schedule all remaining items in this order to be picked up on this date?'),
                                          value: ref
                                              .watch(scheduleAllItemsProvider),
                                          activeColor: Colors.black,
                                          onChanged: (value) {
                                            ref
                                                .read(scheduleAllItemsProvider
                                                    .notifier)
                                                .state = value!;
                                            ref.invalidate(
                                                selectedPickupTimeProvider);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            Spacing.vertical(8.0),
                            JusDivider().thick(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 30.0),
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
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
