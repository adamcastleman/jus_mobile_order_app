import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import 'loading.dart';

class PointsHelper {
  final WidgetRef ref;
  PointsHelper({required this.ref});

  List availableRewards() {
    final currentUser = ref.watch(currentUserProvider);
    final rewards = ref.watch(pointsDetailsProvider);
    return currentUser.when(
      error: (e, _) => [],
      loading: () => [],
      data: (user) => rewards.when(
        error: (e, _) => [],
        loading: () => [],
        data: (reward) {
          final eligibleRewards =
              getEligibleRewards(reward.rewardsAmounts, user.points!);
          final applicableRewards = getApplicableRewards(eligibleRewards);

          return applicableRewards;
        },
      ),
    );
  }

  List getEligibleRewards(List rewardsAmounts, int totalPoints) {
    return rewardsAmounts
        .where((rewards) => rewards['amount'] <= totalPoints)
        .toList();
  }

  List getApplicableRewards(List rewardsAmounts) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return rewardsAmounts
        .where((rewards) => rewards['products'].any((products) => currentOrder
            .map((element) => element['productID'])
            .contains(products)))
        .toList();
  }

  getPointValue(int variable1, List list1) {
    for (var item in list1) {
      if (item['products'].contains(variable1)) {
        return item['amount'];
      }
    }
    return null;
  }

  String determinePointsMultipleText({required bool isWallet}) {
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);
    final pointsMultiple = ref.watch(pointsMultiplierProvider);

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
          if (user.uid == null || !user.isActiveMember!) {
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

  determinePointsMultiple() {
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);
    final pointsMultiplier = ref.watch(pointsMultiplierProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);

    return currentUser.when(
      error: (e, _) => '{error}',
      loading: () => '{error}',
      data: (user) => pointsDetails.when(
        error: (e, _) => '{error}',
        loading: () => '{error}',
        data: (points) {
          var walletPointsValue = points.walletPointsPerDollar;
          var walletMemberPointsValue = points.walletPointsPerDollarMember;
          var creditCardPointsValue = points.pointsPerDollar;
          var creditCardMemberPointsValue = points.memberPointsPerDollar;

          if (user.uid == null || selectedPaymentMethod['isWallet'] == null) {
            return 0;
          } else if (!user.isActiveMember! &&
              selectedPaymentMethod['isWallet']) {
            return walletPointsValue * pointsMultiplier;
          } else if (!user.isActiveMember! &&
              selectedPaymentMethod['isWallet'] == false) {
            return creditCardPointsValue * pointsMultiplier;
          } else if (user.isActiveMember! &&
              selectedPaymentMethod['isWallet']) {
            return walletMemberPointsValue * pointsMultiplier;
          } else if (user.isActiveMember! &&
              selectedPaymentMethod['isWallet'] == false) {
            return creditCardMemberPointsValue * pointsMultiplier;
          }
        },
      ),
    );
  }

  totalEarnedPoints() {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) {
        final pointsFromOrder =
            _calculatePointsFromOrder(user, Pricing(ref: ref));
        final pointsMultiple = PointsHelper(ref: ref).determinePointsMultiple();

        final earnedPoints = pointsFromOrder * pointsMultiple;
        return earnedPoints.truncate();
      },
    );
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
