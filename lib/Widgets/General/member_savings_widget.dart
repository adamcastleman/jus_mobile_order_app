import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';

class MemberSavingsWidget extends ConsumerWidget {
  final UserModel user;
  final ProductModel product;
  final VoidCallback onTap;
  const MemberSavingsWidget(
      {required this.user,
      required this.product,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    return Row(
      children: [
        determineSavedAmount(ref, isMember),
        Spacing.horizontal(5),
        const MemberIcon(
          iconSize: 10,
        ),
        Spacing.horizontal(5),
        isMember
            ? const SizedBox()
            : InfoButton(
                onTap: onTap,
                size: 22,
              ),
      ],
    );
  }

  Text determineSavedAmount(WidgetRef ref, bool isMember) {
    final savedAmount =
        PricingHelpers().individualProductSavingsForMembers(ref, product);
    final message =
        'You${!isMember ? ' could have' : ''} saved \$${PricingHelpers.formatAsCurrency(savedAmount)}';
    return Text(message, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
