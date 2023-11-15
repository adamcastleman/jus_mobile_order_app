import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/membership_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_amount_display.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';

class PriceDisplay extends ConsumerWidget {
  final ProductModel product;
  const PriceDisplay({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        determinePriceRow(ref, user),
        Spacing().vertical(10),
        Row(
          children: [
            determineSavedAmount(ref, user),
            Spacing().horizontal(5),
            const MemberIcon(
              iconSize: 10,
            ),
            Spacing().horizontal(5),
            user.uid == null || !user.isActiveMember!
                ? InfoButton(
                    onTap: () {
                      ModalBottomSheet().fullScreen(
                        context: context,
                        builder: (context) => const MembershipDetailPage(),
                      );
                    },
                    size: 22,
                  )
                : const SizedBox(),
          ],
        ),
        Spacing().vertical(10),
        PointsAmountDisplay(
          padding: 4.0,
          product: product,
          fontSize: 14,
          hasBorder: true,
        ),
      ],
    );
  }

  Row determinePriceRow(WidgetRef ref, UserModel user) {
    final isMember = user.uid != null && user.isActiveMember!;
    final quantity = ref.watch(itemQuantityProvider);
    final nonMemberPrice =
        Pricing(ref: ref).productDetailPriceNonMember(product);
    final memberPrice = Pricing(ref: ref).productDetailPriceForMembers(product);

    return Row(
      children: [
        _buildPriceText(
          label: 'Non-Member',
          price: nonMemberPrice,
          quantity: quantity,
          bold: !isMember,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('|'),
        ),
        _buildPriceText(
          label: 'Members',
          price: memberPrice,
          quantity: quantity,
          bold: isMember,
        ),
      ],
    );
  }

  AutoSizeText _buildPriceText(
      {required String label,
      required double price,
      required int quantity,
      required bool bold}) {
    return AutoSizeText(
      '$label: \$${NumberFormat('#,##0.00').format(price)}${quantity == 1 ? '' : '/ea'}',
      style: TextStyle(
        fontSize: 14,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Text determineSavedAmount(WidgetRef ref, UserModel user) {
    final savedAmount =
        Pricing(ref: ref).individualProductSavingsForMembers(product);
    final isMember = user.uid != null && user.isActiveMember!;
    final message =
        'You${!isMember ? ' could have' : ''} saved \$${NumberFormat('#,##0.00').format(savedAmount)}';
    return Text(message, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
