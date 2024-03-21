import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_multiple_text_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';

import '../../Providers/stream_providers.dart';

class TotalPrice extends ConsumerWidget {
  const TotalPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          buildOriginalSubtotalRow(ref, user),
          ref.watch(discountTotalProvider).isEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    Spacing.vertical(10),
                    buildDiscountRow(ref, user),
                    Spacing.vertical(10),
                    buildSubtotalWithDiscountRow(ref, user),
                  ],
                ),
          Spacing.vertical(10),
          buildTaxesRow(ref, user),
          ref.watch(selectedTipIndexProvider) == 0
              ? const SizedBox()
              : Spacing.vertical(10),
          ref.watch(selectedTipIndexProvider) == 0
              ? const SizedBox()
              : buildTipRow(ref, user),
          user.uid != null ? Spacing.vertical(10) : const SizedBox(),
          user.uid != null ? buildPointsRow(ref) : const SizedBox(),
          Spacing.vertical(30),
          buildOrderTotalRow(ref, user),
          Spacing.vertical(20),
          PricingHelpers().discountedSubtotalForNonMembers(ref) <= 0.0
              ? const SizedBox()
              : buildSavedAmountRow(context, ref, user),
        ],
      ),
    );
  }

  Widget buildOriginalSubtotalRow(
    WidgetRef ref,
    UserModel user,
  ) {
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final pricing = PricingHelpers();

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
                '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForNonMembers(ref))}',
                style: ref.watch(priceLineThroughStyleProvider),
              ),
              Spacing.horizontal(10),
              Text(
                '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForMembers(ref))}',
                style: ref.watch(priceNormalStyleProvider),
              ),
            ],
          ),
        if (!isMember)
          Text(
            '\$${NumberFormat('#,##0.00').format(pricing.originalSubtotalForNonMembers(ref))}',
            style: ref.watch(priceNormalStyleProvider),
          ),
      ],
    );
  }

  Widget buildDiscountRow(WidgetRef ref, UserModel user) {
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final double discountTotal = !isMember
        ? PricingHelpers().discountTotalForNonMembers(ref)
        : PricingHelpers().discountTotalForMembers(ref);

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
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final subtotal = !isMember
        ? PricingHelpers().discountedSubtotalForNonMembers(ref)
        : PricingHelpers().discountedSubtotalForMembers(ref);
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
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final tipAmount = !isMember
        ? PricingHelpers().tipAmountForNonMembers(ref)
        : PricingHelpers().tipAmountForMembers(ref);
    if (tipAmount == 0) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tip ${EmojiParser().get(':heart:').code}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(tipAmount)}',
          style: ref.watch(priceNormalStyleProvider),
        ),
      ],
    );
  }

  buildTaxesRow(WidgetRef ref, UserModel user) {
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Taxes',
          style: TextStyle(fontSize: 16),
        ),
        !isMember
            ? Text(
                '\$${NumberFormat('#,##0.00').format(
                  PricingHelpers().totalTaxForNonMembers(ref),
                )}',
                style: ref.watch(priceNormalStyleProvider),
              )
            : Text(
                '\$${NumberFormat('#,##0.00').format(
                  PricingHelpers().totalTaxForMembers(ref),
                )}',
                style: ref.watch(priceNormalStyleProvider),
              ),
      ],
    );
  }

  orderTotal(WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    if (!isMember) {
      return NumberFormat('#,##0.00')
          .format(PricingHelpers().orderTotalForNonMembers(ref));
    } else {
      return NumberFormat('#,##0.00')
          .format(PricingHelpers().orderTotalForMembers(ref));
    }
  }

  Widget buildOrderTotalRow(WidgetRef ref, UserModel user) {
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
          '\$${orderTotal(ref)}',
          style: ref.watch(priceBoldProvider),
        ),
      ],
    );
  }

  Widget buildPointsRow(WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final points = ref.watch(pointsInformationProvider);
    final pointsHelper = PointsHelper();
    final earnedPoints = pointsHelper.totalEarnedPoints(ref, user, points);

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
                  '+$earnedPoints',
                  style: ref.watch(priceGreenStyleProvider),
                ),
              ],
            ),
            PointsMultipleText(
              points: points,
              textStyle: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSavedAmountRow(
      BuildContext context, WidgetRef ref, UserModel user) {
    final PricingHelpers pricingHelpers = PricingHelpers();
    final savedAmount = pricingHelpers.totalOrderSavings(ref);
    const couldHaveSavedText = 'You could have saved \$';
    const savedText = 'You saved \$';
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;

    if (pricingHelpers.originalSubtotalForNonMembers(ref) ==
        pricingHelpers.discountTotalForNonMembers(ref)) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${isMember ? savedText : couldHaveSavedText}${NumberFormat('#,##0.00').format(savedAmount)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Spacing.horizontal(5),
        if (!isMember) const MemberIcon(iconSize: 10),
        if (!isMember)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: InfoButton(
              size: 22,
              onTap: () {
                if (PlatformUtils.isWeb()) {
                  NavigationHelpers.popEndDrawer(context);
                }
                NavigationHelpers.handleMembershipNavigation(
                  context,
                  ref,
                  user,
                  showCloseButton:
                      PlatformUtils.isIOS() || PlatformUtils.isAndroid(),
                );
              },
            ),
          )
        else
          const MemberIcon(iconSize: 12),
      ],
    );
  }
}
