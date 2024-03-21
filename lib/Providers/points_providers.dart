import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';

final pointsInformationProvider = StateProvider<PointsDetailsModel>(
  (ref) => const PointsDetailsModel(
    uid: '',
    perks: [],
    rewardsAmounts: [],
    name: '',
    pointsPerDollar: 0,
    memberPointsPerDollar: 0,
    walletPointsPerDollar: 0,
    walletPointsPerDollarMember: 0,
    pointsStatus: '',
    memberPointsStatus: '',
  ),
);

final rewardAmountIndexProvider = StateProvider<int>((ref) => 0);

final pointsInUseProvider = StateProvider<int>((ref) => 0);

final isRewardsAvailableProvider =
    StateProvider.autoDispose<bool>((ref) => true);

final rewardQuantityProvider =
    StateNotifierProvider.autoDispose<RewardInUse, List<Map<String, int>>>(
        (ref) => RewardInUse());

final totalPointsProvider =
    StateNotifierProvider.autoDispose<TotalPoints, int>((ref) => TotalPoints());

class RewardInUse extends StateNotifier<List<Map<String, int>>> {
  RewardInUse() : super([]);

  void addReward({
    required ref,
    required int index,
    required Map maxRewardQuantity,
    required int length,
    required int points,
  }) {
    var rewards = ref.watch(rewardQuantityProvider);
    if (rewards.length < length) {
      rewards = List.generate(
          length,
          (i) => i == index
              ? {'points': points, 'rewardValue': points, 'quantity': 1}
              : {'points': 0, 'rewardValue': 0, 'quantity': 0});
    } else {
      int rewardValue = rewards[index]['rewardValue'] ?? 0;
      if (maxRewardQuantity.containsKey(rewardValue)) {
        int maxItems = maxRewardQuantity[rewardValue];
        int currentQuantity = rewards[index]['quantity'] ?? 0;
        if (currentQuantity >= maxItems) {
          return;
        }
      }

      rewards[index]['points'] = (rewards[index]['points'] ?? 0) + points;
      rewards[index]['rewardValue'] = points;
      rewards[index]['quantity'] = (rewards[index]['quantity'] ?? 0) + 1;
    }

    maxRewardQuantity.forEach((key, value) {
      for (var item in rewards) {
        if (item['rewardValue'] == key) {
          item['maxItems'] = value;
          continue;
        }
      }
    });

    int totalPoints = rewards
        .map((map) => map['points'] ?? 0)
        .reduce((acc, value) => acc + value);
    ref.read(pointsInUseProvider.notifier).state = totalPoints;

    state = [...rewards];
  }

  void removeReward(
      {required ref,
      required List<Map<String, int>> rewards,
      required int index,
      required int points}) {
    bool firstTimeZero = false;
    int updatedPoints = (rewards[index]['points'] ?? 0) - points;
    int updatedQuantity = (rewards[index]['quantity'] ?? 0) - 1;
    if (rewards[index]['quantity'] == 1) {
      firstTimeZero = true;
    }
    if (updatedQuantity <= 0 || updatedPoints < 0) {
      rewards[index]['points'] = 0;
      rewards[index]['quantity'] = 0;
    } else {
      rewards[index]['points'] = updatedPoints;
      rewards[index]['quantity'] = updatedQuantity;
    }

    int totalPoints = rewards
        .map((map) => map['points'] ?? 0)
        .reduce((acc, value) => acc + value);
    ref.read(pointsInUseProvider.notifier).state = totalPoints;
    if (firstTimeZero || updatedQuantity > 0) {}
    state = [...rewards];
  }
}

class TotalPoints extends StateNotifier<int> {
  TotalPoints() : super(0);

  set(int points) {
    state = points;
  }
}
