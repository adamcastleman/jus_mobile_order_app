import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/payments_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class ApplePaySelectedTile extends ConsumerWidget {
  const ApplePaySelectedTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final applePaySelected = ref.watch(applePaySelectedProvider);
    return ListTile(
      leading: const FaIcon(FontAwesomeIcons.apple),
      title: Row(
        children: [
          const Text('Pay with'),
          Spacing.horizontal(6),
          const FaIcon(
            FontAwesomeIcons.applePay,
            color: Colors.black,
            size: 35,
          ),
        ],
      ),
      trailing: applePaySelected ? const ChevronRightIcon() : const SizedBox(),
      onTap: () {
        if (!applePaySelected) {
          ref.read(applePaySelectedProvider.notifier).state = true;
        } else if (user.uid == null) {
          ref.invalidate(applePaySelectedProvider);
          ModalBottomSheet().partScreen(
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) => const ChoosePaymentTypeSheet(),
          );
        } else {
          ref.read(pageTypeProvider.notifier).state =
              PageType.selectPaymentMethod;
          ModalBottomSheet().fullScreen(
              context: context,
              builder: (context) => const PaymentSettingsSheet());
        }
      },
    );
  }
}
