import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
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
    final cardNickname =
        card.cardNickname.isEmpty ? '' : '${card.cardNickname} ';
    final brandName = card.isGiftCard ? '' : '- ${card.brand.capitalize} ';
    final lastFourDigits = 'ending in ${card.lastFourDigits}';

    final cardTitle = [cardNickname, brandName, lastFourDigits].join().trim();

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

    if (pageType == PageType.scanPage) {
      PaymentsHelper().updatePaymentMethod(
        ref: ref,
        cardNickname: card.cardNickname,
        nonce: card.nonce,
        lastFourDigits: card.lastFourDigits,
        brand: card.brand.toString(),
      );

      ref.invalidate(pageTypeProvider);
      Navigator.pop(context);
    } else if (pageType == PageType.paymentMethodsPage) {
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
