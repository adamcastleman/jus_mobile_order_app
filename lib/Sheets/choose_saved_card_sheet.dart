import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/credit_card_name.dart';

class ChooseSavedCardSheet extends ConsumerWidget {
  const ChooseSavedCardSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final paymentMethods = ref.watch(savedCreditCardsProvider);
    final defaultPayment = ref.watch(defaultPaymentCardProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(error: e.toString()),
      data: (user) => paymentMethods.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(error: e.toString()),
        data: (paymentMethods) => defaultPayment.when(
          loading: () => const Loading(),
          error: (e, _) => ShowError(error: e.toString()),
          data: (defaultCard) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: backgroundColor,
            ),
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 40.0),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200,
                        child: CupertinoPicker(
                          itemExtent: 55,
                          scrollController: FixedExtentScrollController(
                            initialItem: currentlySelectedCard(
                                ref, paymentMethods, defaultCard[0]),
                          ),
                          onSelectedItemChanged: (index) {
                            setSelectedCreditCardProvider(
                                ref, index, paymentMethods);
                            //vv This is making sure the correct card vv
                            // is being referenced on the scan&pay page.
                            ScanHelpers(ref).scanAndPayMap();
                          },
                          children: List.generate(
                            paymentMethods.length,
                            (index) => Center(
                              child: CreditCardName(
                                paymentMethods: paymentMethods,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacing().vertical(20),
                    LargeOutlineButton(
                      buttonText: 'Add new card',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                        ModalBottomSheet().partScreen(
                          context: context,
                          enableDrag: true,
                          isDismissible: true,
                          builder: (context) => const ChoosePaymentTypeSheet(),
                        );
                      },
                      color: backgroundColor,
                    ),
                    Spacing().vertical(10),
                    LargeElevatedButton(
                      buttonText: 'Select',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int currentlySelectedCard(WidgetRef ref, List<PaymentsModel> paymentMethods,
      PaymentsModel defaultCard) {
    final selectedCard = ref.watch(selectedCreditCardProvider);
    if (selectedCard.isNotEmpty) {
      return paymentMethods.indexWhere((element) =>
          element.lastFourDigits == selectedCard['lastFourDigits']);
    }
    return paymentMethods
        .indexWhere((element) => element.defaultPayment == true);
  }

  setSelectedCreditCardProvider(
      WidgetRef ref, int index, List<PaymentsModel> paymentMethods) {
    ref.read(selectedCreditCardProvider.notifier).state =
        PaymentsServices().mapPaymentItems(paymentMethods, index);
  }
}
