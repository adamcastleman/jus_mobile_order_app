import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/edit_payment_method_sheet.dart';

class SavedPaymentTile extends ConsumerWidget {
  final PaymentsModel card;
  const SavedPaymentTile({required this.card, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String cardTitle =
        PaymentsHelper().displaySelectedCardTextFromPaymentModel(card);
    return ListTile(
      leading: const PaymentMethodIcon(),
      title: AutoSizeText(
        cardTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: card.defaultPayment ? const Text('Default') : const SizedBox(),
      trailing: const ChevronRightIcon(),
      onTap: () => _handleTap(ref, context),
    );
  }

  void _handleTap(WidgetRef ref, BuildContext context) {
    final pageType = ref.read(pageTypeProvider);
    ref.read(cardNicknameProvider.notifier).state = card.cardNickname;
    if (pageType == PageType.scanPage) {
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
      PaymentsHelper().updatePaymentMethod(
        reference: reference,
        cardNickname: card.cardNickname,
        nonce: card.nonce,
        lastFourDigits: card.lastFourDigits,
        brand: card.brand.toString(),
        isGiftCard: card.isGiftCard ? true : false,
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
