import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/edit_payment_method_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/cart_category_descriptor.dart';
import 'package:jus_mobile_order_app/Widgets/General/credit_card_name.dart';

class PaymentSettingsSheet extends ConsumerWidget {
  const PaymentSettingsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final paymentMethod = ref.watch(savedCreditCardsProvider);
    return currentUser.when(
      loading: () => const ListTile(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => paymentMethod.when(
        loading: () => const ListTile(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (card) => Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: JusCloseButton(
                  removePadding: true,
                ),
              ),
              Text(
                'Payment Methods',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacing().vertical(30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CartCategory(
                    text:
                        'jüs cards - Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: true)}/\$1'),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: card
                          .where((element) => element.isGiftCard == true)
                          .length +
                      1,
                  separatorBuilder: (context, index) => JusDivider().thin(),
                  itemBuilder: (context, index) {
                    var jusCard = card
                        .where((element) => element.isGiftCard == true)
                        .toList();
                    if (index ==
                        card
                            .where((element) => element.isGiftCard == true)
                            .length) {
                      return addJusCardTile(context, ref, user);
                    } else {
                      return jusCardTile(context, ref, jusCard, index);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CartCategory(
                    text:
                        'Payment method - Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: false)}/\$1'),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: card
                          .where((element) => element.isGiftCard != true)
                          .length +
                      1,
                  separatorBuilder: (context, index) => JusDivider().thin(),
                  itemBuilder: (context, index) {
                    var paymentMethod = card
                        .where((element) => element.isGiftCard != true)
                        .toList();
                    if (index ==
                        card
                            .where((element) => element.isGiftCard != true)
                            .length) {
                      return addPaymentMethodTile(context, ref, user);
                    } else {
                      return paymentMethodTile(
                          context, ref, paymentMethod, index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  jusCardTile(BuildContext context, WidgetRef ref, List<PaymentsModel> card,
      int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 20,
      leading: const Icon(
        CupertinoIcons.creditcard,
        color: Colors.black,
      ),
      title: CreditCardName(
        paymentMethods: card,
        index: index,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          card[index].defaultPayment ? const Text('Default') : const SizedBox(),
          Spacing().horizontal(4),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 16,
          ),
        ],
      ),
      onTap: () {
        ModalBottomSheet().partScreen(
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          context: context,
          builder: (context) => EditPaymentMethodSheet(
            card: card[index],
          ),
        );
      },
    );
  }

  addJusCardTile(BuildContext context, WidgetRef ref, UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 20,
      leading: const Icon(
        CupertinoIcons.creditcard_fill,
        color: Colors.black,
      ),
      title: const Text(
        'Add jüs card',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 16,
      ),
      onTap: () {
        PaymentsServices(
                context: context,
                ref: ref,
                uid: user.uid,
                firstName: user.firstName)
            .initSquareGiftCardPayment();
      },
    );
  }

  paymentMethodTile(BuildContext context, WidgetRef ref,
      List<PaymentsModel> card, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 20,
      leading: const Icon(
        CupertinoIcons.creditcard,
        color: Colors.black,
      ),
      title: CreditCardName(
        paymentMethods: card,
        index: index,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          card[index].defaultPayment ? const Text('Default') : const SizedBox(),
          Spacing().horizontal(8),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 15,
          ),
        ],
      ),
      onTap: () {
        ModalBottomSheet().partScreen(
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          context: context,
          builder: (context) => EditPaymentMethodSheet(
            card: card[index],
          ),
        );
      },
    );
  }

  addPaymentMethodTile(BuildContext context, WidgetRef ref, UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 20,
      leading: const Icon(
        CupertinoIcons.creditcard_fill,
        color: Colors.black,
      ),
      title: const Text(
        'Add payment',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 15,
      ),
      onTap: () {
        PaymentsServices(
                context: context,
                ref: ref,
                uid: user.uid,
                firstName: user.firstName)
            .initSquarePayment();
      },
    );
  }
}
