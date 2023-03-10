import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

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
              getEligibleRewards(reward.rewardsAmounts, user.totalPoints!);
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

  String determinePointsMultipleText({required bool isJusCard}) {
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
          var pointValue = isJusCard
              ? points.jusCardPointsPerDollar * pointsMultiple
              : points.pointsPerDollar * pointsMultiple;
          var memberPointsValue = isJusCard
              ? points.jusCardPointsPerDollarMember * pointsMultiple
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
    final selectedPaymentMethod = ref.watch(selectedCreditCardProvider);

    return currentUser.when(
      error: (e, _) => '{error}',
      loading: () => '{error}',
      data: (user) => pointsDetails.when(
        error: (e, _) => '{error}',
        loading: () => '{error}',
        data: (points) {
          var jusCardPointsValue = points.jusCardPointsPerDollar;
          var jusCardMemberPointsValue = points.jusCardPointsPerDollarMember;
          var creditCardPointsValue = points.pointsPerDollar;
          var creditCardMemberPointsValue = points.memberPointsPerDollar;

          if (user.uid == null) {
            return 0;
          }

          if (!user.isActiveMember! &&
              selectedPaymentMethod['isGiftCard'] == true) {
            return jusCardPointsValue * pointsMultiplier;
          } else if (!user.isActiveMember! &&
              selectedPaymentMethod['isGiftCard'] != true) {
            return creditCardPointsValue * pointsMultiplier;
          } else if (user.isActiveMember! &&
              selectedPaymentMethod['isGiftCard'] == true) {
            return jusCardMemberPointsValue * pointsMultiplier;
          } else if (user.isActiveMember! &&
              selectedPaymentMethod['isGiftCard'] != true) {
            return creditCardMemberPointsValue * pointsMultiplier;
          }
        },
      ),
    );
  }
}

extension NumExtension on num {
  bool isWhole() {
    return remainder(1) == 0;
  }
}
