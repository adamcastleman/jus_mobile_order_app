import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/edit_payment_method_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';

import '../../Services/payment_method_database_services.dart';

class SavedPaymentTile extends ConsumerWidget {
  final PaymentsModel card;
  const SavedPaymentTile({required this.card, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String cardTitle =
        PaymentsHelper().displaySelectedCardTextFromPaymentModel(card);
    return ListTile(
      leading: card.isWallet
          ? const Icon(FontAwesomeIcons.wallet)
          : const PaymentMethodIcon(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            cardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          _determineSubtitle(),
        ],
      ),
      // subtitle: _determineSubtitle(),
      trailing: const ChevronRightIcon(),
      onTap: () => _handleTap(ref, context),
    );
  }

  Widget _determineSubtitle() {
    if (!card.isWallet && !card.defaultPayment) {
      return const SizedBox();
    }
    if (card.isWallet) {
      final balance = (card.balance! / 100).toStringAsFixed(2);
      final defaultPayment = card.defaultPayment ? 'Default' : '';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance: \$$balance',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            defaultPayment,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      );
    } else {
      final defaultPayment = card.defaultPayment ? 'Default' : '';
      return card.defaultPayment
          ? Text(
              defaultPayment,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            )
          : const SizedBox();
    }
  }

  void _handleTap(WidgetRef ref, BuildContext context) async {
    final pageType = ref.read(pageTypeProvider);
    ref.read(cardNicknameProvider.notifier).state = card.cardNickname;
    if (pageType != PageType.editPaymentMethod) {
      // To ensure the Square In-App Payments modal can validate cards asynchronously
      // and update the initial stored value for guest cards, pass a reference
      // to the selectedPaymentMethod provider when updating payment methods.
      // For registered users, the default card provider automatically updates
      // the selectedPaymentMethod provider, so this is not a concern for them.
      // Passing the reference ensures proper updates for all payment methods
      // without destabilizing the ref.read() method that occurs when called directly
      // in async functions.
      SelectedPaymentMethodNotifier reference =
          ref.read(selectedPaymentMethodProvider.notifier);
      ref.invalidate(applePaySelectedProvider);
      PaymentMethodDatabaseServices().updatePaymentMethod(
        reference: reference,
        cardNickname: card.cardNickname,
        cardId: card.cardId,
        last4: card.last4,
        brand: card.brand.toString(),
        isWallet: card.isWallet ? true : false,
        gan: card.gan,
        balance: card.balance,
      );

      Navigator.pop(context);
    } else {
      ModalBottomSheet().partScreen(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        context: context,
        builder: (context) => EditPaymentMethodSheet(card: card),
      );
    }
  }
}
