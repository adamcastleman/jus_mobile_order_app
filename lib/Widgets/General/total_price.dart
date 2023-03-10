import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/membership_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';

import '../../Providers/stream_providers.dart';

class TotalPrice extends ConsumerWidget {
  const TotalPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              buildOriginalSubtotalRow(ref, user),
              ref.watch(discountTotalProvider).isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        Spacing().vertical(10),
                        buildDiscountRow(ref, user),
                        Spacing().vertical(10),
                        buildSubtotalWithDiscountRow(ref, user),
                      ],
                    ),
              Spacing().vertical(10),
              buildTaxesRow(ref, user),
              ref.watch(selectedTipIndexProvider) == 0
                  ? const SizedBox()
                  : Spacing().vertical(10),
              ref.watch(selectedTipIndexProvider) == 0
                  ? const SizedBox()
                  : buildTipRow(ref, user),
              user.uid != null ? Spacing().vertical(10) : const SizedBox(),
              user.uid != null ? buildPointsRow(ref) : const SizedBox(),
              Spacing().vertical(30),
              buildOrderTotalRow(ref, user),
              Spacing().vertical(20),
              Pricing(ref: ref).discountedSubtotalForNonMembers() == 0.00
                  ? const SizedBox()
                  : buildSavedAmountRow(context, ref, user),
            ],
          ),
        );
      },
    );
  }

  Widget buildOriginalSubtotalRow(
    WidgetRef ref,
    UserModel user,
  ) {
    final isMember = user.uid != null && user.isActiveMember == true;
    final pricing = Pricing(ref: ref);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ref.watch(discountTotalProvider).isEmpty ? 'Subtotal' : 'Original',
          style: const TextStyle(fontSize: 16),
        ),
        if (isMember)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForNonMembers())}',
                style: ref.watch(priceLineThroughStyle),
              ),
              Spacing().horizontal(10),
              Text(
                '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForMembers())}',
                style: ref.watch(priceNormalStyleProvider),
              ),
            ],
          ),
        if (!isMember)
          Text(
            '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForNonMembers())}',
            style: ref.watch(priceNormalStyleProvider),
          ),
      ],
    );
  }

  Widget buildDiscountRow(WidgetRef ref, UserModel user) {
    final String discountTotal = user.uid == null || !user.isActiveMember!
        ? Pricing(ref: ref).discountTotalForNonMembers().toStringAsFixed(2)
        : Pricing(ref: ref).discountTotalForMembers().toStringAsFixed(2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Discounts',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(discountTotal)}',
          style: ref.watch(priceGreenStyleProvider),
        ),
      ],
    );
  }

  Widget buildSubtotalWithDiscountRow(WidgetRef ref, UserModel user) {
    final subtotal = user.uid == null || !user.isActiveMember!
        ? Pricing(ref: ref).discountedSubtotalForNonMembers()
        : Pricing(ref: ref).discountedSubtotalForMembers();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Subtotal',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(subtotal)}',
          style: ref.watch(priceNormalStyleProvider),
        ),
      ],
    );
  }

  Widget buildTipRow(WidgetRef ref, UserModel user) {
    final tipAmount = user.uid == null || !user.isActiveMember!
        ? Pricing(ref: ref).tipAmountForNonMembers()
        : Pricing(ref: ref).tipAmountForMembers();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tip',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(tipAmount)}',
          style: ref.watch(priceNormalStyleProvider),
        ),
      ],
    );
  }

  buildTaxesRow(WidgetRef ref, UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Taxes',
          style: TextStyle(fontSize: 16),
        ),
        user.uid == null || !user.isActiveMember!
            ? Text(
                '\$${NumberFormat('#,##0.00').format(Pricing(ref: ref).totalTaxForNonMembers())}',
                style: ref.watch(priceNormalStyleProvider),
              )
            : Text(
                '\$${NumberFormat('#,##0.00').format(Pricing(ref: ref).totalTaxForMembers())}',
                style: ref.watch(priceNormalStyleProvider),
              ),
      ],
    );
  }

  Widget buildOrderTotalRow(WidgetRef ref, UserModel user) {
    double orderTotal = user.uid == null || !user.isActiveMember!
        ? Pricing(ref: ref).orderTotalForNonMembers()
        : Pricing(ref: ref).orderTotalForMembers();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(orderTotal)}',
          style: ref.watch(priceBoldProvider),
        ),
      ],
    );
  }

  Widget buildSavedAmountRow(
      BuildContext context, WidgetRef ref, UserModel user) {
    final savedAmount = Pricing(ref: ref).totalOrderSavings();
    const couldHaveSavedText = 'You could have saved \$';
    const savedText = 'You saved \$';

    if (Pricing(ref: ref).originalSubtotalForNonMembers() ==
        Pricing(ref: ref).discountTotalForNonMembers()) {
      return const SizedBox();
    } else if (user.uid == null || !user.isActiveMember!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${user.uid == null || !user.isActiveMember! ? couldHaveSavedText : savedText}${NumberFormat('#,##0.00').format(savedAmount)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacing().horizontal(5),
          const MemberIcon(iconSize: 10),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: InfoButton(
              size: 22,
              color: Colors.grey[700]!,
              onTap: () {
                ModalBottomSheet().fullScreen(
                  context: context,
                  builder: (context) => const MembershipDetailPage(),
                );
              },
            ),
          ),
        ],
      );
    } else if (user.isActiveMember!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${user.isActiveMember! ? savedText : couldHaveSavedText}${NumberFormat('#,##0.00').format(savedAmount)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacing().horizontal(5),
          const MemberIcon(iconSize: 12),
        ],
      );
    } else {
      return const Text('');
    }
  }

  Widget buildPointsRow(WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
              error: e.toString(),
            ),
        data: (user) {
          final pointsFromOrder =
              _calculatePointsFromOrder(user, Pricing(ref: ref));
          final pointsMultiple =
              PointsHelper(ref: ref).determinePointsMultiple();
          final earnedPoints = pointsFromOrder * pointsMultiple;

          if (earnedPoints == 0) {
            return const SizedBox();
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Points',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '+${NumberFormat('#,###').format(earnedPoints.truncateToDouble())}',
                        style: ref.watch(priceGreenStyleProvider),
                      ),
                    ],
                  ),
                  Text(
                    '${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: ref.watch(selectedCreditCardProvider)['isGiftCard'] ?? false)}/\$1',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          );
        });
  }

  double _calculatePointsFromOrder(UserModel user, Pricing pricing) {
    if (user.uid == null) {
      return 0;
    } else if (!user.isActiveMember!) {
      return pricing.discountedSubtotalForNonMembers();
    } else {
      return pricing.discountedSubtotalForMembers();
    }
  }
}
