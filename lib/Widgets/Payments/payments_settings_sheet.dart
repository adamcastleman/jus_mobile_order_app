import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/gift_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/saved_payments_list_view.dart';

class PaymentSettingsSheet extends ConsumerWidget {
  final VoidCallback? onCardSelectTap;
  final VoidCallback? onCardEditTap;
  const PaymentSettingsSheet(
      {this.onCardEditTap, this.onCardSelectTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return UserProviderWidget(
      builder: (user) => CreditCardProviderWidget(
        builder: (creditCards) => GiftCardProviderWidget(
          builder: (giftCards) => Container(
            color: backgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
              child: ListView(
                primary: false,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: JusCloseButton(
                      removePadding: true,
                      onPressed: () {
                        ref.invalidate(pageTypeProvider);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Payment Methods',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacing().vertical(30),
                  CategoryWidget(
                      text:
                          'jüs cards - Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: true)}/\$1'),
                  SavedPaymentsListView(
                    cards: giftCards,
                  ),
                  giftCards.isEmpty ? const SizedBox() : JusDivider().thin(),
                  AddPaymentMethodTile(
                    title: 'Add jüs card',
                    onTap: () {
                      PaymentsServices(
                              ref: ref,
                              userID: user.uid,
                              firstName: user.firstName,
                              context: context)
                          .initSquareGiftCardPayment();
                    },
                  ),
                  Spacing().vertical(20),
                  CategoryWidget(
                      text:
                          'Payment method - Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: false)}/\$1'),
                  SavedPaymentsListView(
                    cards: creditCards,
                  ),
                  creditCards.isEmpty ? const SizedBox() : JusDivider().thin(),
                  AddPaymentMethodTile(
                    title: 'Add payment method',
                    onTap: () {
                      PaymentsServices(
                              ref: ref,
                              userID: user.uid,
                              firstName: user.firstName,
                              context: context)
                          .initSquarePayment();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
