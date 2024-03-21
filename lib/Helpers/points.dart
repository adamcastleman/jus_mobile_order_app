import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PointsHelper {
  List availableRewards(
      WidgetRef ref, UserModel user, PointsDetailsModel points) {
    final eligibleRewards =
        getEligibleRewards(points.rewardsAmounts, user.points!);
    final applicableRewards = getApplicableRewards(ref, eligibleRewards);

    return applicableRewards;
  }

  List getEligibleRewards(List rewardsAmounts, int totalPoints) {
    return rewardsAmounts
        .where((rewards) => rewards['amount'] <= totalPoints)
        .toList();
  }

  List getApplicableRewards(WidgetRef ref, List rewardsAmounts) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return rewardsAmounts
        .where((rewards) => rewards['products'].any((products) => currentOrder
            .map((element) => element['productId'])
            .contains(products)))
        .toList();
  }

  getPointValue(String variable1, List list1) {
    for (var item in list1) {
      if (item['products'].contains(variable1)) {
        return item['amount'];
      }
    }
    return null;
  }

  String pointsDisplayText(
      {required WidgetRef ref,
      required bool isWallet,
      bool applyPointsMultiplier = false}) {
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);
    final pointsMultiple =
        applyPointsMultiplier ? ref.watch(pointsMultiplierProvider) : 1.0;

    return currentUser.when(
      error: (e, _) => '{error}',
      loading: () => '{error}',
      data: (user) => pointsDetails.when(
        error: (e, _) => '{error}',
        loading: () => '{error}',
        data: (points) {
          var pointValue = isWallet
              ? points.walletPointsPerDollar * pointsMultiple
              : points.pointsPerDollar * pointsMultiple;

          var memberPointsValue = isWallet
              ? points.walletPointsPerDollarMember * pointsMultiple
              : points.memberPointsPerDollar * pointsMultiple;
          if (user.uid == null ||
              user.subscriptionStatus != SubscriptionStatus.active) {
            if (pointValue.isWhole()) {
              return '${pointValue.toInt()} point';
            } else {
              return '${pointValue.toStringAsFixed(1)} points';
            }
          } else {
            if (memberPointsValue == 1 || memberPointsValue == 1.0) {
              return '${memberPointsValue.toInt()} point';
            } else if (memberPointsValue.isWhole()) {
              return '${memberPointsValue.toInt()} points';
            } else {
              return '${memberPointsValue.toStringAsFixed(1)} points';
            }
          }
        },
      ),
    );
  }

  determinePointsMultiple(
      WidgetRef ref, UserModel user, PointsDetailsModel points) {
    final pointsMultiplier = ref.watch(pointsMultiplierProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);

    if (user.uid == null) {
      return 0;
    }

    bool isWallet = selectedPaymentMethod.userId.isEmpty &&
        selectedPaymentMethod.isWallet == true;
    bool isActiveMember = user.subscriptionStatus == SubscriptionStatus.active;

    int pointsPerDollar =
        isActiveMember ? points.memberPointsPerDollar : points.pointsPerDollar;
    num walletPointsPerDollar = isActiveMember
        ? points.walletPointsPerDollarMember
        : points.walletPointsPerDollar;

    return isWallet
        ? walletPointsPerDollar * pointsMultiplier
        : pointsPerDollar * pointsMultiplier;
  }

  totalEarnedPoints(WidgetRef ref, UserModel user, PointsDetailsModel points) {
    final pointsFromOrder = _calculatePointsFromOrder(ref, user);

    final pointsMultiple = determinePointsMultiple(ref, user, points);
    final earnedPoints = pointsFromOrder * pointsMultiple;
    return earnedPoints.truncate();
  }

  double _calculatePointsFromOrder(WidgetRef ref, UserModel user) {
    final PricingHelpers pricing = PricingHelpers();
    if (user.uid == null) {
      return 0;
    } else if (user.subscriptionStatus != SubscriptionStatus.active) {
      return pricing.discountedSubtotalForNonMembers(ref);
    } else {
      return pricing.discountedSubtotalForMembers(ref);
    }
  }
}
